import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/phrase.dart';
import '../models/scenario.dart';
import '../state/app_state.dart';
import 'games/listening_game_screen.dart';
import 'games/matching_game_screen.dart';
import 'games/speed_game_screen.dart';
import 'games/true_false_game_screen.dart';
import 'quiz_screen.dart';
import 'review_hub_screen.dart';

/// Nguồn câu dùng cho các trò chơi.
enum _Pool {
  all('Tất cả'),
  learned('Đã học'),
  favourite('Yêu thích');

  const _Pool(this.label);
  final String label;
}

/// Tab "Luyện tập": gộp phiên ôn theo lịch với bốn trò chơi và quiz theo chặng.
///
/// Ôn tập SRS vẫn là việc chính nên nằm ngay trên cùng; các trò chơi bên dưới
/// là cách đổi vị khi không muốn lật flashcard.
class PracticeHubScreen extends StatefulWidget {
  const PracticeHubScreen({super.key});

  @override
  State<PracticeHubScreen> createState() => _PracticeHubScreenState();
}

class _PracticeHubScreenState extends State<PracticeHubScreen> {
  _Pool _pool = _Pool.all;

  List<Phrase> _phrasesFor(AppState state) {
    switch (_pool) {
      case _Pool.all:
        return state.allPhrases;
      case _Pool.learned:
        return state.allPhrases
            .where((Phrase p) => state.isLearned(p.id))
            .toList();
      case _Pool.favourite:
        return state.favouritePhrases;
    }
  }

  void _open(BuildContext context, Widget screen, int minimum) {
    final AppState state = context.read<AppState>();
    final List<Phrase> pool = _phrasesFor(state);
    if (pool.length < minimum) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Nhóm "${_pool.label}" mới có ${pool.length} câu, '
            'trò này cần ít nhất $minimum. Đổi nhóm hoặc học thêm nhé.',
          ),
        ),
      );
      return;
    }
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = context.watch<AppState>();
    final ThemeData theme = Theme.of(context);
    final List<Phrase> pool = _phrasesFor(state);

    return Scaffold(
      appBar: AppBar(title: const Text('Luyện tập')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          _ReviewCard(dueCount: state.dueCount),
          const SizedBox(height: 24),
          Text(
            'Trò luyện tập',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Bốn cách khác nhau để chạm lại cùng một câu',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: SegmentedButton<_Pool>(
                  showSelectedIcon: false,
                  segments: <ButtonSegment<_Pool>>[
                    for (final _Pool p in _Pool.values)
                      ButtonSegment<_Pool>(value: p, label: Text(p.label)),
                  ],
                  selected: <_Pool>{_pool},
                  onSelectionChanged: (Set<_Pool> value) =>
                      setState(() => _pool = value.first),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Đang lấy câu từ nhóm "${_pool.label}" · ${pool.length} câu',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.02,
            children: <Widget>[
              _GameCard(
                emoji: '🔗',
                title: 'Nối cặp',
                subtitle: 'Ghép câu với nghĩa, tính giờ',
                color: const Color(0xFF3B82F6),
                best: state.gameBest(matchingGameId),
                bestSuffix: ' điểm',
                onTap: () => _open(
                  context,
                  MatchingGameScreen(phrases: pool),
                  6,
                ),
              ),
              _GameCard(
                emoji: '🎧',
                title: 'Nghe đoán',
                subtitle: 'Nghe TTS, chọn nghĩa đúng',
                color: const Color(0xFF8B5CF6),
                best: state.gameBest(listeningGameId),
                bestSuffix: '%',
                onTap: () => _open(
                  context,
                  ListeningGameScreen(phrases: pool),
                  4,
                ),
              ),
              _GameCard(
                emoji: '⚖️',
                title: 'Đúng hay Sai',
                subtitle: 'Phán đoán nhanh, hai lựa chọn',
                color: const Color(0xFF10B981),
                best: state.gameBest(trueFalseGameId),
                bestSuffix: '%',
                onTap: () => _open(
                  context,
                  TrueFalseGameScreen(phrases: pool),
                  4,
                ),
              ),
              _GameCard(
                emoji: '⚡',
                title: 'Thử thách 60″',
                subtitle: 'Càng nhiều câu càng tốt',
                color: const Color(0xFFF59E0B),
                best: state.gameBest(speedGameId),
                bestSuffix: ' câu',
                onTap: () => _open(
                  context,
                  SpeedGameScreen(phrases: pool),
                  4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            'Quiz theo chặng',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Mười câu trắc nghiệm cho từng tình huống',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          ...state.scenarios.map(
            (Scenario s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: s.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(s.icon, color: s.color, size: 20),
                  ),
                  title: Text(
                    s.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    state.quizBest(s.code) > 0
                        ? 'Điểm cao nhất ${state.quizBest(s.code)}%'
                        : 'Chưa làm lần nào',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    if (s.phrases.length < 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Chặng này chưa đủ câu để tạo quiz.'),
                        ),
                      );
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => QuizScreen(scenario: s),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.dueCount});

  final int dueCount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool hasDue = dueCount > 0;

    return Card(
      color: hasDue
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.replay_circle_filled_rounded,
                  size: 30,
                  color: hasDue
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hasDue ? '$dueCount thẻ đến hạn ôn' : 'Không có thẻ đến hạn',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: hasDue
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              hasDue
                  ? 'Ôn đúng lúc sắp quên là cách nhớ lâu nhất.'
                  : 'Chơi một ván bên dưới, hoặc học câu mới ở tab Hành trình.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: hasDue
                    ? theme.colorScheme.onPrimaryContainer
                        .withValues(alpha: 0.85)
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ReviewHubScreen(),
                  ),
                ),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(hasDue ? 'Bắt đầu ôn' : 'Xem lịch ôn'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.best,
    required this.bestSuffix,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final int best;
  final String bestSuffix;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      color: color.withValues(alpha: 0.10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Expanded(
                child: Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  best > 0 ? 'KL $best$bestSuffix' : 'Chưa chơi',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
