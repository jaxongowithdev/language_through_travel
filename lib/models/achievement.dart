import 'package:flutter/material.dart';

/// Một huy hiệu thành tích hiển thị ở tab Tiến độ.
///
/// Huy hiệu không được lưu riêng: [progress] luôn tính lại từ dữ liệu học
/// hiện có, nên không bao giờ lệch với tiến độ thật.
@immutable
class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.color,
    required this.current,
    required this.target,
  });

  final String id;
  final String title;
  final String description;
  final String emoji;
  final Color color;

  /// Giá trị hiện tại của người học.
  final int current;

  /// Mốc cần đạt để mở khoá.
  final int target;

  bool get unlocked => current >= target;

  double get progress =>
      target == 0 ? 1 : (current / target).clamp(0.0, 1.0).toDouble();
}
