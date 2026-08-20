import 'package:flutter/material.dart';

/// Một cột mốc hiển thị ở tab Cá nhân.
///
/// Cột mốc **không được lưu riêng**: [current] luôn tính lại từ dữ liệu học
/// thật mỗi lần dựng màn hình, nên không bao giờ lệch với tiến độ.
@immutable
class Milestone {
  const Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.tint,
    required this.current,
    required this.target,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color tint;

  /// Giá trị hiện tại của người học.
  final int current;

  /// Mốc cần đạt.
  final int target;

  bool get reached => current >= target;

  double get ratio =>
      target == 0 ? 1 : (current / target).clamp(0.0, 1.0).toDouble();
}
