import 'package:flutter/material.dart';

import '../models/language.dart';
import '../models/phrase.dart';

/// Hiển thị một câu/từ kèm nút phát âm.
class PhraseTile extends StatelessWidget {
  const PhraseTile({
    super.key,
    required this.phrase,
    required this.language,
    required this.onSpeak,
    this.learned = false,
  });

  final Phrase phrase;
  final LearningLanguage language;
  final VoidCallback onSpeak;
  final bool learned;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool showRomanization =
        language.hasRomanization && phrase.romanization.isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      if (learned)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          phrase.target,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (showRomanization) ...<Widget>[
                    const SizedBox(height: 3),
                    Text(
                      phrase.romanization,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    phrase.vietnamese,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (phrase.note.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('💡 ', style: TextStyle(fontSize: 12)),
                          Expanded(
                            child: Text(
                              phrase.note,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: onSpeak,
              icon: const Icon(Icons.volume_up_rounded),
              tooltip: 'Nghe phát âm',
            ),
          ],
        ),
      ),
    );
  }
}
