import 'package:flutter/material.dart';

/// Một dòng tra cứu trong Cẩm nang: cụm từ, con số hoặc mẫu câu.
@immutable
class GuideEntry {
  const GuideEntry({
    required this.target,
    required this.vietnamese,
    this.romanization = '',
  });

  /// Nội dung bằng ngôn ngữ đích (rỗng nếu dòng chỉ là mẹo tiếng Việt).
  final String target;

  final String vietnamese;

  /// Phiên âm latin, rỗng nếu ngôn ngữ không cần.
  final String romanization;

  /// Dòng có nội dung đọc được bằng TTS hay không.
  bool get speakable => target.isNotEmpty;
}

/// Một thẻ nội dung trong Cẩm nang.
@immutable
class GuideCard {
  const GuideCard({
    required this.title,
    this.emoji = '',
    this.body = '',
    this.entries = const <GuideEntry>[],
  });

  final String title;
  final String emoji;

  /// Đoạn giải thích bằng tiếng Việt; có thể rỗng nếu thẻ chỉ liệt kê từ.
  final String body;

  final List<GuideEntry> entries;
}

/// Một chủ đề của Cẩm nang, ví dụ "Số đếm" hoặc "Khẩn cấp".
@immutable
class GuideTopic {
  const GuideTopic({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.cards,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<GuideCard> cards;

  /// Tổng số dòng tra cứu, dùng cho nhãn "n mục".
  int get entryCount {
    int total = 0;
    for (final GuideCard card in cards) {
      total += card.entries.length;
    }
    return total;
  }
}
