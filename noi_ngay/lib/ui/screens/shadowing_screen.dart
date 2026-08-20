import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/spoken_line.dart';
import '../../state/learn_state.dart';
import '../../theme/palette.dart';
import '../widgets/aurora_background.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

/// Chế độ nhại theo: nghe một câu, nói lại thành tiếng, rồi sang câu kế.
///
/// Không chấm điểm và không đụng tới hộp ôn tập. Mục đích duy nhất là để miệng
/// quen nhịp câu, nên màn hình cố tình ít nút và chữ to.
class ShadowingScreen extends StatefulWidget {
  const ShadowingScreen({super.key, required this.pool});

  final List<SpokenLine> pool;

  @override
  State<ShadowingScreen> createState() => _ShadowingScreenState();
}

class _ShadowingScreenState extends State<ShadowingScreen> {
  int _index = 0;
  bool _showVietnamese = false;
  LearnState? _state;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _state = context.read<LearnState>();
  }

  @override
  void dispose() {
    _state?.speech.stop();
    super.dispose();
  }

  void _move(int delta) {
    if (widget.pool.isEmpty) return;
    setState(() {
      _index = (_index + delta) % widget.pool.length;
      if (_index < 0) _index += widget.pool.length;
      _showVietnamese = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.watch<LearnState>();

    if (widget.pool.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nhại theo')),
        body: const EmptyHint(
          icon: Icons.inbox_rounded,
          title: 'Chưa có câu nào',
          body: 'Hãy chọn một nhóm câu khác ở tab Luyện tập.',
        ),
      );
    }

    final SpokenLine line = widget.pool[_index];

    return Scaffold(
      body: AuroraBackground(
        topTint: Palette.indigo,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 18, 8),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    Expanded(
                      child: Text('Nhại theo',
                          style: theme.textTheme.titleMedium),
                    ),
                    Text(
                      '${_index + 1}/${widget.pool.length}',
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  children: <Widget>[
                    GlassCard(
                      tint: Palette.indigo,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Nghe rồi nói lại thật to',
                              style: theme.textTheme.labelMedium),
                          const SizedBox(height: 14),
                          Text(
                            line.english,
                            style: theme.textTheme.displaySmall
                                ?.copyWith(fontSize: 27, height: 1.32),
                          ),
                          const SizedBox(height: 14),
                          if (_showVietnamese)
                            Text(line.vietnamese,
                                style: theme.textTheme.bodyMedium)
                          else
                            TextButton.icon(
                              onPressed: () =>
                                  setState(() => _showVietnamese = true),
                              icon: const Icon(Icons.translate_rounded,
                                  size: 17),
                              label: const Text('Hiện nghĩa'),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    GradientButton(
                      label: 'Nghe câu này',
                      icon: Icons.volume_up_rounded,
                      colors: const <Color>[Palette.indigo, Palette.cyan],
                      onPressed: () => state.say(line.english),
                    ),
                    const SizedBox(height: 14),
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Tốc độ đọc', style: theme.textTheme.titleMedium),
                          Slider(
                            value: state.speechRate,
                            min: 0.25,
                            max: 0.7,
                            divisions: 9,
                            label: state.speechRate < 0.38
                                ? 'Chậm'
                                : state.speechRate < 0.55
                                    ? 'Vừa'
                                    : 'Nhanh',
                            onChanged: (double value) =>
                                state.setSpeechRate(value),
                          ),
                          Text(
                            'Người mới nên để ở mức Chậm và tăng dần khi quen.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _move(-1),
                        icon: const Icon(Icons.chevron_left_rounded),
                        label: const Text('Câu trước'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _move(1),
                        icon: const Icon(Icons.chevron_right_rounded),
                        label: const Text('Câu sau'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
