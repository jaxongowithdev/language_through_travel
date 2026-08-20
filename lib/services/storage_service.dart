import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/srs_card.dart';

/// Lưu tiến độ học xuống bộ nhớ máy bằng SharedPreferences.
///
/// Mỗi ngôn ngữ có không gian khoá riêng để tiến độ tiếng Anh không lẫn với
/// tiếng Nhật.
class StorageService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  static Future<StorageService> create() async {
    return StorageService(await SharedPreferences.getInstance());
  }

  static const String _kLanguage = 'selected_language';
  static const String _kOnboarded = 'onboarding_done';
  static const String _kStreakCount = 'streak_count';
  static const String _kStreakDate = 'streak_last_date';
  static const String _kDailyGoal = 'daily_goal';
  static const String _kReviewedToday = 'reviewed_today';
  static const String _kReviewedDate = 'reviewed_date';
  static const String _kActiveDays = 'active_days';

  /// Số ngày học gần nhất được giữ lại cho biểu đồ nhiệt (~1 năm).
  static const int _maxActiveDays = 400;

  String _cardsKey(String lang) => 'srs_cards_$lang';
  String _quizKey(String lang) => 'quiz_best_$lang';
  String _favouritesKey(String lang) => 'favourites_$lang';
  String _gameKey(String lang) => 'game_best_$lang';

  // --- Ngôn ngữ & onboarding ---

  String? get selectedLanguage => _prefs.getString(_kLanguage);

  Future<void> setSelectedLanguage(String code) =>
      _prefs.setString(_kLanguage, code);

  bool get hasOnboarded => _prefs.getBool(_kOnboarded) ?? false;

  Future<void> setOnboarded() => _prefs.setBool(_kOnboarded, true);

  // --- Thẻ SRS ---

  Map<String, SrsCard> loadCards(String languageCode) {
    final String? raw = _prefs.getString(_cardsKey(languageCode));
    if (raw == null || raw.isEmpty) return <String, SrsCard>{};
    try {
      final Map<String, dynamic> decoded =
          jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((String key, dynamic value) => MapEntry<String, SrsCard>(
            key,
            SrsCard.fromJson(value as Map<String, dynamic>),
          ));
    } catch (_) {
      // Dữ liệu hỏng: bắt đầu lại thay vì làm crash app.
      return <String, SrsCard>{};
    }
  }

  Future<void> saveCards(String languageCode, Map<String, SrsCard> cards) {
    final Map<String, dynamic> encoded = cards.map(
      (String key, SrsCard card) =>
          MapEntry<String, dynamic>(key, card.toJson()),
    );
    return _prefs.setString(_cardsKey(languageCode), jsonEncode(encoded));
  }

  // --- Điểm quiz cao nhất theo tình huống ---

  Map<String, int> loadQuizBest(String languageCode) =>
      _loadIntMap(_quizKey(languageCode));

  Future<void> saveQuizBest(String languageCode, Map<String, int> best) =>
      _prefs.setString(_quizKey(languageCode), jsonEncode(best));

  // --- Điểm cao của các trò luyện tập ---

  Map<String, int> loadGameBest(String languageCode) =>
      _loadIntMap(_gameKey(languageCode));

  Future<void> saveGameBest(String languageCode, Map<String, int> best) =>
      _prefs.setString(_gameKey(languageCode), jsonEncode(best));

  Map<String, int> _loadIntMap(String key) {
    final String? raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return <String, int>{};
    try {
      final Map<String, dynamic> decoded =
          jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (String k, dynamic v) => MapEntry<String, int>(k, (v as num).toInt()),
      );
    } catch (_) {
      return <String, int>{};
    }
  }

  // --- Câu yêu thích ---

  Set<String> loadFavourites(String languageCode) {
    final List<String>? raw = _prefs.getStringList(_favouritesKey(languageCode));
    return raw == null ? <String>{} : raw.toSet();
  }

  Future<void> saveFavourites(String languageCode, Set<String> ids) =>
      _prefs.setStringList(_favouritesKey(languageCode), ids.toList());

  // --- Chuỗi ngày học liên tiếp ---

  int get streakCount => _prefs.getInt(_kStreakCount) ?? 0;

  String? get streakLastDate => _prefs.getString(_kStreakDate);

  Future<void> saveStreak(int count, String isoDate) async {
    await _prefs.setInt(_kStreakCount, count);
    await _prefs.setString(_kStreakDate, isoDate);
  }

  /// Danh sách ngày (yyyy-MM-dd) người dùng có học, dùng cho biểu đồ nhiệt.
  Set<String> get activeDays =>
      (_prefs.getStringList(_kActiveDays) ?? const <String>[]).toSet();

  Future<void> saveActiveDays(Set<String> days) {
    final List<String> sorted = days.toList()..sort();
    final List<String> trimmed = sorted.length > _maxActiveDays
        ? sorted.sublist(sorted.length - _maxActiveDays)
        : sorted;
    return _prefs.setStringList(_kActiveDays, trimmed);
  }

  // --- Mục tiêu hằng ngày ---

  int get dailyGoal => _prefs.getInt(_kDailyGoal) ?? 10;

  Future<void> setDailyGoal(int value) => _prefs.setInt(_kDailyGoal, value);

  int get reviewedToday => _prefs.getInt(_kReviewedToday) ?? 0;

  String? get reviewedDate => _prefs.getString(_kReviewedDate);

  Future<void> saveReviewedToday(int count, String isoDate) async {
    await _prefs.setInt(_kReviewedToday, count);
    await _prefs.setString(_kReviewedDate, isoDate);
  }

  Future<void> clearProgress(String languageCode) async {
    await _prefs.remove(_cardsKey(languageCode));
    await _prefs.remove(_quizKey(languageCode));
    await _prefs.remove(_gameKey(languageCode));
    await _prefs.remove(_favouritesKey(languageCode));
  }
}
