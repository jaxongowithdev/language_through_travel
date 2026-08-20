import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/phrase.dart';
import '../models/scenario.dart';
import '../models/srs_card.dart';
import '../state/app_state.dart';

/// Một câu hỏi trắc nghiệm: cho nghĩa tiếng Việt, chọn câu đúng ở ngôn ngữ đích.
class _Question {
  const _Question({
    required this.phrase,
    required this.options,
    required this.answerIndex,
  });

  final Phrase phrase;
  final List<String> options;
  final int answerIndex;
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.scenario});

  final Scenario scenario;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<_Question> _questions;
  int _index = 0;
  int _correct = 0;
  int? _picked;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _questions = _buildQuestions(widget.scenario);
  }

  static List<_Question> _buildQuestions(Scenario scenario) {
    final Random random = Random();
    final List<Phrase> pool = List<Phrase>.of(scenario.phrases)..shuffle(random);
    final int count = min(10, pool.length);

    return List<_Question>.generate(count, (int i) {
      final Phrase correct = pool[i];
      final List<String> distractors = scenario.phrases
          .where((Phrase p) => p.id != correct.id)
          .map((Phrase p) => p.target)
          .toList()
        ..shuffle(random);

      final List<String> options = <String>[
        correct.target,
        ...distractors.take(3),
      ]..shuffle(random);

      return _Question(
        phrase: correct,
        options: options,
        answerIndex: options.indexOf(correct.target),
      );
    });
  }

  Future<void> _pick(int index) async {
    if (_picked != null) return;
    setState(() => _picked = index);

    final _Question q = _questions[_index];
    final bool right = index == q.answerIndex;
    if (right) _correct += 1;

    // Kết quả quiz cũng nuôi lịch SRS: sai → ôn lại sớm.
    await context.read<AppState>().reviewPhrase(
          q.phrase.id,
          right ? RecallQuality.good : RecallQuality.again,
        );

    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    if (_index < _questions.length - 1) {
      setState(() {
        _index += 1;
        _picked = null;
      });
    } else {
      final int percent = (_correct / _questions.length * 100).round();
      await context
          .read<AppState>()
          .recordQuizScore(widget.scenario.code, percent);
      if (!mounted) return;
      setState(() => _finished = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz · ${widget.scenario.title}')),
        body: const Center(child: Text('Chưa đủ nội dung để tạo quiz.')),
      );
    }

    if (_finished) {
      final int percent = (_correct / _questions.length * 100).round();
      return _ResultView(
        title: widget.scenario.title,
        correct: _correct,
        total: _questions.length,
        percent: percent,
        onRetry: () => setState(() {
          _index = 0;
          _correct = 0;
          _picked = null;
          _finished = false;
        }),
      );
    }

    final _Question q = _questions[_index];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz · ${widget.scenario.title}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_index + 1) / _questions.length,
            minHeight: 4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Câu ${_index + 1}/${_questions.length}  ·  đúng $_correct',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 28),
            Expanded(
              child: ListView.separated(
                itemCount: q.options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (BuildContext context, int i) {
                  return _OptionCard(
                    text: q.options[i],
                    state: _stateFor(i, q.answerIndex),
                    onTap: () => _pick(i),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _OptionState _stateFor(int index, int answerIndex) {
    if (_picked == null) return _OptionState.idle;
    if (index == answerIndex) return _OptionState.correct;
    if (index == _picked) return _OptionState.wrong;
    return _OptionState.dimmed;
  }
}

enum _OptionState { idle, correct, wrong, dimmed }

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.text,
    required this.state,
    required this.onTap,
  });

  final String text;
  final _OptionState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Color background = theme.colorScheme.surfaceContainerLow;
    Color border = theme.colorScheme.outlineVariant;
    IconData? icon;

    switch (state) {
      case _OptionState.idle:
        break;
      case _OptionState.correct:
        background = const Color(0xFF10B981).withValues(alpha: 0.15);
        border = const Color(0xFF10B981);
        icon = Icons.check_circle_rounded;
        break;
      case _OptionState.wrong:
        background = const Color(0xFFEF4444).withValues(alpha: 0.15);
        border = const Color(0xFFEF4444);
        icon = Icons.cancel_rounded;
        break;
      case _OptionState.dimmed:
        background =
            theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.5);
        break;
    }

    return Opacity(
      opacity: state == _OptionState.dimmed ? 0.5 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: icon != null ? 2 : 1),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.titleSmall?.copyWith(height: 1.4),
                ),
              ),
              if (icon != null) ...<Widget>[
                const SizedBox(width: 8),
                Icon(icon, color: border, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.title,
    required this.correct,
    required this.total,
    required this.percent,
    required this.onRetry,
  });

  final String title;
  final int correct;
  final int total;
  final int percent;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String emoji = percent >= 90
        ? '🏆'
        : percent >= 70
            ? '👏'
            : '💪';
    final String message = percent >= 90
        ? 'Xuất sắc! Bạn sẵn sàng cho chặng này rồi.'
        : percent >= 70
            ? 'Khá tốt. Ôn lại vài câu nữa là chắc.'
            : 'Chưa vững lắm — lật flashcard thêm rồi quay lại nhé.';

    return Scaffold(
      appBar: AppBar(title: Text('Quiz · $title')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(emoji, style: const TextStyle(fontSize: 56)),
              const SizedBox(height: 20),
              Text(
                '$percent%',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Đúng $correct/$total câu',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Quay lại'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: onRetry,
                    child: const Text('Làm lại'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
