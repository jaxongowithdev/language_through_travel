import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/spoken_line.dart';
import '../../state/learn_state.dart';
import '../../theme/palette.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';
import 'drill_common.dart';

/// Ghép nghĩa trong sáu mươi giây.
///
/// Câu tiếng Việt hiện lên, người học chọn bản tiếng Anh đúng trong ba lựa
/// chọn. Trả lời đúng cộng một điểm và sang câu mới ngay, trả lời sai trừ nửa
/// giây suy nghĩ vì màn hình dừng lại một nhịp để hiện đáp án.
class SpeedMatchDrill extends StatefulWidget {
  const SpeedMatchDrill({super.key, required this.pool});

  final List<SpokenLine> pool;

  static const int seconds = 60;

  @override
  State<SpeedMatchDrill> createState() => _SpeedMatchDrillState();
}

class _SpeedMatchDrillState extends State<SpeedMatchDrill> {
  final Random _random = Random();
  Timer? _timer;
  int _left = SpeedMatchDrill.seconds;
  int _score = 0;
  int _asked = 0;
  bool _running = false;
  List<SpokenLine> _options = <SpokenLine>[];
  SpokenLine? _target;
  String? _chosenId;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    setState(() {
      _left = SpeedMatchDrill.seconds;
      _score = 0;
      _asked = 0;
      _running = true;
      _chosenId = null;
    });
    _nextQuestion();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _left -= 1);
      if (_left <= 0) _finish();
    });
  }

  void _finish() {
    _timer?.cancel();
    setState(() => _running = false);
    context.read<LearnState>().submitScore(Drill.speedMatch.id, _score);
  }

  void _nextQuestion() {
    if (widget.pool.length < 4) return;
    final SpokenLine target =
        widget.pool[_random.nextInt(widget.pool.length)];
    final List<SpokenLine> others =
        widget.pool.where((SpokenLine l) => l.id != target.id).toList();
    setState(() {
      _target = target;
      _options = <SpokenLine>[
        target,
        ...pickSome<SpokenLine>(others, 2, _random),
      ]..shuffle(_random);
      _chosenId = null;
      _asked += 1;
    });
  }

  Future<void> _answer(SpokenLine option) async {
    final SpokenLine? target = _target;
    if (target == null || _chosenId != null || !_running) return;
    final bool correct = option.id == target.id;
    if (correct) _score += 1;
    feedBox(context, target, correct);
    setState(() => _chosenId = option.id);
    await Future<void>.delayed(
      Duration(milliseconds: correct ? 260 : 900),
    );
    if (!mounted || !_running) return;
    _nextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (widget.pool.length < 4) {
      return const DrillShell(
        drill: Drill.speedMatch,
        progress: 0,
        trailing: '',
        child: EmptyHint(
          icon: Icons.inbox_rounded,
          title: 'Chưa đủ câu để chơi',
          body: 'Trò này cần ít nhất bốn câu trong nhóm bạn chọn.',
        ),
      );
    }

    if (!_running && _asked == 0) {
      return DrillShell(
        drill: Drill.speedMatch,
        progress: 0,
        trailing: '60 giây',
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          children: <Widget>[
            GlassCard(
              tint: Drill.speedMatch.tint,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.timer_rounded,
                    size: 40,
                    color: Drill.speedMatch.tint,
                  ),
                  const SizedBox(height: 14),
                  Text('Ghép nghĩa 60 giây',
                      style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    'Câu tiếng Việt hiện lên, bạn chọn bản tiếng Anh đúng. '
                    'Trả lời càng nhanh càng ghép được nhiều câu.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Kỷ lục hiện tại: '
                    '${context.watch<LearnState>().bestScore(Drill.speedMatch.id)}',
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GradientButton(
              label: 'Bắt đầu',
              icon: Icons.play_arrow_rounded,
              colors: const <Color>[Palette.amber, Palette.rose],
              onPressed: _start,
            ),
          ],
        ),
      );
    }

    if (!_running) {
      return DrillShell(
        drill: Drill.speedMatch,
        progress: 1,
        trailing: 'Hết giờ',
        child: DrillResultView(
          drill: Drill.speedMatch,
          score: _score,
          total: _asked > 0 ? _asked - 1 : 0,
          onRetry: _start,
        ),
      );
    }

    final SpokenLine? target = _target;
    if (target == null) {
      return const DrillShell(
        drill: Drill.speedMatch,
        progress: 0,
        trailing: '',
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return DrillShell(
      drill: Drill.speedMatch,
      progress: 1 - _left / SpeedMatchDrill.seconds,
      trailing: '$_left giây · $_score điểm',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: <Widget>[
          GlassCard(
            tint: Drill.speedMatch.tint,
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Câu này nói tiếng Anh thế nào?',
                    style: theme.textTheme.labelMedium),
                const SizedBox(height: 10),
                Text(
                  target.vietnamese,
                  style: theme.textTheme.headlineSmall?.copyWith(height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          for (final SpokenLine option in _options) ...<Widget>[
            AnswerTile(
              text: option.english,
              tint: Drill.speedMatch.tint,
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
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _finish,
            icon: const Icon(Icons.stop_rounded, size: 18),
            label: const Text('Dừng sớm'),
          ),
        ],
      ),
    );
  }
}
