import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/conversation.dart';
import '../../state/learn_state.dart';
import '../widgets/aurora_background.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

/// Hội thoại mẫu dạng bong bóng chat.
///
/// Lượt của người học nằm bên phải và tô màu chủ đề, để mắt nhận ra ngay câu
/// nào là câu mình sẽ phải nói. Nút Nghe cả đoạn đọc lần lượt từng lượt.
class ConversationScreen extends StatefulWidget {
  const ConversationScreen({
    super.key,
    required this.conversation,
    required this.tint,
  });

  final Conversation conversation;
  final Color tint;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  bool _showVietnamese = true;
  int _playingIndex = -1;

  /// Giữ sẵn tham chiếu để [dispose] không phải chạm vào context.
  LearnState? _state;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _state = context.read<LearnState>();
  }

  Future<void> _playAll() async {
    final LearnState state = context.read<LearnState>();
    for (int i = 0; i < widget.conversation.turns.length; i++) {
      if (!mounted) return;
      setState(() => _playingIndex = i);
      final ConversationTurn turn = widget.conversation.turns[i];
      state.say(turn.english);
      // Ước lượng thời gian đọc theo độ dài câu; TTS không báo lại khi xong.
      final int millis = 900 + turn.english.length * 62;
      await Future<void>.delayed(Duration(milliseconds: millis));
    }
    if (mounted) setState(() => _playingIndex = -1);
  }

  @override
  void dispose() {
    // Không để giọng đọc chạy tiếp khi người dùng đã rời màn hình.
    _state?.speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Conversation talk = widget.conversation;

    return Scaffold(
      body: AuroraBackground(
        topTint: widget.tint,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 16, 6),
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
                          Text(talk.title, style: theme.textTheme.titleLarge),
                          Text(talk.setting,
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          setState(() => _showVietnamese = !_showVietnamese),
                      icon: Icon(
                        _showVietnamese
                            ? Icons.translate_rounded
                            : Icons.translate_outlined,
                      ),
                      tooltip: _showVietnamese
                          ? 'Ẩn bản dịch'
                          : 'Hiện bản dịch',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                  itemCount: talk.turns.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (BuildContext context, int i) {
                    return _Bubble(
                      turn: talk.turns[i],
                      tint: widget.tint,
                      showVietnamese: _showVietnamese,
                      highlighted: _playingIndex == i,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: GradientButton(
                  label: _playingIndex >= 0
                      ? 'Đang đọc lượt ${_playingIndex + 1}'
                      : 'Nghe cả đoạn',
                  icon: Icons.play_circle_fill_rounded,
                  onPressed: _playingIndex >= 0 ? null : _playAll,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.turn,
    required this.tint,
    required this.showVietnamese,
    required this.highlighted,
  });

  final ConversationTurn turn;
  final Color tint;
  final bool showVietnamese;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.read<LearnState>();

    return Row(
      mainAxisAlignment:
          turn.isLearner ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.82,
          ),
          child: GlassCard(
            tint: turn.isLearner ? tint : theme.colorScheme.onSurfaceVariant,
            radius: 22,
            borderStrength: highlighted ? 3 : 1,
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            onTap: () => state.say(turn.english),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  turn.speaker,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: turn.isLearner ? tint : null,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            turn.english,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (showVietnamese) ...<Widget>[
                            const SizedBox(height: 4),
                            Text(
                              turn.vietnamese,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => state.say(turn.english),
                      icon: const Icon(Icons.volume_up_rounded, size: 19),
                      visualDensity: VisualDensity.compact,
                      color: turn.isLearner
                          ? tint
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
