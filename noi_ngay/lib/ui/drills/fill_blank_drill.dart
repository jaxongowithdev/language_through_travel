import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/spoken_line.dart';
import '../../state/learn_state.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';
import 'drill_common.dart';

/// Điền từ còn thiếu.
///
/// Mỗi câu bị khoét một từ có nghĩa (bỏ qua các từ chức năng quá ngắn), người
/// học chọn một trong bốn từ. Ba đáp án nhiễu lấy từ chính kho câu của app nên
/// chúng luôn là từ thật, không phải chuỗi ngẫu nhiên.
class FillBlankDrill extends StatefulWidget {
  const FillBlankDrill({super.key, required this.pool});

  final List<SpokenLine> pool;

  static const int questionCount = 10;

  @override
  State<FillBlankDrill> createState() => _FillBlankDrillState();
}

class _Question {
  const _Question({
    required this.line,
    required this.masked,
    required this.answer,
    required this.options,
  });

  final SpokenLine line;
  final String masked;
  final String answer;
  final List<String> options;
}

class _FillBlankDrillState extends State<FillBlankDrill> {
  final Random _random = Random();
  late List<_Question> _questions;
  int _index = 0;
  int _score = 0;
  String? _chosen;

  @override
  void initState() {
    super.initState();
    _questions = _build();
  }

  /// Từ đủ dài để việc khoét chỗ trống là một câu hỏi thật sự.
  static bool _isGoodTarget(String word) =>
      word.length >= 4 &&
      !const <String>{
        'this',
        'that',
        'with',
        'from',
        'your',
        'they',
        'have',
        'been',
        'will',
        'what',
        'when',
        'would',
        'could',
        'there',
        'their',
        'about',
      }.contains(word.toLowerCase());

  static String _clean(String word) =>
      word.replaceAll(RegExp(r'[^A-Za-z-]'), '');

  List<_Question> _build() {
    final List<String> vocabulary = <String>{
      for (final SpokenLine line in widget.pool)
        for (final String raw in line.english.split(' '))
          if (_isGoodTarget(_clean(raw))) _clean(raw).toLowerCase(),
    }.toList();

    final List<_Question> result = <_Question>[];
    final List<SpokenLine> candidates = pickSome<SpokenLine>(
      widget.pool.where((SpokenLine l) => l.wordCount >= 5).toList(),
      FillBlankDrill.questionCount * 3,
      _random,
    );

    for (final SpokenLine line in candidates) {
      if (result.length >= FillBlankDrill.questionCount) break;
      final List<String> words = line.english.split(' ');
      final List<int> targets = <int>[
        for (int i = 0; i < words.length; i++)
          if (_isGoodTarget(_clean(words[i]))) i,
      ];
      if (targets.isEmpty) continue;

      final int chosen = targets[_random.nextInt(targets.length)];
      final String answer = _clean(words[chosen]).toLowerCase();
      final List<String> masked = List<String>.of(words);
      masked[chosen] = words[chosen].replaceAll(
        RegExp(r'[A-Za-z-]+'),
        '______',
      );

      final List<String> distractors = <String>[];
      int guard = 0;
      while (distractors.length < 3 && guard < 200 && vocabulary.isNotEmpty) {
        guard += 1;
        final String pick = vocabulary[_random.nextInt(vocabulary.length)];
        if (pick != answer && !distractors.contains(pick)) {
          distractors.add(pick);
        }
      }
      if (distractors.length < 3) continue;

      final List<String> options = <String>[answer, ...distractors]
        ..shuffle(_random);
      result.add(
        _Question(
          line: line,
          masked: masked.join(' '),
          answer: answer,
          options: options,
        ),
      );
    }
    return result;
  }

  void _answer(String option) {
    if (_chosen != null) return;
    final _Question question = _questions[_index];
    final bool correct = option == question.answer;
    if (correct) _score += 1;
    feedBox(context, question.line, correct);
    setState(() => _chosen = option);
  }

  void _next() {
    if (_index + 1 >= _questions.length) {
      context.read<LearnState>().submitScore(Drill.fillBlank.id, _score);
    }
    setState(() {
      _index += 1;
      _chosen = null;
    });
  }

  void _restart() {
    setState(() {
      _questions = _build();
      _index = 0;
      _score = 0;
      _chosen = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (_questions.isEmpty) {
      return DrillShell(
        drill: Drill.fillBlank,
        progress: 0,
        trailing: '',
        child: const EmptyHint(
          icon: Icons.inbox_rounded,
          title: 'Chưa đủ câu để chơi',
          body: 'Hãy chọn nhóm câu rộng hơn, ví dụ Tất cả chủ đề.',
        ),
      );
    }

    if (_index >= _questions.length) {
      return DrillShell(
        drill: Drill.fillBlank,
        progress: 1,
        trailing: '$_score/${_questions.length}',
        child: DrillResultView(
          drill: Drill.fillBlank,
          score: _score,
          total: _questions.length,
          onRetry: _restart,
        ),
      );
    }

    final _Question question = _questions[_index];
    final LearnState state = context.read<LearnState>();

    return DrillShell(
      drill: Drill.fillBlank,
      progress: _index / _questions.length,
      trailing: '${_index + 1}/${_questions.length}',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: <Widget>[
          GlassCard(
            tint: Drill.fillBlank.tint,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Điền từ còn thiếu',
                    style: theme.textTheme.labelMedium),
                const SizedBox(height: 12),
                Text(
                  question.masked,
                  style: theme.textTheme.headlineSmall?.copyWith(height: 1.4),
                ),
                const SizedBox(height: 10),
                Text(
                  question.line.vietnamese,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          for (final String option in question.options) ...<Widget>[
            AnswerTile(
              text: option,
              tint: Drill.fillBlank.tint,
              onTap: _chosen == null ? () => _answer(option) : null,
              state: _chosen == null
                  ? AnswerState.idle
                  : option == question.answer
                      ? AnswerState.correct
                      : option == _chosen
                          ? AnswerState.wrong
                          : AnswerState.dimmed,
            ),
            const SizedBox(height: 10),
          ],
          if (_chosen != null) ...<Widget>[
            const SizedBox(height: 6),
            GlassCard(
              tint: Drill.fillBlank.tint,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(question.line.english,
                      style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => state.say(question.line.english),
                    icon: const Icon(Icons.volume_up_rounded, size: 18),
                    label: const Text('Nghe câu đầy đủ'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientButton(
              label: _index + 1 >= _questions.length
                  ? 'Xem kết quả'
                  : 'Câu tiếp theo',
              icon: Icons.arrow_forward_rounded,
              colors: <Color>[Drill.fillBlank.tint, Drill.fillBlank.tint],
              onPressed: _next,
            ),
          ],
        ],
      ),
    );
  }
}
