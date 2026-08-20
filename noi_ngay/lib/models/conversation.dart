import 'package:flutter/foundation.dart';

/// Một lượt nói trong đoạn hội thoại mẫu.
@immutable
class ConversationTurn {
  const ConversationTurn({
    required this.speaker,
    required this.english,
    required this.vietnamese,
    this.isLearner = false,
  });

  /// Vai người nói, ví dụ `Lễ tân`.
  final String speaker;

  final String english;
  final String vietnamese;

  /// true nếu đây là lượt của người học — hiển thị lệch phải và tô màu nhấn.
  final bool isLearner;
}

/// Một đoạn hội thoại hoàn chỉnh gắn với một chủ đề.
@immutable
class Conversation {
  const Conversation({
    required this.id,
    required this.title,
    required this.setting,
    required this.turns,
  });

  /// Id dạng `smalltalk.c1`.
  final String id;

  final String title;

  /// Bối cảnh một dòng, ví dụ "Trong thang máy toà nhà văn phòng".
  final String setting;

  final List<ConversationTurn> turns;

  String get topicCode => id.split('.').first;

  int get learnerTurnCount =>
      turns.where((ConversationTurn t) => t.isLearner).length;
}
