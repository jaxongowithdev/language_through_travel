import 'package:flutter/foundation.dart';

/// Một mục từ vựng kèm phiên âm IPA và ví dụ.
@immutable
class WordCard {
  const WordCard({
    required this.id,
    required this.word,
    required this.ipa,
    required this.partOfSpeech,
    required this.vietnamese,
    this.example = '',
    this.exampleVi = '',
  });

  /// Id dạng `smalltalk.w03`.
  final String id;

  final String word;

  /// Phiên âm IPA giọng Mỹ, đã bao trong dấu gạch chéo.
  final String ipa;

  /// Từ loại viết tắt: n, v, adj, adv, phr…
  final String partOfSpeech;

  final String vietnamese;

  final String example;
  final String exampleVi;

  String get topicCode => id.split('.').first;

  bool get hasExample => example.isNotEmpty;
}
