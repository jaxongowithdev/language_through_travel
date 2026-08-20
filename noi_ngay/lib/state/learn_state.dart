import 'package:flutter/material.dart';

import '../data/library.dart';
import '../models/box_card.dart';
import '../models/lesson.dart';
import '../models/milestone.dart';
import '../models/spoken_line.dart';
import '../models/topic.dart';
import '../services/prefs_store.dart';
import '../services/speech.dart';
import '../theme/palette.dart';

/// Trạng thái học của người dùng.
///
/// Một [ChangeNotifier] duy nhất cho cả app: tiến độ, hộp ôn tập, cài đặt và
/// thống kê. Mọi thay đổi đều ghi xuống [PrefsStore] ngay lập tức, nên đóng app
/// giữa chừng cũng không mất gì.
class LearnState extends ChangeNotifier {
  LearnState({required PrefsStore store, required Speech speech})
      : _store = store,
        _speech = speech {
    _load();
  }

  final PrefsStore _store;
  final Speech _speech;
  final Library _library = Library.instance;

  // --- Dữ liệu trong bộ nhớ ----------------------------------------------

  final Map<String, BoxCard> _boxes = <String, BoxCard>{};
  Set<String> _saved = <String>{};
  Set<String> _doneLessons = <String>{};
  Map<String, int> _history = <String, int>{};
  Map<String, int> _bestScores = <String, int>{};

  bool _onboarded = false;
  bool _darkMode = true;
  int _dailyGoal = 12;
  int _totalReviews = 0;

  // --- Truy cập ----------------------------------------------------------

  Library get library => _library;
  Speech get speech => _speech;

  bool get onboarded => _onboarded;
  bool get darkMode => _darkMode;
  int get dailyGoal => _dailyGoal;
  int get totalReviews => _totalReviews;
  double get speechRate => _speech.rate;

  Set<String> get savedIds => Set<String>.unmodifiable(_saved);
  Set<String> get doneLessonIds => Set<String>.unmodifiable(_doneLessons);
  Map<String, int> get history => Map<String, int>.unmodifiable(_history);

  void _load() {
    _onboarded = _store.onboarded;
    _darkMode = _store.darkMode;
    _dailyGoal = _store.dailyGoal;
    _totalReviews = _store.totalReviews;
    _saved = _store.readSaved();
    _doneLessons = _store.readDoneLessons();
    _history = _store.readHistory();
    _bestScores = _store.readBestScores();
    _speech.setRate(_store.speechRate);

    for (final Map<String, dynamic> json in _store.readBoxes()) {
      try {
        final BoxCard card = BoxCard.fromJson(json);
        _boxes[card.lineId] = card;
      } catch (_) {
        // Một thẻ hỏng không được phép làm hỏng cả bộ.
      }
    }
    notifyListeners();
  }

  // --- Cài đặt -----------------------------------------------------------

  Future<void> completeOnboarding() async {
    _onboarded = true;
    await _store.setOnboarded(true);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    await _store.setDarkMode(value);
    notifyListeners();
  }

  Future<void> setDailyGoal(int value) async {
    _dailyGoal = value.clamp(4, 60);
    await _store.setDailyGoal(_dailyGoal);
    notifyListeners();
  }

  Future<void> setSpeechRate(double value) async {
    await _speech.setRate(value);
    await _store.setSpeechRate(_speech.rate);
    notifyListeners();
  }

  void say(String text) => _speech.say(text);

  // --- Hộp ôn tập --------------------------------------------------------

  BoxCard boxFor(String lineId) =>
      _boxes[lineId] ??= BoxCard(lineId: lineId);

  /// Chỉ đọc, không tạo thẻ mới — dùng khi chỉ cần hiển thị.
  BoxCard? peekBox(String lineId) => _boxes[lineId];

  int get startedCount => _boxes.values.where((BoxCard b) => b.seen > 0).length;

  int get learnedCount => _boxes.values.where((BoxCard b) => b.isLearned).length;

  /// Các câu đã học ít nhất một lần và tới hạn ôn lại.
  List<SpokenLine> get dueLines {
    final List<SpokenLine> result = <SpokenLine>[];
    for (final BoxCard card in _boxes.values) {
      if (card.seen == 0 || !card.isDue) continue;
      final SpokenLine? line = _library.lineById(card.lineId);
      if (line != null) result.add(line);
    }
    result.sort((SpokenLine a, SpokenLine b) {
      final int boxA = _boxes[a.id]?.box ?? 1;
      final int boxB = _boxes[b.id]?.box ?? 1;
      return boxA.compareTo(boxB);
    });
    return result;
  }

