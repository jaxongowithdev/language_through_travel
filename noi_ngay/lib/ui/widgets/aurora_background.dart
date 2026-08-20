import 'package:flutter/material.dart';

import '../../theme/palette.dart';

/// Nền cực quang: hai quầng sáng mờ đặt trên nền tối.
///
/// Vẽ bằng gradient hình tròn chứ không dùng ảnh, nên không tốn dung lượng gói
/// cài và luôn sắc nét ở mọi mật độ điểm ảnh.
class AuroraBackground extends StatelessWidget {
  const AuroraBackground({
    super.key,
    required this.child,
    this.topTint,
    this.bottomTint,
  });

  final Widget child;
  final Color? topTint;
  final Color? bottomTint;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color top = topTint ?? Palette.violet;
    final Color bottom = bottomTint ?? Palette.fuchsia;
    final double strength = isDark ? 0.30 : 0.16;

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
          ),
        ),
        Positioned(
          top: -160,
          left: -110,
          child: _Blob(color: top, size: 380, opacity: strength),
        ),
        Positioned(
          top: 120,
          right: -140,
          child: _Blob(color: bottom, size: 330, opacity: strength * 0.85),
        ),
        Positioned(
          bottom: -180,
          left: 40,
          child: _Blob(
            color: isDark ? Palette.indigo : Palette.cyan,
            size: 360,
            opacity: strength * 0.6,
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({
    required this.color,
    required this.size,
    required this.opacity,
  });

  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[
              color.withValues(alpha: opacity),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
