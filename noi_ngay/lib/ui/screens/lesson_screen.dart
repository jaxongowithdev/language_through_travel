import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/box_card.dart';
import '../../models/lesson.dart';
import '../../models/spoken_line.dart';
import '../../state/learn_state.dart';
import '../../theme/palette.dart';
import '../widgets/aurora_background.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

/// Màn hình học một bài.
///
/// Nhịp học cố tình đi ngược chiều dịch: người học thấy câu tiếng Việt trước và
/// phải tự bật ra câu tiếng Anh, rồi mới lật đáp án. Đây là điểm khác biệt lớn
/// nhất so với kiểu đọc danh sách câu — nói được mới tính là biết.
class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required Lesson lesson, required this.tint})
      : _lesson = lesson,
        _title = null,
        _lines = null;

  /// Dựng một phiên học từ danh sách câu bất kỳ, ví dụ nút Học câu mới.
  const LessonScreen.fromLines({
    super.key,
    required String title,
    required List<SpokenLine> lines,
    required this.tint,
  })  : _lesson = null,
        _title = title,
        _lines = lines;

  final Lesson? _lesson;
  final String? _title;
  final List<SpokenLine>? _lines;
  final Color tint;

  String get title => _lesson?.title ?? _title ?? 'Học câu mới';
  List<SpokenLine> get lines => _lesson?.lines ?? _lines ?? const <SpokenLine>[];
  String? get lessonId => _lesson?.id;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _index = 0;
  bool _revealed = false;
  final Map<int, Recall> _results = <int, Recall>{};

  bool get _finished => _index >= widget.lines.length;

  void _grade(Recall recall) {
    final SpokenLine line = widget.lines[_index];
    context.read<LearnState>().grade(line.id, recall);
    setState(() {
      _results[_index] = recall;
      _index += 1;
      _revealed = false;
    });
    if (_index >= widget.lines.length) {
      final String? id = widget.lessonId;
      if (id != null) context.read<LearnState>().markLessonDone(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<SpokenLine> lines = widget.lines;

    return Scaffold(
      body: AuroraBackground(
        topTint: widget.tint,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _Header(
                title: widget.title,
                index: _index,
                total: lines.length,
                tint: widget.tint,
              ),
              Expanded(
                child: lines.isEmpty
                    ? const EmptyHint(
                        icon: Icons.inbox_rounded,
                        title: 'Chưa có câu nào ở đây',
                        body: 'Hãy chọn một chủ đề khác trong tab Chủ đề.',
                      )
                    : _finished
                        ? _Summary(
                            results: _results,
                            lines: lines,
                            tint: widget.tint,
                          )
                        : _Card(
                            line: lines[_index],
                            revealed: _revealed,
                            tint: widget.tint,
                            onReveal: () => setState(() => _revealed = true),
                            onGrade: _grade,
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.index,
    required this.total,
    required this.tint,
  });

  final String title;
  final int index;
  final int total;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 4, 18, 10),
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
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                ProgressBar(
                  value: total == 0 ? 0 : index / total,
                  tint: tint,
                  height: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${index.clamp(0, total)}/$total',
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.line,
    required this.revealed,
    required this.tint,
    required this.onReveal,
    required this.onGrade,
  });

  final SpokenLine line;
  final bool revealed;
  final Color tint;
  final VoidCallback onReveal;
  final ValueChanged<Recall> onGrade;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.read<LearnState>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: <Widget>[
        GlassCard(
          tint: tint,
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Bạn sẽ nói câu này thế nào?',
                  style: theme.textTheme.labelMedium),
              const SizedBox(height: 12),
              Text(
                line.vietnamese,
                style: theme.textTheme.headlineSmall?.copyWith(height: 1.35),
              ),
              const SizedBox(height: 22),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 220),
                crossFadeState: revealed
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onReveal,
                    icon: const Icon(Icons.visibility_rounded, size: 18),
                    label: const Text('Xem đáp án'),
                  ),
                ),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: tint.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            line.english,
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(height: 1.35),
                          ),
                          if (line.tip.isNotEmpty) ...<Widget>[
                            const SizedBox(height: 10),
                            Text(line.tip, style: theme.textTheme.bodySmall),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => state.say(line.english),
                            icon: const Icon(Icons.volume_up_rounded, size: 18),
                            label: const Text('Nghe lại'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton.outlined(
                          onPressed: () => state.toggleSaved(line.id),
                          icon: Icon(
                            state.isSaved(line.id)
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                          ),
                          tooltip: 'Lưu câu này',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (revealed) ...<Widget>[
          Text(
            'Bạn nhớ câu này tới đâu?',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium,
          ),
          const SizedBox(height: 12),
          for (final Recall recall in Recall.values) ...<Widget>[
            _GradeButton(recall: recall, onTap: () => onGrade(recall)),
            const SizedBox(height: 10),
          ],
        ] else
          Text(
            'Thử nói to trước khi lật đáp án. Nói ra miệng khác hẳn với nghĩ '
            'trong đầu.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
      ],
    );
  }
}

class _GradeButton extends StatelessWidget {
  const _GradeButton({required this.recall, required this.onTap});

  final Recall recall;
  final VoidCallback onTap;

  static const Map<Recall, Color> _tints = <Recall, Color>{
    Recall.missed: Palette.rose,
    Recall.shaky: Palette.amber,
    Recall.solid: Palette.mint,
  };

  static const Map<Recall, IconData> _icons = <Recall, IconData>{
    Recall.missed: Icons.close_rounded,
    Recall.shaky: Icons.help_outline_rounded,
    Recall.solid: Icons.check_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color tint = _tints[recall] ?? Palette.violet;
    return GlassCard(
      tint: tint,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(_icons[recall], size: 18, color: tint),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(recall.label, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(recall.effect, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.results,
    required this.lines,
    required this.tint,
  });

  final Map<int, Recall> results;
  final List<SpokenLine> lines;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int solid =
        results.values.where((Recall r) => r == Recall.solid).length;
    final int shaky =
        results.values.where((Recall r) => r == Recall.shaky).length;
    final int missed =
        results.values.where((Recall r) => r == Recall.missed).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: <Widget>[
        GlassCard(
          tint: tint,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              Icon(Icons.celebration_rounded, size: 40, color: tint),
              const SizedBox(height: 14),
              Text('Xong phiên học', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 6),
              Text(
                'Bạn vừa đi qua ${lines.length} câu. Những câu chưa chắc sẽ '
                'quay lại sớm trong tab Luyện tập.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  StatChip(
                    icon: Icons.check_rounded,
                    value: '$solid',
                    label: 'Nhớ rõ',
                    tint: Palette.mint,
                  ),
                  StatChip(
                    icon: Icons.help_outline_rounded,
                    value: '$shaky',
                    label: 'Lơ mơ',
                    tint: Palette.amber,
                  ),
                  StatChip(
                    icon: Icons.close_rounded,
                    value: '$missed',
                    label: 'Chưa nhớ',
                    tint: Palette.rose,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        GradientButton(
          label: 'Quay lại chủ đề',
          icon: Icons.arrow_back_rounded,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ],
    );
  }
}
