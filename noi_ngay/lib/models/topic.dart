import 'package:flutter/material.dart';

import 'conversation.dart';
import 'lesson.dart';
import 'spoken_line.dart';
import 'word_card.dart';

/// Ba mức độ dùng để lọc chủ đề. Đây chỉ là nhãn gợi ý, **không khoá nội dung**:
/// mọi chủ đề đều mở ngay từ lần mở app đầu tiên.
enum SpeakLevel {
  starter('Nhập môn', 'Câu ngắn, dùng được ngay hôm nay'),
  everyday('Hằng ngày', 'Tình huống lặp lại mỗi tuần'),
  confident('Tự tin', 'Nói dài hơn, sắc thái tinh hơn');

  const SpeakLevel(this.label, this.blurb);
  final String label;
  final String blurb;
}

/// Một chủ đề giao tiếp, ví dụ "Chào hỏi & làm quen".
@immutable
class Topic {
  const Topic({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.icon,
    required this.tint,
    required this.level,
    required this.lessons,
    required this.words,
    required this.conversations,
  });

  /// Mã ngắn dùng làm tiền tố id, ví dụ `smalltalk`.
  final String code;

  final String title;

  /// Một dòng mô tả người học dùng chủ đề này khi nào.
  final String subtitle;

  final String emoji;
  final IconData icon;
  final Color tint;
  final SpeakLevel level;

  final List<Lesson> lessons;
  final List<WordCard> words;
  final List<Conversation> conversations;

  /// Toàn bộ câu của chủ đề, gộp mọi bài học.
  List<SpokenLine> get lines => <SpokenLine>[
        for (final Lesson lesson in lessons) ...lesson.lines,
      ];

  int get lineCount => lines.length;

  /// Tổng số mục nội dung để hiển thị nhãn "n mục".
  int get itemCount {
    int total = lineCount + words.length;
    for (final Conversation c in conversations) {
      total += c.turns.length;
    }
    return total;
  }
}
