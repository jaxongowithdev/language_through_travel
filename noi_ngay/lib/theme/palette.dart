import 'package:flutter/material.dart';

/// Bảng màu thương hiệu của Nói Ngay.
///
/// App thiết kế theo hướng "tối trước": nền gần như đen pha xanh mực, nội dung
/// nằm trên các thẻ kính mờ, điểm nhấn là dải gradient tím → hồng → cam. Chế độ
/// sáng dùng lại đúng bộ màu nhấn đó nhưng đặt trên nền kem để giữ nhận diện.
class Palette {
  const Palette._();

  // --- Nền ---------------------------------------------------------------
  static const Color night = Color(0xFF070A18);
  static const Color nightSoft = Color(0xFF0E1330);
  static const Color dawn = Color(0xFFF7F5FF);
  static const Color dawnSoft = Color(0xFFFFFFFF);

  // --- Điểm nhấn ---------------------------------------------------------
  static const Color violet = Color(0xFF8B5CF6);
  static const Color indigo = Color(0xFF6366F1);
  static const Color fuchsia = Color(0xFFEC4899);
  static const Color amber = Color(0xFFF59E0B);
  static const Color cyan = Color(0xFF22D3EE);
  static const Color lime = Color(0xFFA3E635);
  static const Color rose = Color(0xFFFB7185);
  static const Color mint = Color(0xFF34D399);

  /// Gradient chính, dùng cho nút lớn, vòng streak, tiêu đề nổi bật.
  static const List<Color> brandGradient = <Color>[violet, fuchsia];

  /// Gradient phụ ấm hơn, dùng cho các mốc thành tích.
  static const List<Color> warmGradient = <Color>[fuchsia, amber];

  /// Gradient mát, dùng cho phần nghe và phát âm.
  static const List<Color> coolGradient = <Color>[indigo, cyan];

  /// Bộ màu xoay vòng cho 20 chủ đề — đủ tương phản để phân biệt trên nền tối.
  static const List<Color> topicTints = <Color>[
    violet,
    cyan,
    amber,
    mint,
    fuchsia,
    indigo,
    lime,
    rose,
    Color(0xFF38BDF8),
    Color(0xFFFB923C),
    Color(0xFF4ADE80),
    Color(0xFFC084FC),
    Color(0xFF2DD4BF),
    Color(0xFFF472B6),
    Color(0xFFFACC15),
    Color(0xFF60A5FA),
    Color(0xFF818CF8),
    Color(0xFFF87171),
    Color(0xFF5EEAD4),
    Color(0xFFE879F9),
  ];

  static Color tintFor(int index) =>
      topicTints[index % topicTints.length];
}
