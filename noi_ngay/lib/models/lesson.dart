import 'package:flutter/foundation.dart';

import 'spoken_line.dart';

/// Một bài học ngắn: tám câu quanh cùng một mục tiêu giao tiếp.
///
/// Cố ý giữ bài ngắn để một lượt học vừa đúng vài phút — người dùng mục tiêu
/// của app là người đi làm, học lúc chờ xe hoặc trước khi ngủ.
@immutable
class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.goal,
    required this.lines,
  });

  /// Id dạng `smalltalk.l2`.
  final String id;

  final String title;

  /// Câu mô tả người học làm được gì sau bài, ví dụ "Mở lời với người lạ".
  final String goal;

  final List<SpokenLine> lines;

  String get topicCode => id.split('.').first;

  int get lineCount => lines.length;
}
