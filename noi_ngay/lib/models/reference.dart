import 'package:flutter/material.dart';

/// Một ví dụ song ngữ đi kèm mục tra cứu.
@immutable
class RefExample {
  const RefExample(this.english, this.vietnamese);
  final String english;
  final String vietnamese;
}

/// Một mục trong sổ tay tra cứu: điểm ngữ pháp, phrasal verb, thành ngữ,
/// động từ bất quy tắc hoặc âm trong bảng IPA.
///
/// Dùng chung một kiểu cho cả năm loại vì màn hình tra cứu hiển thị chúng theo
/// đúng một khuôn: tiêu đề → công thức/phiên âm → giải thích → ví dụ.
@immutable
class RefEntry {
  const RefEntry({
    required this.id,
    required this.headword,
    this.formula = '',
    this.meaning = '',
    this.explain = '',
    this.examples = const <RefExample>[],
  });

  /// Id dạng `grammar.g07` hoặc `phrasal.p12`.
  final String id;

  /// Từ/cụm đứng đầu mục, ví dụ `look after` hoặc `Thì hiện tại hoàn thành`.
  final String headword;

  /// Công thức hoặc phiên âm ngắn hiển thị ngay dưới tiêu đề.
  final String formula;

  /// Nghĩa tiếng Việt gọn một dòng.
  final String meaning;

  /// Đoạn giải thích dài hơn; có thể rỗng.
  final String explain;

  final List<RefExample> examples;

  /// Câu tiếng Anh đầu tiên có thể đọc bằng TTS, rỗng nếu mục không có ví dụ.
  String get speakable =>
      examples.isEmpty ? headword : examples.first.english;
}

/// Một nhóm mục tra cứu, hiển thị thành một thẻ trong tab Sổ tay.
@immutable
class RefSection {
  const RefSection({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tint,
    required this.entries,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color tint;
  final List<RefEntry> entries;

  int get entryCount => entries.length;
}
