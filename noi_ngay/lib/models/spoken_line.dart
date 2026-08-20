import 'package:flutter/foundation.dart';

/// Một câu giao tiếp: bản tiếng Anh, nghĩa tiếng Việt và mẹo dùng.
///
/// Đây là đơn vị nhỏ nhất của toàn bộ app — bài học, ôn tập, và cả bốn dạng
/// luyện tập đều thao tác trên [SpokenLine].
@immutable
class SpokenLine {
  const SpokenLine({
    required this.id,
    required this.english,
    required this.vietnamese,
    this.tip = '',
  });

  /// Id duy nhất toàn cục, dạng `smalltalk.l2.05`.
  final String id;

  /// Câu tiếng Anh đầy đủ, viết hoa và chấm câu như khi nói thật.
  final String english;

  /// Nghĩa tiếng Việt tự nhiên, không dịch từng chữ.
  final String vietnamese;

  /// Mẹo dùng: sắc thái, ngữ cảnh, lỗi người Việt hay mắc. Có thể rỗng.
  final String tip;

  /// Mã chủ đề suy ra từ [id].
  String get topicCode => id.split('.').first;

  /// Mã bài học suy ra từ [id], ví dụ `l2`.
  String get lessonCode {
    final List<String> parts = id.split('.');
    return parts.length > 1 ? parts[1] : '';
  }

  /// Số từ trong câu — dùng để chọn câu phù hợp cho trò sắp xếp từ.
  int get wordCount => english.split(RegExp(r'\s+')).length;
}
