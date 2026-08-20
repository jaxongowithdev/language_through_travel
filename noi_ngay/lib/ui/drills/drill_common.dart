import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/box_card.dart';
import '../../models/spoken_line.dart';
import '../../state/learn_state.dart';
import '../../theme/palette.dart';
import '../widgets/aurora_background.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

/// Bốn dạng luyện tập của app, khai báo ở một chỗ để tab Luyện tập và màn hình
/// kết quả dùng chung.
enum Drill {
  fillBlank(
    'fill_blank',
    'Điền từ còn thiếu',
    'Chọn từ đúng cho chỗ trống trong câu',
    Icons.short_text_rounded,
    Palette.violet,
  ),
  wordOrder(
    'word_order',
    'Sắp xếp câu',
    'Ghép các từ rời thành câu hoàn chỉnh',
    Icons.reorder_rounded,
    Palette.cyan,
  ),
  listening(
    'listening',
    'Nghe và chọn',
    'Nghe giọng đọc rồi chọn đúng câu',
    Icons.hearing_rounded,
    Palette.mint,
  ),
  speedMatch(
    'speed_match',
    'Ghép nghĩa 60 giây',
    'Càng nhanh càng nhiều điểm',
    Icons.timer_rounded,
    Palette.amber,
  );

  const Drill(this.id, this.title, this.blurb, this.icon, this.tint);

  final String id;
  final String title;
  final String blurb;
  final IconData icon;
  final Color tint;
}

/// Chọn ngẫu nhiên [count] phần tử khác nhau từ [pool].
List<T> pickSome<T>(List<T> pool, int count, Random random) {
  if (pool.length <= count) {
    final List<T> copy = List<T>.of(pool);
    copy.shuffle(random);
    return copy;
  }
  final List<T> copy = List<T>.of(pool);
  copy.shuffle(random);
  return copy.sublist(0, count);
}

/// Khung chung cho mọi dạng luyện tập: thanh tiến độ, điểm, nút thoát.
class DrillShell extends StatelessWidget {
  const DrillShell({
    super.key,
    required this.drill,
    required this.progress,
    required this.trailing,
    required this.child,
  });

  final Drill drill;
  final double progress;
  final String trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: AuroraBackground(
        topTint: drill.tint,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 18, 8),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(drill.title,
                              style: theme.textTheme.titleMedium),
                          const SizedBox(height: 6),
                          ProgressBar(
                            value: progress,
                            tint: drill.tint,
                            height: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(trailing, style: theme.textTheme.labelMedium),
                  ],
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

/// Màn hình kết quả dùng chung cho cả bốn dạng luyện tập.
class DrillResultView extends StatelessWidget {
  const DrillResultView({
    super.key,
    required this.drill,
    required this.score,
    required this.total,
    required this.onRetry,
  });

  final Drill drill;
  final int score;
  final int total;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.watch<LearnState>();
    final int best = state.bestScore(drill.id);
    final bool isRecord = score >= best && score > 0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: <Widget>[
        GlassCard(
          tint: drill.tint,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              Icon(
                isRecord
                    ? Icons.emoji_events_rounded
                    : Icons.check_circle_rounded,
                size: 42,
                color: drill.tint,
              ),
              const SizedBox(height: 14),
              Text(
                isRecord ? 'Kỷ lục mới' : 'Hoàn thành',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Bạn đúng $score trên $total câu.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  StatChip(
                    icon: Icons.check_rounded,
                    value: '$score',
                    label: 'Điểm lần này',
                    tint: drill.tint,
                  ),
                  StatChip(
                    icon: Icons.military_tech_rounded,
                    value: '$best',
                    label: 'Kỷ lục',
                    tint: Palette.amber,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        GradientButton(
          label: 'Chơi lại',
          icon: Icons.refresh_rounded,
          colors: <Color>[drill.tint, Palette.fuchsia],
          onPressed: onRetry,
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded, size: 18),
          label: const Text('Về trang luyện tập'),
        ),
      ],
    );
  }
}

/// Nút đáp án dùng chung, tự đổi màu khi đã chấm.
class AnswerTile extends StatelessWidget {
  const AnswerTile({
    super.key,
    required this.text,
    required this.tint,
    required this.onTap,
    this.state = AnswerState.idle,
  });

  final String text;
  final Color tint;
  final VoidCallback? onTap;
  final AnswerState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color paint = switch (state) {
      AnswerState.idle => tint,
      AnswerState.correct => Palette.mint,
      AnswerState.wrong => Palette.rose,
      AnswerState.dimmed => theme.colorScheme.onSurfaceVariant,
    };

    return Opacity(
      opacity: state == AnswerState.dimmed ? 0.55 : 1,
      child: GlassCard(
        tint: paint,
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        borderStrength: state == AnswerState.idle ? 1 : 2.4,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (state == AnswerState.correct)
              const Icon(Icons.check_rounded, color: Palette.mint, size: 20),
            if (state == AnswerState.wrong)
              const Icon(Icons.close_rounded, color: Palette.rose, size: 20),
          ],
        ),
      ),
    );
  }
}

enum AnswerState { idle, correct, wrong, dimmed }

/// Ghi kết quả một câu vào hộp Leitner.
///
/// Trò chơi cũng nuôi lịch ôn: trả lời đúng đẩy câu lên hộp cao hơn, trả lời
/// sai đưa câu về hộp một để hôm nay gặp lại.
void feedBox(BuildContext context, SpokenLine line, bool correct) {
  context.read<LearnState>().grade(
        line.id,
        correct ? Recall.solid : Recall.missed,
      );
}
