import 'package:flutter/material.dart';

import 'dialogue.dart';
import 'phrase.dart';

/// Một chặng trong hành trình du lịch: sân bay → khách sạn → nhà hàng → taxi.
@immutable
class Scenario {
  const Scenario({
    required this.code,
    required this.title,
    required this.tagline,
    required this.icon,
    required this.color,
    required this.order,
    required this.phrases,
    required this.dialogues,
  });

  /// Mã ngắn: `airport`, `hotel`, `restaurant`, `taxi`.
  final String code;
  final String title;
  final String tagline;
  final IconData icon;
  final Color color;

  /// Thứ tự trong hành trình, bắt đầu từ 0.
  final int order;

  final List<Phrase> phrases;
  final List<Dialogue> dialogues;

  int get phraseCount => phrases.length;
}

/// Metadata dùng chung cho mọi ngôn ngữ — chỉ nội dung là khác nhau.
class ScenarioMeta {
  const ScenarioMeta({
    required this.code,
    required this.title,
    required this.tagline,
    required this.icon,
    required this.color,
    required this.order,
  });

  final String code;
  final String title;
  final String tagline;
  final IconData icon;
  final Color color;
  final int order;

  static const List<ScenarioMeta> all = <ScenarioMeta>[
    ScenarioMeta(
      code: 'airport',
      title: 'Sân bay',
      tagline: 'Check-in, hải quan, tìm cổng lên máy bay',
      icon: Icons.flight_takeoff_rounded,
      color: Color(0xFF3B82F6),
      order: 0,
    ),
    ScenarioMeta(
      code: 'hotel',
      title: 'Khách sạn',
      tagline: 'Nhận phòng, yêu cầu dịch vụ, trả phòng',
      icon: Icons.hotel_rounded,
      color: Color(0xFF8B5CF6),
      order: 1,
    ),
    ScenarioMeta(
      code: 'restaurant',
      title: 'Nhà hàng',
      tagline: 'Đặt bàn, gọi món, thanh toán',
      icon: Icons.restaurant_rounded,
      color: Color(0xFFF59E0B),
      order: 2,
    ),
    ScenarioMeta(
      code: 'taxi',
      title: 'Taxi & di chuyển',
      tagline: 'Bắt xe, chỉ đường, trả tiền',
      icon: Icons.local_taxi_rounded,
      color: Color(0xFF10B981),
      order: 3,
    ),
  ];

  static ScenarioMeta byCode(String code) {
    return all.firstWhere((ScenarioMeta m) => m.code == code);
  }
}
