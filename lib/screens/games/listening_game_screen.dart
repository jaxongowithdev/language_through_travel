import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/phrase.dart';
import '../../models/srs_card.dart';
import '../../state/app_state.dart';
import '../../widgets/game_result_view.dart';

/// Id dùng để lưu kỷ lục trong [AppState.gameBest].
const String listeningGameId = 'listen';

const int _questionCount = 10;

class _ListeningQuestion {
  const _ListeningQuestion({
    required this.phrase,
    required this.options,
    required this.answerIndex,
  });

  final Phrase phrase;

  /// Bốn nghĩa tiếng Việt để chọn.
  final List<String> options;
  final int answerIndex;
}

/// Trò "Nghe đoán": app đọc câu bằng TTS, người chơi chọn nghĩa đúng.
///
/// Đây là trò duy nhất không cho nhìn mặt chữ — bắt tai làm việc thay vì mắt.
class ListeningGameScreen extends StatefulWidget {
  const ListeningGameScreen({super.key, required this.phrases});

  final List<Phrase> phrases;

  @override
  State<ListeningGameScreen> createState() => _ListeningGameScreenState();
}

class _ListeningGameScreenState extends State<ListeningGameScreen> {
  final Random _random = Random();

  late List<_ListeningQuestion> _questions;
  int _index = 0;
  int _correct = 0;
  int? _picked;
  bool _revealed = false;
  bool _finished = false;
  bool _isRecord = false;

  @override
  void initState() {
    super.initState();
    _questions = _build();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  List<_ListeningQuestion> _build() {
    final List<Phrase> pool = List<Phrase>.of(widget.phrases)..shuffle(_random);
    final int count = min(_questionCount, pool.length);

    return List<_ListeningQuestion>.generate(count, (int i) {
      final Phrase correct = pool[i];
      final List<String> distractors = widget.phrases
          .where((Phrase p) => p.id != correct.id)
          .map((Phrase p) => p.vietnamese)
          .toSet()
          .toList()
        ..shuffle(_random);

      final List<String> options = <String>[
        correct.vietnamese,
        ...distractors.take(3),
      ]..shuffle(_random);

      return _ListeningQuestion(
        phrase: correct,
        options: options,
        answerIndex: options.indexOf(correct.vietnamese),
      );
    });
  }

  void _speak() {
    if (!mounted || _questions.isEmpty || _finished) return;
    context.read<AppState>().speak(_questions[_index].phrase.target);
  }

  Future<void> _pick(int index) async {
    if (_revealed) return;
    final _ListeningQuestion q = _questions[_index];
    final bool right = index == q.answerIndex;

    setState(() {
      _picked = index;
      _revealed = true;
      if (right) _correct += 1;
    });

    await context.read<AppState>().reviewPhrase(
          q.phrase.id,
          right ? RecallQuality.good : RecallQuality.again,
        );
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;

    if (_index < _questions.length - 1) {
      setState(() {
        _index += 1;
        _picked = null;
        _revealed = false;
      });
      _speak();
      return;
    }

    final int score = (_correct / _questions.length * 100).round();
    final bool record =
        await context.read<AppState>().recordGameScore(listeningGameId, score);
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
      _picked = null;
      _revealed = false;
      _finished = false;
      _isRecord = false;
    });
    _speak();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppState state = context.watch<AppState>();

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nghe đoán')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'Chưa có câu nào để luyện nghe.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    if (_finished) {
      final int score = (_correct / _questions.length * 100).round();
      return GameResultView(
        title: 'Nghe đoán',
        score: score,
        scoreSuffix: '%',
        detail: 'Nghe đúng $_correct/${_questions.length} câu',
        best: state.gameBest(listeningGameId),
        isRecord: _isRecord,
        onRetry: _restart,
      );
    }

    final _ListeningQuestion q = _questions[_index];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nghe đoán'),
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
            Text(
              'Câu ${_index + 1}/${_questions.length}  ·  đúng $_correct',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: <Widget>[
                    IconButton.filled(
                      iconSize: 40,
                      onPressed: _speak,
                      icon: const Icon(Icons.volume_up_rounded),
                      tooltip: 'Nghe lại',
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Chạm để nghe lại',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    if (_revealed) ...<Widget>[
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          q.phrase.target,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Bạn vừa nghe câu nào?',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: q.options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (BuildContext context, int i) {
                  final bool isAnswer = i == q.answerIndex;
                  final bool isPicked = i == _picked;
                  Color? background;
                  Color border = theme.colorScheme.outlineVariant;
                  if (_revealed && isAnswer) {
                    background = const Color(0xFF10B981).withValues(alpha: 0.15);
                    border = const Color(0xFF10B981);
                  } else if (_revealed && isPicked) {
                    background = const Color(0xFFEF4444).withValues(alpha: 0.15);
                    border = const Color(0xFFEF4444);
                  }
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _pick(i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: background ??
                            theme.colorScheme.surfaceContainerLow,
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
