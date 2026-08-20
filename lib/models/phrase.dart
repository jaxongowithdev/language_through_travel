import 'package:flutter/foundation.dart';

/// Một mục từ vựng hoặc câu mẫu trong một tình huống.
@immutable
class Phrase {
  const Phrase({
    required this.id,
    required this.target,
    required this.vietnamese,
    this.romanization = '',
    this.note = '',
    this.isSentence = true,
  });

  /// Id duy nhất toàn cục, dạng `en.airport.01`.
  final String id;

  /// Nội dung bằng ngôn ngữ đích.
  final String target;

  /// Nghĩa tiếng Việt.
  final String vietnamese;

  /// Phiên âm latin (rỗng nếu không có).
  final String romanization;

  /// Ghi chú sử dụng, mẹo văn hoá.
  final String note;

  /// true = câu giao tiếp, false = từ vựng đơn.
  final bool isSentence;

  /// Mã ngôn ngữ suy ra từ [id].
  String get languageCode => id.split('.').first;

  /// Mã tình huống suy ra từ [id].
  String get scenarioCode => id.split('.')[1];
}
