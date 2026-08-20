import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/spoken_line.dart';
import '../../models/topic.dart';
import '../../state/learn_state.dart';
import '../../theme/palette.dart';
import '../drills/drill_common.dart';
import '../drills/fill_blank_drill.dart';
import '../drills/listening_drill.dart';
import '../drills/speed_match_drill.dart';
import '../drills/word_order_drill.dart';
import '../screens/review_screen.dart';
import '../screens/shadowing_screen.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

/// Tab Luyện tập: phiên ôn theo lịch, bốn trò chơi và chế độ nhại theo.
///
/// Người dùng chọn nhóm câu một lần ở đầu tab rồi mọi trò bên dưới đều dùng
/// nhóm đó, nên không phải chọn lại ở từng trò.
class DrillTab extends StatefulWidget {
  const DrillTab({super.key});

  @override
  State<DrillTab> createState() => _DrillTabState();
}

class _DrillTabState extends State<DrillTab> {
  /// null nghĩa là lấy câu từ mọi chủ đề.
  String? _topicCode;

  List<SpokenLine> _pool(LearnState state) {
    if (_topicCode == null) return state.library.allLines;
    return state.library.topic(_topicCode!).lines;
  }

  void _open(Widget screen) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }

  /// Bảng chọn nhóm câu. Dùng bảng trượt thay cho ô thả xuống vì hai mươi mốt
  /// lựa chọn trong một ô thả xuống rất khó chạm trên màn hình điện thoại.
  Future<void> _pickPool(LearnState state) async {
    final String? picked = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.all_inclusive_rounded),
                title: const Text('Tất cả chủ đề'),
                subtitle: Text('${state.library.lineCount} câu'),
                selected: _topicCode == null,
                onTap: () => Navigator.of(sheetContext).pop<String?>(''),
              ),
              const Divider(),
              for (final Topic topic in state.library.topics)
                ListTile(
                  leading: Icon(topic.icon, color: topic.tint),
                  title: Text(topic.title),
                  subtitle: Text('${topic.lineCount} câu'),
                  selected: _topicCode == topic.code,
                  onTap: () =>
                      Navigator.of(sheetContext).pop<String?>(topic.code),
                ),
            ],
          ),
        );
      },
    );
    if (!mounted || picked == null) return; // null nghĩa là vuốt đóng.
    setState(() => _topicCode = picked.isEmpty ? null : picked);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.watch<LearnState>();
    final List<SpokenLine> pool = _pool(state);

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: <Widget>[
          Text('Luyện tập', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 14),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Nhóm câu dùng cho các trò',
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => _pickPool(state),
                  icon: const Icon(Icons.tune_rounded, size: 18),
                  label: Text(
                    _topicCode == null
                        ? 'Tất cả chủ đề'
                        : state.library.topic(_topicCode!).title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Đang dùng ${pool.length} câu. Kết quả các trò cũng đẩy câu '
                  'lên hoặc xuống hộp ôn tập.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _ReviewCard(dueCount: state.dueCount),
          const SizedBox(height: 18),
          const SectionHeader(
            title: 'Bốn trò luyện',
            subtitle: 'Mỗi trò rèn một kỹ năng khác nhau',
          ),
          _DrillCard(
            drill: Drill.fillBlank,
            best: state.bestScore(Drill.fillBlank.id),
            onTap: () => _open(FillBlankDrill(pool: pool)),
          ),
          const SizedBox(height: 12),
          _DrillCard(
            drill: Drill.wordOrder,
            best: state.bestScore(Drill.wordOrder.id),
            onTap: () => _open(WordOrderDrill(pool: pool)),
          ),
          const SizedBox(height: 12),
          _DrillCard(
            drill: Drill.listening,
            best: state.bestScore(Drill.listening.id),
            onTap: () => _open(ListeningDrill(pool: pool)),
          ),
          const SizedBox(height: 12),
          _DrillCard(
            drill: Drill.speedMatch,
            best: state.bestScore(Drill.speedMatch.id),
            onTap: () => _open(SpeedMatchDrill(pool: pool)),
          ),
          const SizedBox(height: 18),
          const SectionHeader(
            title: 'Nhại theo',
            subtitle: 'Nghe từng câu rồi lặp lại thành tiếng',
          ),
          GlassCard(
            tint: Palette.indigo,
            onTap: () => _open(ShadowingScreen(pool: pool)),
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: Palette.indigo.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.record_voice_over_rounded,
                      color: Palette.indigo),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Chế độ nhại theo',
                          style: theme.textTheme.titleMedium),
                      const SizedBox(height: 3),
                      Text(
                        'App đọc chậm, bạn nói theo. Không chấm điểm, chỉ để '
                        'miệng quen với nhịp câu.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.dueCount});

  final int dueCount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool hasDue = dueCount > 0;

    return GlassCard(
      tint: hasDue ? Palette.rose : Palette.mint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                hasDue ? Icons.replay_rounded : Icons.check_circle_rounded,
                color: hasDue ? Palette.rose : Palette.mint,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hasDue
                      ? '$dueCount câu đến hạn ôn'
                      : 'Không còn câu nào đến hạn',
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            hasDue
                ? 'Phiên ôn lấy tối đa hai mươi câu, ưu tiên câu ở hộp thấp.'
                : 'Học thêm câu mới trong tab Chủ đề, hoặc chơi một trò bên '
                    'dưới để câu quay lại lịch ôn.',
            style: theme.textTheme.bodySmall,
          ),
          if (hasDue) ...<Widget>[
            const SizedBox(height: 14),
            GradientButton(
              label: 'Bắt đầu phiên ôn',
              icon: Icons.play_arrow_rounded,
              colors: const <Color>[Palette.rose, Palette.amber],
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute<void>(builder: (_) => const ReviewScreen()),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DrillCard extends StatelessWidget {
  const _DrillCard({
    required this.drill,
    required this.best,
    required this.onTap,
  });

  final Drill drill;
  final int best;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      tint: drill.tint,
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: drill.tint.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(drill.icon, color: drill.tint),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(drill.title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(drill.blurb, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Pill(
            label: 'KL $best',
            icon: Icons.military_tech_rounded,
            tint: drill.tint,
          ),
        ],
      ),
    );
  }
}
