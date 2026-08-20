import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/phrase.dart';
import '../models/srs_card.dart';
import '../state/app_state.dart';
import 'review_screen.dart';

/// Màn hình gốc của tab "Ôn tập": tổng quan thẻ đến hạn và nút bắt đầu phiên.
///
/// Tách khỏi [ReviewScreen] vì tab gốc phải luôn phản ánh số thẻ hiện tại,
/// còn phiên ôn thì cần chốt danh sách một lần rồi giữ nguyên tới khi xong.
class ReviewHubScreen extends StatelessWidget {
  const ReviewHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = context.watch<AppState>();
    final ThemeData theme = Theme.of(context);
    final List<Phrase> due = state.duePhrases;
    final int newCount = state.newPhrases.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Ôn tập')),
      body: due.isEmpty
          ? _EmptyState(newCount: newCount)
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: <Widget>[
                Card(
                  color: theme.colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${due.length} thẻ đến hạn',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Ôn đúng lúc sắp quên là cách nhớ lâu nhất.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer
                                .withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const ReviewScreen(),
                              ),
                            ),
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Bắt đầu ôn'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Sắp ôn',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                ...due.take(12).map((Phrase p) {
                  final SrsCard card = state.cardFor(p.id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Text(
                          p.target,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          p.vietnamese,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          card.lapses > 0 ? '⚠︎ ${card.lapses}' : '',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                if (due.length > 12)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'và ${due.length - 12} thẻ nữa…',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.newCount});

  final int newCount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('☕', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 20),
            Text(
              'Không có gì cần ôn',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              newCount > 0
                  ? 'Còn $newCount câu chưa học. Mở tab Hành trình để học tiếp.'
                  : 'Bạn đã học hết. Quay lại khi thẻ tới hạn nhé.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
