import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/phrase.dart';
import '../models/srs_card.dart';
import '../state/app_state.dart';

/// Lật thẻ: mặt trước là tiếng Việt, mặt sau là ngôn ngữ đích.
///
/// Sau khi lật, người học tự chấm mức nhớ — kết quả đi thẳng vào lịch SRS.
class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({
    super.key,
    required this.phrases,
    required this.title,
  });

  final List<Phrase> phrases;
  final String title;

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int _index = 0;
  bool _revealed = false;
  int _done = 0;

  Phrase get _current => widget.phrases[_index];

  Future<void> _grade(RecallQuality quality) async {
    await context.read<AppState>().reviewPhrase(_current.id, quality);
    if (!mounted) return;
    setState(() {
      _done += 1;
      _revealed = false;
      if (_index < widget.phrases.length - 1) {
        _index += 1;
      } else {
        _index = -1; // Báo hiệu đã xong toàn bộ chồng thẻ.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = context.watch<AppState>();
    final ThemeData theme = Theme.of(context);

    if (widget.phrases.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(child: Text('Chưa có nội dung cho phần này.')),
      );
    }

    if (_index < 0) {
      return _CompletionView(title: widget.title, count: _done);
    }

    final bool showRomanization = state.language.hasRomanization &&
        _current.romanization.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_index + 1) / widget.phrases.length,
            minHeight: 4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          children: <Widget>[
            Text(
              'Thẻ ${_index + 1}/${widget.phrases.length}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _revealed = !_revealed),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Card(
                    key: ValueKey<bool>(_revealed),
                    color: _revealed
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHigh,
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            if (!_revealed) ...<Widget>[
                              Text(
                                _current.vietnamese,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 28),
                              Text(
                                'Chạm để xem đáp án',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ] else ...<Widget>[
                              Text(
                                _current.target,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  height: 1.35,
                                ),
                              ),
                              if (showRomanization) ...<Widget>[
                                const SizedBox(height: 10),
                                Text(
                                  _current.romanization,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              Text(
                                _current.vietnamese,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 20),
                              FilledButton.tonalIcon(
                                onPressed: () => state.speak(_current.target),
                                icon: const Icon(Icons.volume_up_rounded),
                                label: const Text('Nghe'),
                              ),
                              if (_current.note.isNotEmpty) ...<Widget>[
                                const SizedBox(height: 20),
                                Text(
                                  '💡 ${_current.note}',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_revealed)
              Row(
                children: <Widget>[
                  for (final RecallQuality q in RecallQuality.values)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: OutlinedButton(
                          onPressed: () => _grade(q),
                          style: OutlinedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            foregroundColor: _qualityColor(q),
                            side: BorderSide(color: _qualityColor(q)),
                          ),
                          child: Text(
                            q.label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => setState(() => _revealed = true),
                  child: const Text('Xem đáp án'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Color _qualityColor(RecallQuality q) {
    switch (q) {
      case RecallQuality.again:
        return const Color(0xFFEF4444);
      case RecallQuality.hard:
        return const Color(0xFFF59E0B);
      case RecallQuality.good:
        return const Color(0xFF3B82F6);
      case RecallQuality.easy:
        return const Color(0xFF10B981);
    }
  }
}

class _CompletionView extends StatelessWidget {
  const _CompletionView({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('🎉', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 20),
              Text(
                'Xong $count thẻ!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Những thẻ này sẽ quay lại đúng lúc bạn sắp quên.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Quay lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
