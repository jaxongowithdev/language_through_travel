import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/spoken_line.dart';
import '../../state/learn_state.dart';
import '../../theme/palette.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';
import 'drill_common.dart';

/// Sắp xếp câu: các từ bị xáo trộn, người học chạm để dựng lại câu đúng.
///
/// Chỉ lấy câu từ năm tới mười từ. Câu ngắn quá thì không có gì để sắp, câu dài
/// quá thì màn hình điện thoại không đủ chỗ và trò chơi thành ra bực mình.
class WordOrderDrill extends StatefulWidget {
  const WordOrderDrill({super.key, required this.pool});

  final List<SpokenLine> pool;

  static const int questionCount = 8;

  @override
  State<WordOrderDrill> createState() => _WordOrderDrillState();
}

class _WordOrderDrillState extends State<WordOrderDrill> {
  final Random _random = Random();
  late List<SpokenLine> _questions;
  int _index = 0;
  int _score = 0;
  List<String> _bank = <String>[];
  List<String> _built = <String>[];
  bool? _correct;

  @override
  void initState() {
    super.initState();
    _questions = _build();
    _loadCurrent();
  }

  List<SpokenLine> _build() {
    final List<SpokenLine> usable = widget.pool
        .where((SpokenLine l) => l.wordCount >= 5 && l.wordCount <= 10)
        .toList();
    return pickSome<SpokenLine>(
      usable,
      WordOrderDrill.questionCount,
      _random,
    );
  }

  void _loadCurrent() {
    if (_index >= _questions.length) return;
    final List<String> words = _questions[_index].english.split(' ');
    _bank = List<String>.of(words)..shuffle(_random);
    // Rất hiếm nhưng có thể xáo ra đúng thứ tự gốc; xáo lại cho chắc.
    if (_bank.join(' ') == words.join(' ') && words.length > 2) {
      _bank = _bank.reversed.toList();
    }
    _built = <String>[];
    _correct = null;
  }

  void _take(int bankIndex) {
    if (_correct != null) return;
    setState(() => _built.add(_bank.removeAt(bankIndex)));
    // Chấm sau khi setState kết thúc để việc ghi hộp Leitner không xảy ra ngay
    // giữa lúc widget đang đánh dấu cần dựng lại.
    if (_bank.isEmpty) _check();
  }

  void _putBack(int builtIndex) {
    if (_correct != null) return;
    setState(() => _bank.add(_built.removeAt(builtIndex)));
  }

  void _check() {
    final SpokenLine line = _questions[_index];
    final bool ok = _built.join(' ') == line.english;
    setState(() {
      _correct = ok;
      if (ok) _score += 1;
    });
    feedBox(context, line, ok);
  }

  void _next() {
    if (_index + 1 >= _questions.length) {
      context.read<LearnState>().submitScore(Drill.wordOrder.id, _score);
    }
    setState(() {
      _index += 1;
      _loadCurrent();
    });
  }

  void _restart() {
    setState(() {
      _questions = _build();
      _index = 0;
      _score = 0;
      _loadCurrent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (_questions.isEmpty) {
      return const DrillShell(
        drill: Drill.wordOrder,
        progress: 0,
        trailing: '',
        child: EmptyHint(
          icon: Icons.inbox_rounded,
          title: 'Chưa đủ câu để chơi',
          body: 'Trò này cần câu từ năm tới mười từ. Hãy chọn nhóm rộng hơn.',
        ),
      );
    }

    if (_index >= _questions.length) {
      return DrillShell(
        drill: Drill.wordOrder,
        progress: 1,
        trailing: '$_score/${_questions.length}',
        child: DrillResultView(
          drill: Drill.wordOrder,
          score: _score,
          total: _questions.length,
          onRetry: _restart,
        ),
      );
    }

    final SpokenLine line = _questions[_index];
    final LearnState state = context.read<LearnState>();

    return DrillShell(
      drill: Drill.wordOrder,
      progress: _index / _questions.length,
      trailing: '${_index + 1}/${_questions.length}',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: <Widget>[
          GlassCard(
            tint: Drill.wordOrder.tint,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Dựng lại câu tiếng Anh cho nghĩa này',
                    style: theme.textTheme.labelMedium),
                const SizedBox(height: 10),
                Text(
                  line.vietnamese,
                  style: theme.textTheme.titleLarge?.copyWith(height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 88),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (_correct == null
                      ? Drill.wordOrder.tint
                      : _correct!
                          ? Palette.mint
                          : Palette.rose)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (_correct == null
                        ? Drill.wordOrder.tint
                        : _correct!
                            ? Palette.mint
                            : Palette.rose)
                    .withValues(alpha: 0.4),
              ),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                if (_built.isEmpty)
                  Text(
                    'Chạm vào các từ bên dưới để xếp câu.',
                    style: theme.textTheme.bodySmall,
                  ),
                for (int i = 0; i < _built.length; i++)
                  _WordChip(
                    label: _built[i],
                    tint: Drill.wordOrder.tint,
                    filled: true,
                    onTap: () => _putBack(i),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (int i = 0; i < _bank.length; i++)
                _WordChip(
                  label: _bank[i],
                  tint: Drill.wordOrder.tint,
                  onTap: () => _take(i),
                ),
            ],
          ),
          if (_correct != null) ...<Widget>[
            const SizedBox(height: 20),
            GlassCard(
              tint: _correct! ? Palette.mint : Palette.rose,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _correct! ? 'Chính xác' : 'Câu đúng là',
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(line.english, style: theme.textTheme.bodyLarge),
                  if (line.tip.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 8),
                    Text(line.tip, style: theme.textTheme.bodySmall),
                  ],
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => state.say(line.english),
                    icon: const Icon(Icons.volume_up_rounded, size: 18),
                    label: const Text('Nghe câu đúng'),
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
              colors: const <Color>[Palette.cyan, Palette.indigo],
              onPressed: _next,
            ),
          ],
        ],
      ),
    );
  }
}

class _WordChip extends StatelessWidget {
  const _WordChip({
    required this.label,
    required this.tint,
    required this.onTap,
    this.filled = false,
  });

  final String label;
  final Color tint;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: filled
          ? tint.withValues(alpha: 0.26)
          : tint.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
