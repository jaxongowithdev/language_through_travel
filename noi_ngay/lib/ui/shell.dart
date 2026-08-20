import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/learn_state.dart';
import '../theme/palette.dart';
import 'tabs/drill_tab.dart';
import 'tabs/me_tab.dart';
import 'tabs/today_tab.dart';
import 'tabs/topics_tab.dart';
import 'widgets/aurora_background.dart';

/// Khung bốn tab với thanh điều hướng kính mờ nổi trên nội dung.
///
/// Khác với thanh tab dựng sẵn của Material, thanh này trôi cách đáy màn hình
/// một khoảng và để nội dung chạy phía dưới, nên nền cực quang không bị cắt
/// ngang. Mỗi tab giữ nguyên trạng thái cuộn nhờ [IndexedStack].
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const List<_TabSpec> _tabs = <_TabSpec>[
    _TabSpec('Hôm nay', Icons.bolt_rounded, Palette.violet),
    _TabSpec('Chủ đề', Icons.grid_view_rounded, Palette.cyan),
    _TabSpec('Luyện tập', Icons.sports_esports_rounded, Palette.amber),
    _TabSpec('Cá nhân', Icons.person_rounded, Palette.fuchsia),
  ];

  void _select(int value) {
    if (_index == value) return;
    setState(() => _index = value);
  }

  @override
  Widget build(BuildContext context) {
    final LearnState state = context.watch<LearnState>();

    return PopScope<Object?>(
      // Nút back của Android: nếu đang ở tab khác thì về tab Hôm nay trước,
      // chỉ ở tab Hôm nay mới cho thoát app.
      canPop: _index == 0,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        _select(0);
      },
      child: Scaffold(
        extendBody: true,
        body: AuroraBackground(
          topTint: _tabs[_index].tint,
          child: IndexedStack(
            index: _index,
            children: <Widget>[
              TodayTab(onOpenTab: _select),
              const TopicsTab(),
              const DrillTab(),
              const MeTab(),
            ],
          ),
        ),
        bottomNavigationBar: _GlassTabBar(
          index: _index,
          tabs: _tabs,
          dueCount: state.dueCount,
          onSelect: _select,
        ),
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec(this.label, this.icon, this.tint);
  final String label;
  final IconData icon;
  final Color tint;
}

class _GlassTabBar extends StatelessWidget {
  const _GlassTabBar({
    required this.index,
    required this.tabs,
    required this.dueCount,
    required this.onSelect,
  });

  final int index;
  final List<_TabSpec> tabs;
  final int dueCount;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF10152E).withValues(alpha: 0.82)
                    : Colors.white.withValues(alpha: 0.90),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.10)
                      : theme.colorScheme.outlineVariant,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.34 : 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 8,
                ),
                child: Row(
                  children: <Widget>[
                    for (int i = 0; i < tabs.length; i++)
                      Expanded(
                        child: _TabButton(
                          spec: tabs[i],
                          selected: i == index,
                          badge: i == 2 && dueCount > 0 ? dueCount : 0,
                          onTap: () => onSelect(i),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.spec,
    required this.selected,
    required this.badge,
    required this.onTap,
  });

  final _TabSpec spec;
  final bool selected;
  final int badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color active = spec.tint;
    final Color idle = theme.colorScheme.onSurfaceVariant;

    return Semantics(
      selected: selected,
      button: true,
      label: spec.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? active.withValues(alpha: 0.16) : null,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Icon(
                    spec.icon,
                    size: 22,
                    color: selected ? active : idle,
                  ),
                  if (badge > 0)
                    Positioned(
                      right: -8,
                      top: -5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Palette.rose,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badge > 99 ? '99+' : '$badge',
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                spec.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  height: 1.1,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? active : idle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
