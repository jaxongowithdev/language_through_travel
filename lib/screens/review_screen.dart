import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/phrase.dart';
import '../state/app_state.dart';
import 'flashcard_screen.dart';

/// Phiên ôn tập theo lịch lặp lại ngắt quãng: chỉ các thẻ đã đến hạn.
///
/// Danh sách thẻ được chốt một lần khi mở màn hình. Nếu đọc lại `duePhrases`
/// ở mỗi lần rebuild, danh sách sẽ co lại ngay giữa phiên và chỉ số thẻ hiện
/// tại trong [FlashcardScreen] sẽ trỏ sai.
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late final List<Phrase> _session;

  @override
  void initState() {
    super.initState();
    _session = context.read<AppState>().duePhrases;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (_session.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ôn tập')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('☕', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 20),
                Text(
                  'Không có gì cần ôn',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Học thêm câu mới ở các chặng, hoặc quay lại khi thẻ tới hạn.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return FlashcardScreen(
      phrases: _session,
      title: 'Ôn tập · ${_session.length} thẻ',
    );
  }
}
