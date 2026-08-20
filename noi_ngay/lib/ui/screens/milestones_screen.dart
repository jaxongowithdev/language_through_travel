import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/milestone.dart';
import '../../state/learn_state.dart';
import '../widgets/aurora_background.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

/// Danh sách mười hai cột mốc, luôn tính lại từ tiến độ thật.
class MilestonesScreen extends StatelessWidget {
  const MilestonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.watch<LearnState>();
    final List<Milestone> milestones = state.milestones;
    final int reached = milestones.where((Milestone m) => m.reached).length;

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 18, 8),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Cột mốc',
                              style: theme.textTheme.titleLarge),
                          Text(
                            'Đã đạt $reached trên ${milestones.length}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                  itemCount: milestones.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (BuildContext context, int i) {
                    final Milestone m = milestones[i];
                    return GlassCard(
                      tint: m.tint,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(11),
                            decoration: BoxDecoration(
                              color: m.tint
                                  .withValues(alpha: m.reached ? 0.22 : 0.10),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              m.icon,
                              color: m.reached
                                  ? m.tint
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        m.title,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                    if (m.reached)
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: 19,
                                        color: m.tint,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(m.description,
                                    style: theme.textTheme.bodySmall),
                                const SizedBox(height: 12),
                                ProgressBar(
                                  value: m.ratio,
                                  tint: m.tint,
                                  height: 6,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${m.current.clamp(0, m.target)} / '
                                  '${m.target}',
                                  style: theme.textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
