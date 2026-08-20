/// Ngôn ngữ đích mà người dùng có thể học.
class LearningLanguage {
  const LearningLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.ttsLocale,
    this.hasRomanization = false,
    this.romanizationLabel = '',
  });

  /// Mã ngắn dùng làm khoá lưu trữ, ví dụ `en`, `ja`.
  final String code;

  /// Tên hiển thị bằng tiếng Việt.
  final String name;

  /// Tên bản ngữ, ví dụ `日本語`.
  final String nativeName;

  /// Emoji cờ.
  final String flag;

  /// Locale truyền cho flutter_tts, ví dụ `en-US`.
  final String ttsLocale;

  /// Ngôn ngữ có phiên âm latin đi kèm hay không.
  final bool hasRomanization;

  /// Nhãn cho phiên âm, ví dụ `Romaji`.
  final String romanizationLabel;

  static const List<LearningLanguage> all = <LearningLanguage>[
    LearningLanguage(
      code: 'en',
      name: 'Tiếng Anh',
      nativeName: 'English',
      flag: '🇬🇧',
      ttsLocale: 'en-US',
    ),
    LearningLanguage(
      code: 'ja',
      name: 'Tiếng Nhật',
      nativeName: '日本語',
      flag: '🇯🇵',
      ttsLocale: 'ja-JP',
      hasRomanization: true,
      romanizationLabel: 'Romaji',
    ),
    LearningLanguage(
      code: 'ko',
      name: 'Tiếng Hàn',
      nativeName: '한국어',
      flag: '🇰🇷',
      ttsLocale: 'ko-KR',
      hasRomanization: true,
      romanizationLabel: 'Romaja',
    ),
    LearningLanguage(
      code: 'th',
      name: 'Tiếng Thái',
      nativeName: 'ภาษาไทย',
      flag: '🇹🇭',
      ttsLocale: 'th-TH',
      hasRomanization: true,
      romanizationLabel: 'Phiên âm',
    ),
  ];

  static LearningLanguage byCode(String code) {
    return all.firstWhere(
      (LearningLanguage l) => l.code == code,
      orElse: () => all.first,
    );
  }
}
