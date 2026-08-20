import 'package:flutter/material.dart';

import '../data/content_repository.dart';
import '../models/achievement.dart';
import '../models/language.dart';
import '../models/phrase.dart';
import '../models/scenario.dart';
import '../models/srs_card.dart';
import '../services/storage_service.dart';
import '../services/tts_service.dart';

/// Trạng thái toàn cục: ngôn ngữ đang học, tiến độ SRS, streak, mục tiêu ngày.
class AppState extends ChangeNotifier {
  AppState({
    required StorageService storage,
    required TtsService tts,
    ContentRepository repository = const ContentRepository(),
  })  : _storage = storage,
        _tts = tts,
        _repository = repository {
    _restore();
  }

  final StorageService _storage;
  final TtsService _tts;
  final ContentRepository _repository;

  ContentRepository get repository => _repository;
  TtsService get tts => _tts;

  LearningLanguage _language = LearningLanguage.all.first;
  Map<String, SrsCard> _cards = <String, SrsCard>{};
  Map<String, int> _quizBest = <String, int>{};
  Map<String, int> _gameBest = <String, int>{};
  Set<String> _favourites = <String>{};
  Set<String> _activeDays = <String>{};
  int _streak = 0;
  String? _streakDate;
  int _dailyGoal = 10;
  int _reviewedToday = 0;
  bool _onboarded = false;

  LearningLanguage get language => _language;
  bool get hasOnboarded => _onboarded;
  int get streak => _streak;
  int get dailyGoal => _dailyGoal;
  int get reviewedToday => _reviewedToday;

  double get dailyProgress =>
      _dailyGoal == 0 ? 0 : (_reviewedToday / _dailyGoal).clamp(0.0, 1.0);

  List<Scenario> get scenarios => _repository.scenariosFor(_language.code);

  List<Phrase> get allPhrases => _repository.allPhrases(_language.code);

  // --- Khởi tạo ---

  void _restore() {
    _onboarded = _storage.hasOnboarded;
    final String? saved = _storage.selectedLanguage;
    if (saved != null) {
      _language = LearningLanguage.byCode(saved);
    }
    _loadLanguageData(_language.code);
    _streak = _storage.streakCount;
    _streakDate = _storage.streakLastDate;
    _activeDays = _storage.activeDays;
    _dailyGoal = _storage.dailyGoal;
    _reviewedToday =
        _storage.reviewedDate == todayKey() ? _storage.reviewedToday : 0;
  }

  void _loadLanguageData(String code) {
    _cards = _storage.loadCards(code);
    _quizBest = _storage.loadQuizBest(code);
    _gameBest = _storage.loadGameBest(code);
    _favourites = _storage.loadFavourites(code);
  }

  /// Khoá ngày dạng `yyyy-MM-dd` cho hôm nay.
  static String todayKey() => dayKey(DateTime.now());

  /// Khoá ngày dạng `yyyy-MM-dd` cho [date].
  static String dayKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  // --- Ngôn ngữ ---

  Future<void> selectLanguage(LearningLanguage value) async {
    if (value.code == _language.code) return;
    _language = value;
    await _storage.setSelectedLanguage(value.code);
    _loadLanguageData(value.code);
    notifyListeners();
  }

  Future<void> completeOnboarding(LearningLanguage value) async {
    _language = value;
    _onboarded = true;
    await _storage.setSelectedLanguage(value.code);
    await _storage.setOnboarded();
    _loadLanguageData(value.code);
    notifyListeners();
  }

  // --- Thẻ SRS ---

  SrsCard cardFor(String phraseId) =>
      _cards[phraseId] ?? SrsCard(phraseId: phraseId);

  /// true nếu câu đã được học ít nhất một lần.
  bool isLearned(String phraseId) => _cards.containsKey(phraseId);

  /// Các thẻ đến hạn ôn hôm nay, thẻ quá hạn lâu nhất lên trước.
  List<Phrase> get duePhrases {
    final List<Phrase> due = allPhrases
        .where((Phrase p) => _cards.containsKey(p.id) && _cards[p.id]!.isDue)
        .toList();
    due.sort((Phrase a, Phrase b) {
      final DateTime x =
          _cards[a.id]?.dueDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      final DateTime y =
          _cards[b.id]?.dueDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      return x.compareTo(y);
    });
    return due;
  }

