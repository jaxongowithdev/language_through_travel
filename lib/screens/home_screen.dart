import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/language.dart';
import '../models/scenario.dart';
import '../state/app_state.dart';
import '../widgets/journey_card.dart';
import '../widgets/stat_tile.dart';
import 'review_screen.dart';
import 'scenario_screen.dart';

/// Màn hình chính: hành trình 4 chặng + ôn tập đến hạn.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = context.watch<AppState>();
    final ThemeData theme = Theme.of(context);
    final List<Scenario> scenarios = state.scenarios;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hành trình của bạn'),
        actions: <Widget>[
          _LanguagePicker(current: state.language),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          _DailyGoalCard(state: state),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: StatTile(
                  value: '${state.streak}',
                  label: 'ngày liên tiếp',
                  icon: Icons.local_fire_department_rounded,
                  color: const Color(0xFFF97316),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatTile(
                  value: '${state.learnedCount}',
                  label: 'câu đã học',
                  icon: Icons.school_rounded,
                  color: const Color(0xFF3B82F6),
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
            ],
          ),
          const SizedBox(height: 20),
          if (state.dueCount > 0) ...<Widget>[
            _ReviewBanner(count: state.dueCount),
            const SizedBox(height: 20),
          ],
          Text(
            'Chặng đường',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Sân bay → khách sạn → nhà hàng → taxi',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < scenarios.length; i++)
            JourneyCard(
              scenario: scenarios[i],
              progress: state.scenarioProgress(scenarios[i]),
              learnedCount: state.scenarioLearnedCount(scenarios[i]),
              locked: !state.isScenarioUnlocked(scenarios[i]),
              isLast: i == scenarios.length - 1,
              onTap: () {
                if (!state.isScenarioUnlocked(scenarios[i])) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Hoàn thành ít nhất 50% chặng trước để mở khoá chặng này.',
                      ),
                    ),
                  );
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ScenarioScreen(
                      scenarioCode: scenarios[i].code,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _DailyGoalCard extends StatelessWidget {
  const _DailyGoalCard({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool reached = state.reviewedToday >= state.dailyGoal;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 56,
              height: 56,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      value: state.dailyProgress,
                      strokeWidth: 6,
                      backgroundColor:
                          theme.colorScheme.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  Text(
                    reached ? '✓' : '${state.reviewedToday}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    reached ? 'Xong mục tiêu hôm nay!' : 'Mục tiêu hôm nay',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${state.reviewedToday}/${state.dailyGoal} lượt ôn '
                    '· ${state.language.flag} ${state.language.name}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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

class _ReviewBanner extends StatelessWidget {
  const _ReviewBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const ReviewScreen()),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.replay_circle_filled_rounded,
                size: 34,
                color: theme.colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$count câu đến hạn ôn',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      'Ôn đúng lúc để nhớ lâu hơn',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker({required this.current});

  final LearningLanguage current;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<LearningLanguage>(
      tooltip: 'Đổi ngôn ngữ',
      onSelected: (LearningLanguage lang) =>
          context.read<AppState>().selectLanguage(lang),
      itemBuilder: (BuildContext context) => LearningLanguage.all
          .map(
            (LearningLanguage lang) => PopupMenuItem<LearningLanguage>(
              value: lang,
              child: Row(
                children: <Widget>[
                  Text(lang.flag, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Text(lang.name),
                  if (lang.code == current.code) ...<Widget>[
                    const Spacer(),
                    const Icon(Icons.check_rounded, size: 18),
                  ],
                ],
              ),
            ),
          )
          .toList(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Text(current.flag, style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}
