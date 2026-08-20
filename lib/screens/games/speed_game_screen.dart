import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/phrase.dart';
import '../../models/srs_card.dart';
import '../../state/app_state.dart';
import '../../widgets/game_result_view.dart';

/// Id dùng để lưu kỷ lục trong [AppState.gameBest].
const String speedGameId = 'speed';

/// Thời lượng một ván, tính bằng giây.
const int kSpeedGameSeconds = 60;

class _SpeedQuestion {
  const _SpeedQuestion({
    required this.phrase,
    required this.options,
    required this.answerIndex,
  });

  final Phrase phrase;
  final List<String> options;
  final int answerIndex;
}

/// Trò "Thử thách 60 giây": trả lời càng nhiều càng tốt trước khi hết giờ.
///
/// Trộn câu của cả bốn chặng nên đây là bài kiểm tra tổng hợp nhanh nhất.
class SpeedGameScreen extends StatefulWidget {
  const SpeedGameScreen({super.key, required this.phrases});

  final List<Phrase> phrases;

  @override
  State<SpeedGameScreen> createState() => _SpeedGameScreenState();
}

class _SpeedGameScreenState extends State<SpeedGameScreen> {
  final Random _random = Random();

  late List<Phrase> _deck;
  int _deckIndex = 0;
  _SpeedQuestion? _question;

  int _correct = 0;
  int _answered = 0;
  int _remaining = kSpeedGameSeconds;
  int? _picked;
  bool _finished = false;
  bool _isRecord = false;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _start() {
    _deck = List<Phrase>.of(widget.phrases)..shuffle(_random);
    _deckIndex = 0;
    _correct = 0;
    _answered = 0;
    _remaining = kSpeedGameSeconds;
    _picked = null;
    _finished = false;
    _isRecord = false;
    _question = _nextQuestion();

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (Timer _) {
      if (!mounted) return;
      if (_remaining <= 1) {
        setState(() => _remaining = 0);
        unawaited(_finish());
        return;
      }
      setState(() => _remaining -= 1);
    });
  }

  _SpeedQuestion? _nextQuestion() {
    if (_deck.isEmpty) return null;
    if (_deckIndex >= _deck.length) {
      _deck.shuffle(_random);
      _deckIndex = 0;
    }
    final Phrase correct = _deck[_deckIndex];
    _deckIndex += 1;

    final List<String> distractors = widget.phrases
        .where((Phrase p) => p.id != correct.id && p.target != correct.target)
        .map((Phrase p) => p.target)
        .toList()
      ..shuffle(_random);

    final List<String> options = <String>[
      correct.target,
      ...distractors.take(3),
    ]..shuffle(_random);

    return _SpeedQuestion(
      phrase: correct,
      options: options,
      answerIndex: options.indexOf(correct.target),
    );
  }

  Future<void> _pick(int index) async {
    final _SpeedQuestion? q = _question;
    if (q == null || _picked != null || _finished) return;

    final bool right = index == q.answerIndex;
    setState(() {
      _picked = index;
      _answered += 1;
      if (right) _correct += 1;
    });

    await context.read<AppState>().reviewPhrase(
          q.phrase.id,
          right ? RecallQuality.good : RecallQuality.again,
        );
    await Future<void>.delayed(
      Duration(milliseconds: right ? 260 : 800),
    );
    if (!mounted || _finished) return;

    setState(() {
      _picked = null;
      _question = _nextQuestion();
    });
  }

  Future<void> _finish() async {
    if (_finished) return;
    _ticker?.cancel();
    final bool record =
        await context.read<AppState>().recordGameScore(speedGameId, _correct);
    if (!mounted) return;
    setState(() {
      _finished = true;
      _isRecord = record;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppState state = context.watch<AppState>();
    final _SpeedQuestion? q = _question;

    if (widget.phrases.length < 4) {
      return Scaffold(
        appBar: AppBar(title: const Text('Thử thách 60 giây')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'Cần ít nhất 4 câu để tạo đáp án nhiễu.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    if (_finished || q == null) {
      final int accuracy =
          _answered == 0 ? 0 : (_correct / _answered * 100).round();
      return GameResultView(
        title: 'Thử thách 60 giây',
        score: _correct,
        scoreSuffix: ' câu',
        detail: 'Trả lời $_answered câu · chính xác $accuracy%',
        best: state.gameBest(speedGameId),
        isRecord: _isRecord,
        message: _correct >= 15
            ? 'Tốc độ này là phản xạ thật rồi, không phải đọc hiểu nữa.'
            : '',
        onRetry: () => setState(_start),
      );
    }

    final double timeLeft = _remaining / kSpeedGameSeconds;
    final Color timeColor = _remaining <= 10
        ? const Color(0xFFEF4444)
        : theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thử thách 60 giây'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: timeLeft,
            minHeight: 4,
            valueColor: AlwaysStoppedAnimation<Color>(timeColor),
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
                  '⏱ $_remaining giây',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: timeColor,
                  ),
                ),
                Text(
                  'Đúng $_correct',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              'Nói thế nào?',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              q.phrase.vietnamese,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: q.options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (BuildContext context, int i) {
                  final bool revealed = _picked != null;
                  final bool isAnswer = i == q.answerIndex;
                  final bool isPicked = i == _picked;
                  Color background = theme.colorScheme.surfaceContainerLow;
                  Color border = theme.colorScheme.outlineVariant;
                  if (revealed && isAnswer) {
                    background = const Color(0xFF10B981).withValues(alpha: 0.15);
                    border = const Color(0xFF10B981);
                  } else if (revealed && isPicked) {
                    background = const Color(0xFFEF4444).withValues(alpha: 0.15);
                    border = const Color(0xFFEF4444);
                  }
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _pick(i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: border),
                      ),
                      child: Text(
                        q.options[i],
                        style: theme.textTheme.titleSmall?.copyWith(
                          height: 1.35,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
