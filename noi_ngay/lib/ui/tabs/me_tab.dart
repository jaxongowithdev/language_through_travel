import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/milestone.dart';
import '../../state/learn_state.dart';
import '../../theme/palette.dart';
import '../screens/about_screen.dart';
import '../screens/milestones_screen.dart';
import '../screens/saved_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

/// Tab Cá nhân: thống kê, cột mốc, câu đã lưu và cài đặt.
class MeTab extends StatelessWidget {
  const MeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.watch<LearnState>();
    final List<Milestone> reached =
        state.milestones.where((Milestone m) => m.reached).toList();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: <Widget>[
          Text('Cá nhân', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 14),
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Tiến độ tổng', style: theme.textTheme.titleMedium),
                const SizedBox(height: 18),
                // Bốn ô số liệu chia đều bề ngang; nhãn dài như "Câu đã chạm"
                // sẽ tự xuống dòng thay vì tràn ra ngoài trên máy hẹp.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: StatChip(
                        icon: Icons.local_fire_department_rounded,
                        value: '${state.streak}',
                        label: 'Ngày liền',
                        tint: Palette.amber,
                      ),
                    ),
                    Expanded(
                      child: StatChip(
                        icon: Icons.replay_rounded,
                        value: '${state.totalReviews}',
                        label: 'Lượt ôn',
                        tint: Palette.violet,
                      ),
                    ),
                    Expanded(
                      child: StatChip(
                        icon: Icons.chat_bubble_rounded,
                        value: '${state.startedCount}',
                        label: 'Câu đã chạm',
                        tint: Palette.cyan,
                      ),
                    ),
                    Expanded(
                      child: StatChip(
                        icon: Icons.verified_rounded,
                        value: '${state.learnedCount}',
                        label: 'Câu thuộc',
                        tint: Palette.mint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Tiến độ trên kho nội dung',
                  style: theme.textTheme.labelMedium,
                ),
                const SizedBox(height: 8),
                ProgressBar(
                  value: state.library.lineCount == 0
                      ? 0
                      : state.startedCount / state.library.lineCount,
                ),
                const SizedBox(height: 8),
                Text(
                  '${state.startedCount} trên ${state.library.lineCount} câu · '
                  '${state.activeDays} ngày từng học',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _NavRow(
            icon: Icons.emoji_events_rounded,
            tint: Palette.amber,
            title: 'Cột mốc',
            subtitle:
                'Đã đạt ${reached.length} trên ${state.milestones.length}',
            onTap: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const MilestonesScreen(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _NavRow(
            icon: Icons.bookmark_rounded,
            tint: Palette.fuchsia,
            title: 'Câu đã lưu',
            subtitle: '${state.savedIds.length} câu trong sổ riêng',
            onTap: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(builder: (_) => const SavedScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _NavRow(
            icon: Icons.settings_rounded,
            tint: Palette.cyan,
            title: 'Cài đặt',
            subtitle: 'Mục tiêu ngày, giao diện, tốc độ đọc',
            onTap: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _NavRow(
            icon: Icons.info_rounded,
            tint: Palette.violet,
            title: 'Về ứng dụng',
            subtitle: 'Nội dung, quyền riêng tư và cách app hoạt động',
            onTap: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(builder: (_) => const AboutScreen()),
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Cột mốc gần đây'),
          if (reached.isEmpty)
            const GlassCard(
              child: EmptyHint(
                icon: Icons.flag_rounded,
                title: 'Chưa có cột mốc nào',
                body: 'Ôn câu đầu tiên là bạn đã mở được cột mốc thứ nhất.',
              ),
            )
          else
            for (final Milestone milestone in reached.take(4)) ...<Widget>[
              _MilestoneRow(milestone: milestone),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.tint,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color tint;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      tint: tint,
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: tint),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  const _MilestoneRow({required this.milestone});

  final Milestone milestone;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      tint: milestone.tint,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: <Widget>[
          Icon(milestone.icon, color: milestone.tint),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(milestone.title, style: theme.textTheme.titleMedium),
                Text(milestone.description,
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded, color: milestone.tint, size: 20),
        ],
      ),
    );
  }
}