  /// Câu chưa từng học lần nào.
  List<Phrase> get newPhrases =>
      allPhrases.where((Phrase p) => !_cards.containsKey(p.id)).toList();

  int get dueCount => duePhrases.length;

  int get learnedCount => _cards.length;

  int get masteredCount =>
      _cards.values.where((SrsCard c) => c.isMastered).length;

  int get totalPhraseCount => allPhrases.length;

  /// Ghi nhận một lần ôn thẻ và cập nhật lịch lặp lại ngắt quãng.
  Future<void> reviewPhrase(String phraseId, RecallQuality quality) async {
    final SrsCard card = _cards.putIfAbsent(
      phraseId,
      () => SrsCard(phraseId: phraseId),
    );
    card.review(quality);
    _reviewedToday += 1;
    await _storage.saveCards(_language.code, _cards);
    await _storage.saveReviewedToday(_reviewedToday, todayKey());
    await _bumpStreak();
    notifyListeners();
  }

  Future<void> _bumpStreak() async {
    final String today = todayKey();
    if (!_activeDays.contains(today)) {
      _activeDays = <String>{..._activeDays, today};
      await _storage.saveActiveDays(_activeDays);
    }
    if (_streakDate == today) return;

    final String yesterday =
        dayKey(DateTime.now().subtract(const Duration(days: 1)));

    _streak = _streakDate == yesterday ? _streak + 1 : 1;
    _streakDate = today;
    await _storage.saveStreak(_streak, today);
  }

  // --- Câu yêu thích ---

  bool isFavourite(String phraseId) => _favourites.contains(phraseId);

  int get favouriteCount => _favourites.length;

  List<Phrase> get favouritePhrases =>
      allPhrases.where((Phrase p) => _favourites.contains(p.id)).toList();

  Future<void> toggleFavourite(String phraseId) async {
    final Set<String> next = <String>{..._favourites};
    if (!next.remove(phraseId)) {
      next.add(phraseId);
    }
    _favourites = next;
    await _storage.saveFavourites(_language.code, _favourites);
    notifyListeners();
  }

  // --- Tiến độ theo tình huống ---

  /// Tỉ lệ 0..1 số câu trong [scenario] đã được học ít nhất một lần.
  double scenarioProgress(Scenario scenario) {
    if (scenario.phrases.isEmpty) return 0;
    final int seen = scenario.phrases
        .where((Phrase p) => _cards.containsKey(p.id))
        .length;
    return seen / scenario.phrases.length;
  }

  int scenarioLearnedCount(Scenario scenario) => scenario.phrases
      .where((Phrase p) => _cards.containsKey(p.id))
      .length;

  /// Tình huống được mở khoá khi tình huống trước đạt ít nhất 50%.
  bool isScenarioUnlocked(Scenario scenario) {
    if (scenario.order == 0) return true;
    final List<Scenario> all = scenarios;
    final Scenario previous =
        all.firstWhere((Scenario s) => s.order == scenario.order - 1);
    return scenarioProgress(previous) >= 0.5;
  }

  int get unlockedScenarioCount =>
      scenarios.where(isScenarioUnlocked).length;

  // --- Quiz ---

  int quizBest(String scenarioCode) => _quizBest[scenarioCode] ?? 0;

  Future<void> recordQuizScore(String scenarioCode, int percent) async {
    if (percent <= quizBest(scenarioCode)) return;
    _quizBest[scenarioCode] = percent;
    await _storage.saveQuizBest(_language.code, _quizBest);
    notifyListeners();
  }

  int get bestQuizScore {
    int best = 0;
    for (final int value in _quizBest.values) {
      if (value > best) best = value;
    }
    return best;
  }

  // --- Trò luyện tập ---

  int gameBest(String gameId) => _gameBest[gameId] ?? 0;

  /// Lưu điểm cao mới của một trò chơi. Trả về true nếu đây là kỷ lục.
  Future<bool> recordGameScore(String gameId, int score) async {
    if (score <= gameBest(gameId)) return false;
    _gameBest[gameId] = score;
    await _storage.saveGameBest(_language.code, _gameBest);
    notifyListeners();
    return true;
  }

  int get totalGameBest {
    int total = 0;
    for (final int value in _gameBest.values) {
      total += value;
    }
    return total;
  }

  // --- Lịch học ---

  Set<String> get activeDays => _activeDays;

  bool studiedOn(DateTime date) => _activeDays.contains(dayKey(date));

