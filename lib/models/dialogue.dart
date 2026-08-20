import 'package:flutter/foundation.dart';

/// Một lượt nói trong hội thoại mô phỏng.
@immutable
class DialogueLine {
  const DialogueLine({
    required this.speaker,
    required this.target,
    required this.vietnamese,
    this.romanization = '',
    this.isUser = false,
  });

  /// Tên/vai người nói, ví dụ `Nhân viên check-in`.
  final String speaker;
  final String target;
  final String vietnamese;
  final String romanization;

  /// true nếu đây là lượt của người học.
  final bool isUser;
}

/// Một đoạn hội thoại hoàn chỉnh gắn với một tình huống.
@immutable
class Dialogue {
  const Dialogue({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.lines,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<DialogueLine> lines;
}
