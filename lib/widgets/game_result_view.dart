import 'package:flutter/material.dart';

/// Màn hình kết quả dùng chung cho mọi trò ở tab Luyện tập.
///
/// Gom về một chỗ để bốn trò chơi có cùng bố cục, cùng cách khoe kỷ lục.
class GameResultView extends StatelessWidget {
  const GameResultView({
    super.key,
    required this.title,
    required this.score,
    required this.scoreSuffix,
    required this.detail,
    required this.best,
    required this.isRecord,
    required this.onRetry,
    this.message = '',
  });

  /// Tên trò chơi, hiển thị trên AppBar.
  final String title;

  /// Điểm của lượt vừa chơi.
  final int score;

  /// Hậu tố của điểm, ví dụ `%` hoặc ` câu`.
  final String scoreSuffix;

  /// Dòng mô tả chi tiết, ví dụ `Đúng 8/10 · 42 giây`.
  final String detail;

  /// Kỷ lục hiện tại sau lượt này.
  final int best;

  /// true nếu lượt này vừa lập kỷ lục mới.
  final bool isRecord;

  final VoidCallback onRetry;

  /// Lời nhắn thêm; nếu rỗng sẽ tự chọn theo [score].
  final String message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String emoji = isRecord
        ? '🎉'
        : score >= 80
            ? '🏆'
            : score >= 50
                ? '👏'
                : '💪';
    final String note = message.isNotEmpty
        ? message
        : score >= 80
            ? 'Quá tốt! Bạn dùng được mấy câu này ngoài đời rồi đấy.'
            : score >= 50
                ? 'Ổn rồi. Chơi thêm một lượt là chắc hơn.'
                : 'Lật flashcard vài câu rồi quay lại, sẽ khác ngay.';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(emoji, style: const TextStyle(fontSize: 56)),
              const SizedBox(height: 18),
              Text(
                '$score$scoreSuffix',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                detail,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isRecord
                      ? const Color(0xFFF59E0B).withValues(alpha: 0.18)
                      : theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isRecord
                      ? 'Kỷ lục mới! (trước đó thấp hơn)'
                      : 'Kỷ lục của bạn: $best$scoreSuffix',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                note,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Quay lại'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Chơi lại'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
