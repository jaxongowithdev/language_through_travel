import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/library.dart';
import '../../models/spoken_line.dart';
import '../../models/topic.dart';
import '../../state/learn_state.dart';
import '../../theme/palette.dart';
import '../screens/lesson_screen.dart';
import '../screens/review_screen.dart';
import '../screens/search_screen.dart';
import '../screens/topic_screen.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

/// Tab Hôm nay: bảng điều khiển gom mọi thứ người dùng cần trong một lần cuộn.
class TodayTab extends StatelessWidget {
  const TodayTab({super.key, required this.onOpenTab});

  /// Cho phép các thẻ ở đây chuyển sang tab khác của khung chính.
  final ValueChanged<int> onOpenTab;

  static String _greeting(int hour) {
    if (hour < 11) return 'Chào buổi sáng';
    if (hour < 14) return 'Chào buổi trưa';
    if (hour < 18) return 'Chào buổi chiều';
    return 'Chào buổi tối';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.watch<LearnState>();
    final Library library = state.library;
    final DateTime now = DateTime.now();

    final Topic next = state.suggestedTopic;
    final DailyTip tip = library.tipFor(now);
    final int dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final SpokenLine lineOfDay =
        library.allLines[dayOfYear % library.allLines.length];

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _greeting(now.hour),
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 2),
                    Text('Nói Ngay', style: theme.textTheme.headlineMedium),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const SearchScreen(),
                  ),
                ),
                icon: const Icon(Icons.search_rounded),
                tooltip: 'Tìm câu, từ hoặc mục sổ tay',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _GoalCard(state: state),
          const SizedBox(height: 14),
          if (state.dueCount > 0) ...<Widget>[
            _DueCard(count: state.dueCount),
            const SizedBox(height: 14),
          ],
          _ContinueCard(topic: next, progress: state.topicProgress(next)),
          const SizedBox(height: 14),
          _LineOfDayCard(line: lineOfDay),
          const SizedBox(height: 14),
          _TipCard(tip: tip),
          const SizedBox(height: 14),
          _WeekCard(counts: state.recentCounts(7), goal: state.dailyGoal),
          const SizedBox(height: 14),
          _ShortcutRow(onOpenTab: onOpenTab),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.state});

  final LearnState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      child: Row(
        children: <Widget>[
          GoalRing(
            ratio: state.goalRatio,
            centerTop: '${state.todayCount}',
            centerBottom: 'trên ${state.dailyGoal}',
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  state.goalReached
                      ? 'Xong mục tiêu hôm nay'
                      : 'Mục tiêu hôm nay',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  state.goalReached
                      ? 'Học thêm bao nhiêu cũng được tính vào thống kê.'
                      : 'Còn ${state.dailyGoal - state.todayCount} câu nữa là '
                          'đủ mục tiêu.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 14),
                // Wrap thay cho Row: trên máy hẹp hai nhãn tự xuống dòng.
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    Pill(
                      label: '${state.streak} ngày liền',
                      icon: Icons.local_fire_department_rounded,
                      tint: Palette.amber,
                    ),
                    Pill(
                      label: '${state.learnedCount} câu thuộc',
                      icon: Icons.verified_rounded,
                      tint: Palette.mint,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DueCard extends StatelessWidget {
  const _DueCard({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      tint: Palette.rose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.replay_rounded, color: Palette.rose),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$count câu đến hạn ôn',
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Hệ thống hộp đưa câu quay lại đúng lúc bạn sắp quên. Ôn hết chỗ '
            'này là câu leo lên hộp cao hơn.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 14),
          GradientButton(
            label: 'Ôn ngay',
            icon: Icons.play_arrow_rounded,
            colors: const <Color>[Palette.rose, Palette.amber],
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(builder: (_) => const ReviewScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.topic, required this.progress});

  final Topic topic;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      tint: topic.tint,
      onTap: () => Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => TopicScreen(topic: topic)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: topic.tint.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(topic.icon, color: topic.tint),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      progress > 0 ? 'Học tiếp' : 'Chủ đề gợi ý',
                      style: theme.textTheme.labelSmall,
                    ),
                    Text(topic.title, style: theme.textTheme.titleMedium),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
          const SizedBox(height: 12),
          Text(topic.subtitle, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          ProgressBar(value: progress, tint: topic.tint),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).round()} phần trăm câu đã chạm tới · '
            '${topic.lessons.length} bài học',
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _LineOfDayCard extends StatelessWidget {
  const _LineOfDayCard({required this.line});

  final SpokenLine line;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.read<LearnState>();
    final Topic topic = state.library.topic(line.topicCode);

    return GlassCard(
      tint: Palette.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.format_quote_rounded,
                  size: 18, color: Palette.cyan),
              const SizedBox(width: 8),
              Text('Câu của ngày', style: theme.textTheme.labelMedium),
              const SizedBox(width: 10),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Pill(label: topic.title, tint: topic.tint),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            line.english,
            style: theme.textTheme.headlineSmall?.copyWith(height: 1.3),
          ),
          const SizedBox(height: 6),
          Text(line.vietnamese, style: theme.textTheme.bodyMedium),
          if (line.tip.isNotEmpty) ...<Widget>[
            const SizedBox(height: 10),
            Text(line.tip, style: theme.textTheme.bodySmall),
          ],
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => state.say(line.english),
                  icon: const Icon(Icons.volume_up_rounded, size: 18),
                  label: const Text('Nghe'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => state.toggleSaved(line.id),
                  icon: Icon(
                    state.isSaved(line.id)
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    size: 18,
                  ),
                  label: Text(state.isSaved(line.id) ? 'Đã lưu' : 'Lưu'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final DailyTip tip;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      tint: Palette.amber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.tips_and_updates_rounded,
                  size: 18, color: Palette.amber),
              const SizedBox(width: 8),
              Text('Mẹo hôm nay', style: theme.textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 10),
          Text(tip.title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(tip.body, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _WeekCard extends StatelessWidget {
  const _WeekCard({required this.counts, required this.goal});

  final List<int> counts;
  final int goal;

  static const List<String> _labels = <String>[
    'T2',
    'T3',
    'T4',
    'T5',
    'T6',
    'T7',
    'CN',
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int peak = counts.fold<int>(
      goal,
      (int a, int b) => b > a ? b : a,
    );
    final DateTime today = DateTime.now();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Bảy ngày gần nhất', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Cột càng cao là ngày đó bạn ôn càng nhiều câu.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 96,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                for (int i = 0; i < counts.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            counts[i] == 0 ? '' : '${counts[i]}',
                            style: theme.textTheme.labelSmall,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: peak == 0
                                ? 4
                                : 4 + 58 * (counts[i] / peak),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: counts[i] >= goal
                                    ? Palette.brandGradient
                                    : <Color>[
                                        Palette.indigo
                                            .withValues(alpha: 0.55),
                                        Palette.indigo
                                            .withValues(alpha: 0.30),
                                      ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _labels[(today
                                        .subtract(
                                          Duration(
                                            days: counts.length - 1 - i,
                                          ),
                                        )
                                        .weekday -
                                    1) %
                                7],
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortcutRow extends StatelessWidget {
  const _ShortcutRow({required this.onOpenTab});

  final ValueChanged<int> onOpenTab;

  @override
  Widget build(BuildContext context) {
    final LearnState state = context.read<LearnState>();
    return Row(
      children: <Widget>[
        Expanded(
          child: _Shortcut(
            icon: Icons.school_rounded,
            label: 'Học câu mới',
            tint: Palette.violet,
            onTap: () {
              final List<SpokenLine> fresh = state.freshLines(limit: 8);
              if (fresh.isEmpty) {
                onOpenTab(1);
                return;
              }
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => LessonScreen.fromLines(
                    title: 'Câu mới cho hôm nay',
                    lines: fresh,
                    tint: Palette.violet,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Shortcut(
            icon: Icons.sports_esports_rounded,
            label: 'Vào luyện tập',
            tint: Palette.amber,
            onTap: () => onOpenTab(2),
          ),
        ),
      ],
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({
    required this.icon,
    required this.label,
    required this.tint,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color tint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      tint: tint,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: tint),
          const SizedBox(height: 12),
          Text(label, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
