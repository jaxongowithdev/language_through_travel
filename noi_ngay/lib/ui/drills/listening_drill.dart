import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/spoken_line.dart';
import '../../state/learn_state.dart';
import '../../theme/palette.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';
import 'drill_common.dart';

/// Nghe và chọn: giọng hệ thống đọc một câu, người học chọn đúng câu trong bốn.
///
/// Nếu máy chưa cài giọng tiếng Anh thì nút nghe im lặng, nên màn hình luôn có
/// sẵn nút Hiện chữ để trò chơi vẫn chơi được. Đây là lý do trò này không bao
/// giờ rơi vào trạng thái tắc.
class ListeningDrill extends StatefulWidget {
  const ListeningDrill({super.key, required this.pool});

  final List<SpokenLine> pool;

  static const int questionCount = 10;

  @override
  State<ListeningDrill> createState() => _ListeningDrillState();
}

class _ListeningDrillState extends State<ListeningDrill> {
  final Random _random = Random();
  late List<List<SpokenLine>> _rounds;
  int _index = 0;
  int _score = 0;
  String? _chosenId;
  bool _showText = false;

  @override
  void initState() {
    super.initState();
    _rounds = _build();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  List<List<SpokenLine>> _build() {
    final List<SpokenLine> targets = pickSome<SpokenLine>(
      widget.pool,
      ListeningDrill.questionCount,
      _random,
    );
    final List<List<SpokenLine>> rounds = <List<SpokenLine>>[];
    for (final SpokenLine target in targets) {
      final List<SpokenLine> others = widget.pool
          .where((SpokenLine l) => l.id != target.id)
          .toList();
      if (others.length < 3) continue;
      final List<SpokenLine> options = <SpokenLine>[
        target,
        ...pickSome<SpokenLine>(others, 3, _random),
      ]..shuffle(_random);
      // Phần tử đầu của mỗi vòng là câu đúng, phần còn lại là bốn lựa chọn.
      rounds.add(<SpokenLine>[target, ...options]);
    }
    return rounds;
  }

  void _speak() {
    if (_index >= _rounds.length) return;
    context.read<LearnState>().say(_rounds[_index].first.english);
  }

  void _answer(SpokenLine option) {
    if (_chosenId != null) return;
    final SpokenLine target = _rounds[_index].first;
    final bool correct = option.id == target.id;
    if (correct) _score += 1;
    feedBox(context, target, correct);
    setState(() {
      _chosenId = option.id;
      _showText = true;
    });
  }

  void _next() {
    if (_index + 1 >= _rounds.length) {
      context.read<LearnState>().submitScore(Drill.listening.id, _score);
    }
    setState(() {
      _index += 1;
      _chosenId = null;
      _showText = false;
    });
    _speak();
  }

  void _restart() {
    setState(() {
      _rounds = _build();
      _index = 0;
      _score = 0;
      _chosenId = null;
      _showText = false;
    });
    _speak();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (_rounds.isEmpty) {
      return const DrillShell(
        drill: Drill.listening,
        progress: 0,
        trailing: '',
        child: EmptyHint(
          icon: Icons.inbox_rounded,
          title: 'Chưa đủ câu để chơi',
          body: 'Trò này cần ít nhất bốn câu trong nhóm bạn chọn.',
        ),
      );
    }

    if (_index >= _rounds.length) {
      return DrillShell(
        drill: Drill.listening,
        progress: 1,
        trailing: '$_score/${_rounds.length}',
        child: DrillResultView(
          drill: Drill.listening,
          score: _score,
          total: _rounds.length,
          onRetry: _restart,
        ),
      );
    }

    final List<SpokenLine> round = _rounds[_index];
    final SpokenLine target = round.first;
    final List<SpokenLine> options = round.sublist(1);

    return DrillShell(
      drill: Drill.listening,
      progress: _index / _rounds.length,
      trailing: '${_index + 1}/${_rounds.length}',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: <Widget>[
          GlassCard(
            tint: Drill.listening.tint,
            padding: const EdgeInsets.all(22),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.graphic_eq_rounded,
                  size: 38,
                  color: Drill.listening.tint,
                ),
                const SizedBox(height: 14),
                Text(
                  'Nghe rồi chọn câu bạn vừa nghe',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _speak,
                        icon: const Icon(Icons.replay_rounded, size: 18),
                        label: const Text('Nghe lại'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            setState(() => _showText = !_showText),
                        icon: const Icon(Icons.subtitles_rounded, size: 18),
                        label: Text(_showText ? 'Ẩn chữ' : 'Hiện chữ'),
                      ),
                    ),
                  ],
                ),
                if (_showText) ...<Widget>[
                  const SizedBox(height: 14),
                  Text(
                    target.english,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          for (final SpokenLine option in options) ...<Widget>[
            AnswerTile(
              text: option.english,
              tint: Drill.listening.tint,
              onTap: _chosenId == null ? () => _answer(option) : null,
              state: _chosenId == null
                  ? AnswerState.idle
                  : option.id == target.id
                      ? AnswerState.correct
                      : option.id == _chosenId
                          ? AnswerState.wrong
                          : AnswerState.dimmed,
            ),
            const SizedBox(height: 10),
          ],
          if (_chosenId != null) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              target.vietnamese,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            GradientButton(
              label: _index + 1 >= _rounds.length
                  ? 'Xem kết quả'
                  : 'Câu tiếp theo',
              icon: Icons.arrow_forward_rounded,
              colors: const <Color>[Palette.mint, Palette.cyan],
              onPressed: _next,
            ),
          ],
        ],
      ),
    );
  }
}