  int get dueCount => dueLines.length;

  /// Câu chưa từng học, dùng cho nút Học câu mới.
  List<SpokenLine> freshLines({int limit = 12}) {
    final List<SpokenLine> result = <SpokenLine>[];
    for (final SpokenLine line in _library.allLines) {
      final BoxCard? card = _boxes[line.id];
      if (card == null || card.seen == 0) result.add(line);
      if (result.length >= limit) break;
    }
    return result;
  }

  /// Chấm một câu và ghi lại vào lịch sử hôm nay.
  Future<void> grade(String lineId, Recall result) async {
    boxFor(lineId).grade(result);
    _totalReviews += 1;
    final String key = _dayKey(DateTime.now());
    _history[key] = (_history[key] ?? 0) + 1;
    await _persistProgress();
    notifyListeners();
  }

  Future<void> _persistProgress() async {
    await _store.writeBoxes(
      _boxes.values.map((BoxCard b) => b.toJson()).toList(),
    );
    await _store.writeHistory(_history);
    await _store.setTotalReviews(_totalReviews);
  }

  // --- Câu đã lưu --------------------------------------------------------

  bool isSaved(String lineId) => _saved.contains(lineId);

  Future<void> toggleSaved(String lineId) async {
    if (!_saved.remove(lineId)) _saved.add(lineId);
    await _store.writeSaved(_saved);
    notifyListeners();
  }

  List<SpokenLine> get savedLines => <SpokenLine>[
        for (final String id in _saved)
          if (_library.lineById(id) != null) _library.lineById(id)!,
      ];

  // --- Bài học -----------------------------------------------------------

  bool isLessonDone(String lessonId) => _doneLessons.contains(lessonId);

  Future<void> markLessonDone(String lessonId) async {
    if (_doneLessons.add(lessonId)) {
      await _store.writeDoneLessons(_doneLessons);
      notifyListeners();
    }
  }

  /// Tỉ lệ câu của [topic] đã được học ít nhất một lần.
  double topicProgress(Topic topic) {
    final List<SpokenLine> lines = topic.lines;
    if (lines.isEmpty) return 0;
    int started = 0;
    for (final SpokenLine line in lines) {
      if ((_boxes[line.id]?.seen ?? 0) > 0) started += 1;
    }
    return started / lines.length;
  }

  double lessonProgress(Lesson lesson) {
    if (lesson.lines.isEmpty) return 0;
    int started = 0;
    for (final SpokenLine line in lesson.lines) {
      if ((_boxes[line.id]?.seen ?? 0) > 0) started += 1;
    }
    return started / lesson.lines.length;
  }

  /// Chủ đề gợi ý tiếp theo: chủ đề dở dang đầu tiên, hoặc chủ đề chưa bắt đầu.
  Topic get suggestedTopic {
    for (final Topic topic in _library.topics) {
      final double p = topicProgress(topic);
      if (p > 0 && p < 1) return topic;
    }
    for (final Topic topic in _library.topics) {
      if (topicProgress(topic) == 0) return topic;
    }
    return _library.topics.first;
  }

  // --- Kỷ lục ------------------------------------------------------------

  int bestScore(String drillId) => _bestScores[drillId] ?? 0;

  Future<void> submitScore(String drillId, int score) async {
    if (score > (_bestScores[drillId] ?? 0)) {
      _bestScores[drillId] = score;
      await _store.writeBestScores(_bestScores);
      notifyListeners();
    }
  }

  // --- Lịch sử, mục tiêu, streak -----------------------------------------

  static String _dayKey(DateTime date) {
    final String m = date.month.toString().padLeft(2, '0');
    final String d = date.day.toString().padLeft(2, '0');
    return '${date.year}-$m-$d';
  }

  int get todayCount => _history[_dayKey(DateTime.now())] ?? 0;

  double get goalRatio =>
      _dailyGoal == 0 ? 1 : (todayCount / _dailyGoal).clamp(0.0, 1.0);

  bool get goalReached => todayCount >= _dailyGoal;

  /// Số câu đã ôn trong [days] ngày gần nhất, phần tử cuối là hôm nay.
  List<int> recentCounts(int days) {
    final DateTime today = DateTime.now();
    return <int>[
      for (int i = days - 1; i >= 0; i--)
        _history[_dayKey(today.subtract(Duration(days: i)))] ?? 0,
    ];
  }

