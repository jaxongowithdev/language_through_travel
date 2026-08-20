import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/achievement.dart';
import '../models/scenario.dart';
import '../state/app_state.dart';
import '../widgets/stat_tile.dart';
import 'games/listening_game_screen.dart';
import 'games/matching_game_screen.dart';
import 'games/speed_game_screen.dart';
import 'games/true_false_game_screen.dart';

/// Tổng quan tiến độ, huy hiệu, kỷ lục và cài đặt.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = context.watch<AppState>();
    final ThemeData theme = Theme.of(context);
    final double overall = state.totalPhraseCount == 0
        ? 0
        : state.learnedCount / state.totalPhraseCount;

    return Scaffold(
      appBar: AppBar(title: const Text('Tiến độ')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        state.language.flag,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.language.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        '${(overall * 100).round()}%',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: overall,
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${state.learnedCount}/${state.totalPhraseCount} câu đã tiếp xúc',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: StatTile(
                  value: '${state.dueCount}',
                  label: 'đến hạn ôn',
                  icon: Icons.schedule_rounded,
                  color: const Color(0xFF8B5CF6),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatTile(
                  value: '${state.masteredCount}',
                  label: 'đã thuộc',
                  icon: Icons.workspace_premium_rounded,
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatTile(
                  value: '${state.favouriteCount}',
                  label: 'yêu thích',
                  icon: Icons.star_rounded,
                  color: const Color(0xFFEAB308),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionTitle(
            title: 'Lịch học',
            subtitle: 'Chuỗi ${state.streak} ngày · '
                '${state.activeDaysIn(30)}/30 ngày gần đây có học',
          ),
          const SizedBox(height: 10),
          const _StreakHeatmap(),
          const SizedBox(height: 24),
          _SectionTitle(
            title: 'Huy hiệu',
            subtitle:
                '${state.unlockedAchievementCount}/${state.achievements.length} '
                'đã mở khoá',
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.22,
            children: state.achievements
                .map((Achievement a) => _AchievementCard(achievement: a))
                .toList(),
          ),
          const SizedBox(height: 24),
          const _SectionTitle(
            title: 'Kỷ lục luyện tập',
            subtitle: 'Điểm cao nhất của từng trò',
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: <Widget>[
                _RecordRow(
                  emoji: '🔗',
                  label: 'Nối cặp',
                  value: state.gameBest(matchingGameId),
                  suffix: ' điểm',
                ),
                const Divider(height: 1),
                _RecordRow(
                  emoji: '🎧',
                  label: 'Nghe đoán',
                  value: state.gameBest(listeningGameId),
                  suffix: '%',
                ),
                const Divider(height: 1),
                _RecordRow(
                  emoji: '⚖️',
                  label: 'Đúng hay Sai',
                  value: state.gameBest(trueFalseGameId),
                  suffix: '%',
                ),
                const Divider(height: 1),
                _RecordRow(
                  emoji: '⚡',
                  label: 'Thử thách 60 giây',
                  value: state.gameBest(speedGameId),
                  suffix: ' câu',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _SectionTitle(
            title: 'Theo chặng',
            subtitle: 'Tiến độ và điểm quiz từng tình huống',
          ),
          const SizedBox(height: 10),
          ...state.scenarios.map((Scenario s) {
            final int best = state.quizBest(s.code);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(s.icon, color: s.color, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              s.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            '${state.scenarioLearnedCount(s)}/${s.phraseCount}',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: state.scenarioProgress(s),
                          minHeight: 6,
                          backgroundColor: s.color.withValues(alpha: 0.15),
                          valueColor: AlwaysStoppedAnimation<Color>(s.color),
                        ),
                      ),
                      if (best > 0) ...<Widget>[
                        const SizedBox(height: 8),
                        Text(
                          'Quiz cao nhất: $best%',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          const _SectionTitle(
            title: 'Cài đặt',
            subtitle: 'Mục tiêu hằng ngày và dữ liệu học',
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  leading: const Icon(Icons.flag_rounded),
                  title: const Text('Mục tiêu mỗi ngày'),
                  subtitle: Text('${state.dailyGoal} lượt ôn'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _pickGoal(context, state),
                ),
                const Divider(height: 1),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  leading: Icon(
                    Icons.restart_alt_rounded,
                    color: theme.colorScheme.error,
                  ),
                  title: Text(
                    'Xoá tiến độ ${state.language.name}',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  onTap: () => _confirmReset(context, state),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickGoal(BuildContext context, AppState state) async {
    const List<int> options = <int>[5, 10, 20, 30, 50];
    final int? picked = await showModalBottomSheet<int>(
      context: context,
      // Navigator gốc, nếu không sheet sẽ nổi bên trên thanh tab thay vì phủ
      // toàn màn hình.
      useRootNavigator: true,
      builder: (BuildContext sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Mục tiêu mỗi ngày',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            ...options.map(
              (int value) => ListTile(
                title: Text('$value lượt ôn'),
                trailing: value == state.dailyGoal
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () => Navigator.of(sheetContext).pop(value),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (picked != null) {
      await state.setDailyGoal(picked);
    }
  }

  Future<void> _confirmReset(BuildContext context, AppState state) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Xoá tiến độ?'),
        content: Text(
          'Toàn bộ lịch ôn tập, điểm quiz, kỷ lục trò chơi và câu yêu thích '
          'của ${state.language.name} sẽ bị xoá. Không thể hoàn tác.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
    if (ok ?? false) {
      await state.resetProgress();
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Lưới 13 tuần gần nhất, ô đậm là ngày có học.
class _StreakHeatmap extends StatelessWidget {
  const _StreakHeatmap({super.key});

  static const int _weeks = 13;

  @override
  Widget build(BuildContext context) {
    final AppState state = context.watch<AppState>();
    final ThemeData theme = Theme.of(context);
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    // Ô cuối cùng là hôm nay, nên mốc bắt đầu lùi lại đúng 13 tuần trừ 1 ngày.
    final DateTime start = today.subtract(const Duration(days: _weeks * 7 - 1));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Text('🔥', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  '${state.streak} ngày liên tiếp',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '13 tuần gần nhất',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  for (int week = 0; week < _weeks; week++)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Column(
                        children: <Widget>[
                          for (int day = 0; day < 7; day++)
                            Builder(
                              builder: (BuildContext context) {
                                final DateTime date = start
                                    .add(Duration(days: week * 7 + day));
                                final bool future = date.isAfter(today);
                                final bool studied =
                                    !future && state.studiedOn(date);
                                return Container(
                                  width: 13,
                                  height: 13,
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    color: future
                                        ? Colors.transparent
                                        : studied
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.outlineVariant
                                                .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool unlocked = achievement.unlocked;

    return Card(
      color: unlocked
          ? achievement.color.withValues(alpha: 0.12)
          : theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Opacity(
                  opacity: unlocked ? 1 : 0.35,
                  child: Text(
                    achievement.emoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const Spacer(),
                if (unlocked)
                  Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: achievement.color,
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              achievement.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              achievement.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: achievement.progress,
                minHeight: 5,
                backgroundColor:
                    achievement.color.withValues(alpha: 0.15),
                valueColor:
                    AlwaysStoppedAnimation<Color>(achievement.color),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              unlocked
                  ? 'Đã mở khoá'
                  : '${achievement.current}/${achievement.target}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordRow extends StatelessWidget {
  const _RecordRow({
    required this.emoji,
    required this.label,
    required this.value,
    required this.suffix,
  });

  final String emoji;
  final String label;
  final int value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListTile(
      dense: true,
      leading: Text(emoji, style: const TextStyle(fontSize: 20)),
      title: Text(label, style: theme.textTheme.bodyMedium),
      trailing: Text(
        value > 0 ? '$value$suffix' : '—',
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: value > 0
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
