import 'dart:ui';

import 'package:flutter/material.dart';

/// Thẻ kính mờ — đơn vị bố cục cơ bản của toàn app.
///
/// Ở chế độ tối, thẻ là một lớp trắng rất nhạt phủ lên nền cực quang và có làm
/// mờ hậu cảnh. Ở chế độ sáng, thẻ chuyển thành nền trắng đặc với viền mảnh vì
/// kính mờ trên nền sáng gần như không nhìn ra.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 26,
    this.tint,
    this.onTap,
    this.borderStrength = 1,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  /// Màu nhấn hoà nhẹ vào nền thẻ, thường là màu của chủ đề.
  final Color? tint;

  final VoidCallback? onTap;

  /// Nhân với độ đậm viền mặc định; dùng 0 để bỏ viền.
  final double borderStrength;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color accent = tint ?? theme.colorScheme.primary;

    final BorderRadius shape = BorderRadius.circular(radius);
    final Color fill = isDark
        ? Color.alphaBlend(accent.withValues(alpha: 0.10), Colors.white)
            .withValues(alpha: 0.07)
        : Colors.white;
    final Color border = isDark
        ? Colors.white.withValues(alpha: 0.10 * borderStrength)
        : accent.withValues(alpha: 0.16 * borderStrength);

    final Widget content = Padding(padding: padding, child: child);

    return ClipRRect(
      borderRadius: shape,
      child: BackdropFilter(
        filter: isDark
            ? ImageFilter.blur(sigmaX: 14, sigmaY: 14)
            : ImageFilter.blur(sigmaX: 0.001, sigmaY: 0.001),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: fill,
            borderRadius: shape,
            border: Border.all(color: border),
            boxShadow: isDark
                ? null
                : <BoxShadow>[
                    BoxShadow(
                      color: accent.withValues(alpha: 0.07),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: onTap == null
              ? content
              : Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: shape,
                    child: content,
                  ),
                ),
        ),
      ),
    );
  }
}