  /// Chuỗi ngày học liên tiếp tính tới hôm nay. Nếu hôm nay chưa học thì vẫn
  /// tính chuỗi tới hôm qua, để người dùng không thấy chuỗi bị đứt oan lúc sáng.
  int get streak {
    final DateTime today = DateTime.now();
    int streak = 0;
    int offset = (_history[_dayKey(today)] ?? 0) > 0 ? 0 : 1;
    while (true) {
      final DateTime day = today.subtract(Duration(days: offset));
      if ((_history[_dayKey(day)] ?? 0) > 0) {
        streak += 1;
        offset += 1;
      } else {
        break;
      }
      if (offset > 400) break; // Chặn vòng lặp vô hạn nếu dữ liệu lạ.
    }
    return streak;
  }

  int get activeDays =>
      _history.values.where((int count) => count > 0).length;

  // --- Cột mốc -----------------------------------------------------------

  List<Milestone> get milestones => <Milestone>[
        Milestone(
          id: 'first_step',
          title: 'Bước đầu tiên',
          description: 'Ôn câu đầu tiên của bạn',
          icon: Icons.flag_rounded,
          tint: Palette.violet,
          current: _totalReviews,
          target: 1,
        ),
        Milestone(
          id: 'fifty',
          title: 'Năm mươi lượt',
          description: 'Ôn tổng cộng 50 lượt',
          icon: Icons.bolt_rounded,
          tint: Palette.amber,
          current: _totalReviews,
          target: 50,
        ),
        Milestone(
          id: 'five_hundred',
          title: 'Năm trăm lượt',
          description: 'Ôn tổng cộng 500 lượt',
          icon: Icons.local_fire_department_rounded,
          tint: Palette.rose,
          current: _totalReviews,
          target: 500,
        ),
        Milestone(
          id: 'streak_3',
          title: 'Ba ngày liền',
          description: 'Học ba ngày liên tiếp',
          icon: Icons.calendar_today_rounded,
          tint: Palette.cyan,
          current: streak,
          target: 3,
        ),
        Milestone(
          id: 'streak_14',
          title: 'Hai tuần liền',
          description: 'Học mười bốn ngày liên tiếp',
          icon: Icons.calendar_month_rounded,
          tint: Palette.indigo,
          current: streak,
          target: 14,
        ),
        Milestone(
          id: 'started_100',
          title: 'Trăm câu đầu tay',
          description: 'Chạm tới 100 câu khác nhau',
          icon: Icons.chat_bubble_rounded,
          tint: Palette.mint,
          current: startedCount,
          target: 100,
        ),
        Milestone(
          id: 'learned_50',
          title: 'Năm mươi câu thuộc',
          description: 'Đưa 50 câu lên hộp cuối',
          icon: Icons.verified_rounded,
          tint: Palette.lime,
          current: learnedCount,
          target: 50,
        ),
        Milestone(
          id: 'lessons_10',
          title: 'Mười bài học',
          description: 'Hoàn thành 10 bài học',
          icon: Icons.menu_book_rounded,
          tint: Palette.fuchsia,
          current: _doneLessons.length,
          target: 10,
        ),
        Milestone(
          id: 'lessons_30',
          title: 'Ba mươi bài học',
          description: 'Hoàn thành 30 bài học',
          icon: Icons.auto_stories_rounded,
          tint: Palette.violet,
          current: _doneLessons.length,
          target: 30,
        ),
        Milestone(
          id: 'saved_20',
          title: 'Sổ tay riêng',
          description: 'Lưu 20 câu vào mục Đã lưu',
          icon: Icons.bookmark_rounded,
          tint: Palette.amber,
          current: _saved.length,
          target: 20,
        ),
        Milestone(
          id: 'days_30',
          title: 'Ba mươi ngày học',
          description: 'Có 30 ngày từng học bài',
          icon: Icons.event_available_rounded,
          tint: Palette.cyan,
          current: activeDays,
          target: 30,
        ),
        Milestone(
          id: 'topics_all',
          title: 'Chạm hết chủ đề',
          description: 'Bắt đầu đủ 20 chủ đề',
          icon: Icons.explore_rounded,
          tint: Palette.rose,
          current: _library.topics
              .where((Topic t) => topicProgress(t) > 0)
              .length,
          target: _library.topics.length,
        ),
      ];

  // --- Đặt lại -----------------------------------------------------------

  Future<void> resetEverything() async {
    await _store.wipe();
    _boxes.clear();
    _saved = <String>{};
    _doneLessons = <String>{};
    _history = <String, int>{};
    _bestScores = <String, int>{};
    _totalReviews = 0;
    _onboarded = true; // Không bắt người dùng xem lại phần giới thiệu.
    _dailyGoal = 12;
    _darkMode = true;
    await _store.setOnboarded(true);
    notifyListeners();
  }
}
