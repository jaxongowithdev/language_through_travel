import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/phrase.dart';
import '../../models/srs_card.dart';
import '../../state/app_state.dart';
import '../../widgets/game_result_view.dart';

/// Id dùng để lưu kỷ lục trong [AppState.gameBest].
const String trueFalseGameId = 'truefalse';

const int _roundCount = 12;

class _TfQuestion {
  const _TfQuestion({
    required this.phrase,
    required this.shownMeaning,
    required this.isCorrectPair,
  });

  final Phrase phrase;

  /// Nghĩa tiếng Việt được đưa ra để phán đoán.
  final String shownMeaning;

  /// true nếu [shownMeaning] đúng là nghĩa của [phrase].
  final bool isCorrectPair;
}

/// Trò "Đúng hay Sai": ghép nhanh câu với nghĩa, chỉ có hai lựa chọn.
///
/// Nhịp nhanh hơn quiz bốn đáp án nên hợp để làm nóng trước khi ôn.
class TrueFalseGameScreen extends StatefulWidget {
  const TrueFalseGameScreen({super.key, required this.phrases});

  final List<Phrase> phrases;

  @override
  State<TrueFalseGameScreen> createState() => _TrueFalseGameScreenState();
}

class _TrueFalseGameScreenState extends State<TrueFalseGameScreen> {
  final Random _random = Random();

  late List<_TfQuestion> _questions;
  int _index = 0;
  int _correct = 0;
  int _streak = 0;
  int _bestStreak = 0;
  bool? _lastAnswerRight;
  bool _finished = false;
  bool _isRecord = false;

  @override
  void initState() {
    super.initState();
    _questions = _build();
  }

  List<_TfQuestion> _build() {
    final List<Phrase> pool = List<Phrase>.of(widget.phrases)..shuffle(_random);
    final int count = min(_roundCount, pool.length);

    return List<_TfQuestion>.generate(count, (int i) {
      final Phrase phrase = pool[i];
      final bool showCorrect = _random.nextBool();
      if (showCorrect) {
        return _TfQuestion(
          phrase: phrase,
          shownMeaning: phrase.vietnamese,
          isCorrectPair: true,
        );
      }
      final List<Phrase> others = widget.phrases
          .where((Phrase p) => p.id != phrase.id && p.vietnamese != phrase.vietnamese)
          .toList();
      if (others.isEmpty) {
        return _TfQuestion(
          phrase: phrase,
          shownMeaning: phrase.vietnamese,
          isCorrectPair: true,
        );
      }
      return _TfQuestion(
        phrase: phrase,
        shownMeaning: others[_random.nextInt(others.length)].vietnamese,
        isCorrectPair: false,
      );
    });
  }

  Future<void> _answer(bool saysTrue) async {
    if (_lastAnswerRight != null) return;
    final _TfQuestion q = _questions[_index];
    final bool right = saysTrue == q.isCorrectPair;

    setState(() {
      _lastAnswerRight = right;
      if (right) {
        _correct += 1;
        _streak += 1;
        if (_streak > _bestStreak) _bestStreak = _streak;
      } else {
        _streak = 0;
      }
    });

    // Chỉ cặp đúng mới nuôi lịch ôn: đoán "sai" cho một cặp lệch không nói
    // được gì về việc người học có nhớ câu đó hay không.
    if (q.isCorrectPair) {
      await context.read<AppState>().reviewPhrase(
            q.phrase.id,
            right ? RecallQuality.good : RecallQuality.again,
          );
    }
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    if (_index < _questions.length - 1) {
      setState(() {
        _index += 1;
        _lastAnswerRight = null;
      });
      return;
    }

    final int score = (_correct / _questions.length * 100).round();
    final bool record =
        await context.read<AppState>().recordGameScore(trueFalseGameId, score);
    if (!mounted) return;
    setState(() {
      _finished = true;
      _isRecord = record;
    });
  }

  void _restart() {
    setState(() {
      _questions = _build();
      _index = 0;
      _correct = 0;
      _streak = 0;
      _bestStreak = 0;
      _lastAnswerRight = null;
      _finished = false;
      _isRecord = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppState state = context.watch<AppState>();

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Đúng hay Sai')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text('Chưa có câu nào để chơi.', textAlign: TextAlign.center),
          ),
        ),
      );
    }

    if (_finished) {
      final int score = (_correct / _questions.length * 100).round();
      return GameResultView(
        title: 'Đúng hay Sai',
        score: score,
        scoreSuffix: '%',
        detail: 'Đúng $_correct/${_questions.length} · chuỗi dài nhất $_bestStreak',
        best: state.gameBest(trueFalseGameId),
        isRecord: _isRecord,
        onRetry: _restart,
      );
    }

    final _TfQuestion q = _questions[_index];
    final bool showRomanization =
        state.language.hasRomanization && q.phrase.romanization.isNotEmpty;
    final Color? feedback = _lastAnswerRight == null
        ? null
        : _lastAnswerRight!
            ? const Color(0xFF10B981)
            : const Color(0xFFEF4444);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đúng hay Sai'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_index + 1) / _questions.length,
            minHeight: 4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Câu ${_index + 1}/${_questions.length}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  _streak >= 2 ? '🔥 chuỗi $_streak' : 'đúng $_correct',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _streak >= 2
                        ? const Color(0xFFF97316)
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: feedback == null
                        ? theme.colorScheme.surfaceContainerLow
                        : feedback.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: feedback ?? theme.colorScheme.outlineVariant,
                      width: feedback == null ? 1 : 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        q.phrase.target,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                      if (showRomanization) ...<Widget>[
                        const SizedBox(height: 6),
                        Text(
                          q.phrase.romanization,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      Icon(
                        Icons.swap_vert_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        q.shownMeaning,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          height: 1.35,
                        ),
                      ),
                      if (_lastAnswerRight != null) ...<Widget>[
                        const SizedBox(height: 18),
                        Text(
                          _lastAnswerRight!
                              ? 'Chính xác!'
                              : 'Chưa đúng — nghĩa thật là "${q.phrase.vietnamese}"',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: feedback,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _answer(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      side: const BorderSide(color: Color(0xFFEF4444)),
                    ),
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Sai'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _answer(true),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Đúng'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
