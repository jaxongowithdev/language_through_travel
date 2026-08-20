import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/spoken_line.dart';
import '../../state/learn_state.dart';
import '../../theme/palette.dart';
import '../widgets/aurora_background.dart';
import '../widgets/common.dart';
import '../widgets/line_tile.dart';
import 'lesson_screen.dart';

/// Sổ riêng: những câu người dùng tự đánh dấu.
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.watch<LearnState>();
    final List<SpokenLine> lines = state.savedLines;

    return Scaffold(
      body: AuroraBackground(
        topTint: Palette.fuchsia,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Câu đã lưu',
                              style: theme.textTheme.titleLarge),
                          Text('${lines.length} câu',
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: lines.isEmpty
                    ? const EmptyHint(
                        icon: Icons.bookmark_border_rounded,
                        title: 'Chưa lưu câu nào',
                        body: 'Chạm biểu tượng dấu trang ở bất kỳ câu nào để '
                            'cất vào đây.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: lines.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (BuildContext context, int i) => LineTile(
                          line: lines[i],
                          tint: state.library
                              .topic(lines[i].topicCode)
                              .tint,
                        ),
                      ),
              ),
              if (lines.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: GradientButton(
                    label: 'Học lại ${lines.length} câu này',
                    icon: Icons.play_arrow_rounded,
                    colors: const <Color>[Palette.fuchsia, Palette.violet],
                    onPressed: () => Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) => LessonScreen.fromLines(
                          title: 'Câu đã lưu',
                          lines: lines,
                          tint: Palette.fuchsia,
                        ),
                      ),
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
