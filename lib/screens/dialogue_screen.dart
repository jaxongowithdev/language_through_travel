import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dialogue.dart';
import '../state/app_state.dart';

/// Hội thoại tình huống hiển thị dạng bong bóng chat.
///
/// Nút "Đọc cả đoạn" phát tuần tự từng lượt để người học nghe nhịp hội thoại.
class DialogueScreen extends StatefulWidget {
  const DialogueScreen({super.key, required this.dialogue});

  final Dialogue dialogue;

  @override
  State<DialogueScreen> createState() => _DialogueScreenState();
}

class _DialogueScreenState extends State<DialogueScreen> {
  bool _showVietnamese = true;
  bool _playingAll = false;
  int _playingIndex = -1;

  Future<void> _playAll() async {
    if (_playingAll) {
      setState(() {
        _playingAll = false;
        _playingIndex = -1;
      });
      await context.read<AppState>().tts.stop();
      return;
    }

    setState(() => _playingAll = true);
    final AppState state = context.read<AppState>();

    for (int i = 0; i < widget.dialogue.lines.length; i++) {
      if (!mounted || !_playingAll) break;
      setState(() => _playingIndex = i);
      await state.speak(widget.dialogue.lines[i].target);
      // Khoảng nghỉ giữa hai lượt nói cho tự nhiên.
      await Future<void>.delayed(const Duration(milliseconds: 700));
    }

    if (!mounted) return;
    setState(() {
      _playingAll = false;
      _playingIndex = -1;
    });
  }

  @override
  void dispose() {
    _playingAll = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = context.watch<AppState>();
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dialogue.title),
        actions: <Widget>[
          IconButton(
            tooltip: _showVietnamese ? 'Ẩn nghĩa tiếng Việt' : 'Hiện nghĩa',
            onPressed: () =>
                setState(() => _showVietnamese = !_showVietnamese),
            icon: Icon(
              _showVietnamese
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemCount: widget.dialogue.lines.length,
              itemBuilder: (BuildContext context, int i) {
                final DialogueLine line = widget.dialogue.lines[i];
                return _Bubble(
                  line: line,
                  showVietnamese: _showVietnamese,
                  showRomanization: state.language.hasRomanization,
                  highlighted: i == _playingIndex,
                  onSpeak: () => state.speak(line.target),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                children: <Widget>[
                  Text(
                    widget.dialogue.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _playAll,
                      icon: Icon(
                        _playingAll
                            ? Icons.stop_rounded
                            : Icons.play_arrow_rounded,
                      ),
                      label: Text(_playingAll ? 'Dừng' : 'Đọc cả đoạn'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.line,
    required this.showVietnamese,
    required this.showRomanization,
    required this.highlighted,
    required this.onSpeak,
  });

  final DialogueLine line;
  final bool showVietnamese;
  final bool showRomanization;
  final bool highlighted;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool mine = line.isUser;
    final Color background = mine
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerHigh;
    final Color onBackground = mine
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment:
            mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
            child: Text(
              line.speaker,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: onSpeak,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.82,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(mine ? 18 : 4),
                  bottomRight: Radius.circular(mine ? 4 : 18),
                ),
                border: highlighted
                    ? Border.all(color: theme.colorScheme.primary, width: 2)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          line.target,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: onBackground,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.volume_up_rounded,
                        size: 16,
                        color: onBackground.withValues(alpha: 0.6),
                      ),
                    ],
                  ),
                  if (showRomanization && line.romanization.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(
                      line.romanization,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: onBackground.withValues(alpha: 0.75),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  if (showVietnamese) ...<Widget>[
                    const SizedBox(height: 6),
                    Text(
                      line.vietnamese,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: onBackground.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