  /// Số ngày có học trong [days] ngày gần nhất, tính cả hôm nay.
  int activeDaysIn(int days) {
    final DateTime now = DateTime.now();
    int count = 0;
    for (int i = 0; i < days; i++) {
      if (_activeDays.contains(dayKey(now.subtract(Duration(days: i))))) {
        count += 1;
      }
    }
    return count;
  }

  // --- Huy hiệu thành tích ---

  List<Achievement> get achievements => <Achievement>[
        Achievement(
          id: 'first_step',
          title: 'Bước chân đầu tiên',
          description: 'Học câu đầu tiên của bạn',
          emoji: '👣',
          color: const Color(0xFF3B82F6),
          current: learnedCount,
          target: 1,
        ),
        Achievement(
          id: 'traveller_25',
          title: 'Khách du lịch',
          description: 'Tiếp xúc 25 câu',
          emoji: '🎒',
          color: const Color(0xFF0EA5E9),
          current: learnedCount,
          target: 25,
        ),
        Achievement(
          id: 'local_100',
          title: 'Thổ địa',
          description: 'Tiếp xúc 100 câu',
          emoji: '🗺️',
          color: const Color(0xFF6366F1),
          current: learnedCount,
          target: 100,
        ),
        Achievement(
          id: 'streak_3',
          title: 'Đều tay',
          description: 'Học 3 ngày liên tiếp',
          emoji: '🔥',
          color: const Color(0xFFF97316),
          current: _streak,
          target: 3,
        ),
        Achievement(
          id: 'streak_7',
          title: 'Một tuần trọn vẹn',
          description: 'Học 7 ngày liên tiếp',
          emoji: '🏅',
          color: const Color(0xFFF59E0B),
          current: _streak,
          target: 7,
        ),
        Achievement(
          id: 'streak_30',
          title: 'Thói quen thật sự',
          description: 'Học 30 ngày liên tiếp',
          emoji: '💎',
          color: const Color(0xFFEC4899),
          current: _streak,
          target: 30,
        ),
        Achievement(
          id: 'mastered_10',
          title: 'Nhớ dai',
          description: 'Thuộc lòng 10 câu',
          emoji: '🧠',
          color: const Color(0xFF10B981),
          current: masteredCount,
          target: 10,
        ),
        Achievement(
          id: 'mastered_50',
          title: 'Trí nhớ thép',
          description: 'Thuộc lòng 50 câu',
          emoji: '🛡️',
          color: const Color(0xFF059669),
          current: masteredCount,
          target: 50,
        ),
        Achievement(
          id: 'quiz_perfect',
          title: 'Điểm tuyệt đối',
          description: 'Đạt 100% một bài quiz',
          emoji: '🎯',
          color: const Color(0xFFEF4444),
          current: bestQuizScore,
          target: 100,
        ),
        Achievement(
          id: 'all_unlocked',
          title: 'Đủ bốn chặng',
          description: 'Mở khoá toàn bộ hành trình',
          emoji: '🧭',
          color: const Color(0xFF8B5CF6),
          current: unlockedScenarioCount,
          target: scenarios.isEmpty ? 1 : scenarios.length,
        ),
        Achievement(
          id: 'favourite_10',
          title: 'Sổ tay riêng',
          description: 'Đánh dấu 10 câu yêu thích',
          emoji: '⭐',
          color: const Color(0xFFEAB308),
          current: favouriteCount,
          target: 10,
        ),
        Achievement(
          id: 'game_master',
          title: 'Cao thủ luyện tập',
          description: 'Tổng điểm cao các trò đạt 100',
          emoji: '🕹️',
          color: const Color(0xFF14B8A6),
          current: totalGameBest,
          target: 100,
        ),
      ];

  int get unlockedAchievementCount =>
      achievements.where((Achievement a) => a.unlocked).length;

  // --- Cài đặt ---

  Future<void> setDailyGoal(int value) async {
    _dailyGoal = value;
    await _storage.setDailyGoal(value);
    notifyListeners();
  }

  Future<void> resetProgress() async {
    _cards = <String, SrsCard>{};
    _quizBest = <String, int>{};
    _gameBest = <String, int>{};
    _favourites = <String>{};
    _reviewedToday = 0;
    await _storage.clearProgress(_language.code);
    await _storage.saveReviewedToday(0, todayKey());
    notifyListeners();
  }

  Future<void> speak(String text) => _tts.speak(text, _language.ttsLocale);

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}
