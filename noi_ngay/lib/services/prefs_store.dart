import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Lưu trữ cục bộ.
///
/// Mọi thứ app biết về người dùng đều nằm trong [SharedPreferences] trên máy:
/// không có tài khoản, không có máy chủ, không có lệnh gọi mạng nào. Lớp này là
/// chỗ duy nhất chạm tới bộ nhớ, nên muốn biết app lưu gì thì chỉ cần đọc file
/// này là đủ.
class PrefsStore {
  PrefsStore._(this._prefs);

  static Future<PrefsStore> open() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return PrefsStore._(prefs);
  }

  final SharedPreferences _prefs;

  // --- Khoá --------------------------------------------------------------

  static const String _kOnboarded = 'onboarded';
  static const String _kDarkMode = 'dark_mode';
  static const String _kDailyGoal = 'daily_goal';
  static const String _kSpeechRate = 'speech_rate';
  static const String _kBoxes = 'boxes';
  static const String _kSaved = 'saved_lines';
  static const String _kDoneLessons = 'done_lessons';
  static const String _kHistory = 'history';
  static const String _kBestScores = 'best_scores';
  static const String _kTotalReviews = 'total_reviews';

  // --- Cài đặt -----------------------------------------------------------

  bool get onboarded => _prefs.getBool(_kOnboarded) ?? false;
  Future<void> setOnboarded(bool value) => _prefs.setBool(_kOnboarded, value);

  bool get darkMode => _prefs.getBool(_kDarkMode) ?? true;
  Future<void> setDarkMode(bool value) => _prefs.setBool(_kDarkMode, value);

  int get dailyGoal => _prefs.getInt(_kDailyGoal) ?? 12;
  Future<void> setDailyGoal(int value) => _prefs.setInt(_kDailyGoal, value);

  double get speechRate => _prefs.getDouble(_kSpeechRate) ?? 0.45;
  Future<void> setSpeechRate(double value) =>
      _prefs.setDouble(_kSpeechRate, value);

  // --- Hộp Leitner -------------------------------------------------------

  /// Trả về map thô đã giải mã; lớp state chịu trách nhiệm dựng model.
  List<Map<String, dynamic>> readBoxes() {
    final String? raw = _prefs.getString(_kBoxes);
    if (raw == null || raw.isEmpty) return <Map<String, dynamic>>[];
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! List) return <Map<String, dynamic>>[];
      return decoded
          .whereType<Map<String, dynamic>>()
          .toList(growable: false);
    } on FormatException {
      // Dữ liệu hỏng thì bỏ qua và bắt đầu lại, không làm app chết.
      return <Map<String, dynamic>>[];
    }
  }

  Future<void> writeBoxes(List<Map<String, dynamic>> boxes) =>
      _prefs.setString(_kBoxes, jsonEncode(boxes));

  // --- Câu đã lưu --------------------------------------------------------

  Set<String> readSaved() =>
      (_prefs.getStringList(_kSaved) ?? const <String>[]).toSet();

  Future<void> writeSaved(Set<String> ids) =>
      _prefs.setStringList(_kSaved, ids.toList());

  // --- Bài học đã hoàn thành ---------------------------------------------

  Set<String> readDoneLessons() =>
      (_prefs.getStringList(_kDoneLessons) ?? const <String>[]).toSet();

  Future<void> writeDoneLessons(Set<String> ids) =>
      _prefs.setStringList(_kDoneLessons, ids.toList());

  // --- Lịch sử học theo ngày ---------------------------------------------

  /// Map ngày dạng `2026-08-17` sang số câu đã ôn trong ngày đó.
  Map<String, int> readHistory() {
    final String? raw = _prefs.getString(_kHistory);
    if (raw == null || raw.isEmpty) return <String, int>{};
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map) return <String, int>{};
      return decoded.map(
        (Object? key, Object? value) => MapEntry<String, int>(
          key.toString(),
          value is num ? value.toInt() : 0,
        ),
      );
    } on FormatException {
      return <String, int>{};
    }
  }

  Future<void> writeHistory(Map<String, int> history) =>
      _prefs.setString(_kHistory, jsonEncode(history));

  // --- Kỷ lục từng trò luyện tập -----------------------------------------

  Map<String, int> readBestScores() {
    final String? raw = _prefs.getString(_kBestScores);
    if (raw == null || raw.isEmpty) return <String, int>{};
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map) return <String, int>{};
      return decoded.map(
        (Object? key, Object? value) => MapEntry<String, int>(
          key.toString(),
          value is num ? value.toInt() : 0,
        ),
      );
    } on FormatException {
      return <String, int>{};
    }
  }

  Future<void> writeBestScores(Map<String, int> scores) =>
      _prefs.setString(_kBestScores, jsonEncode(scores));

  // --- Tổng số lượt ôn ---------------------------------------------------

  int get totalReviews => _prefs.getInt(_kTotalReviews) ?? 0;
  Future<void> setTotalReviews(int value) =>
      _prefs.setInt(_kTotalReviews, value);

  /// Xoá sạch mọi thứ app đã lưu. Dùng cho nút đặt lại ở tab Cá nhân.
  Future<void> wipe() => _prefs.clear();
}
