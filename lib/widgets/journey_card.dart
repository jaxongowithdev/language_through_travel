import 'package:flutter/material.dart';

import '../models/scenario.dart';

/// Thẻ một chặng trong hành trình trên màn hình chính.
class JourneyCard extends StatelessWidget {
  const JourneyCard({
    super.key,
    required this.scenario,
    required this.progress,
    required this.learnedCount,
    required this.locked,
    required this.isLast,
    required this.onTap,
  });

  final Scenario scenario;
  final double progress;
  final int learnedCount;
  final bool locked;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool done = progress >= 1.0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _Timeline(color: scenario.color, done: done, isLast: isLast),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Opacity(
                opacity: locked ? 0.55 : 1,
                child: Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: scenario.color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  locked ? Icons.lock_rounded : scenario.icon,
                                  color: scenario.color,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      scenario.title,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      scenario.tagline,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              backgroundColor:
                                  scenario.color.withValues(alpha: 0.15),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                scenario.color,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            locked
                                ? 'Hoàn thành 50% chặng trước để mở khoá'
                                : '$learnedCount/${scenario.phraseCount} câu đã học',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.color, required this.done, required this.isLast});

  final Color color;
  final bool done;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      child: Column(
        children: <Widget>[
          Container(
            width: 14,
            height: 14,
            margin: const EdgeInsets.only(top: 22),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? color : Colors.transparent,
              border: Border.all(color: color, width: 2.5),
            ),
          ),
          if (!isLast)
            Expanded(
              child: Container(
                width: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: color.withValues(alpha: 0.3),
              ),
            ),
        ],
      ),
    );
  }
}
