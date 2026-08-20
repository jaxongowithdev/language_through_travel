import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/box_card.dart';
import '../../models/spoken_line.dart';
import '../../state/learn_state.dart';
import 'glass_card.dart';

/// Ô hiển thị một câu: tiếng Anh, nghĩa, mẹo, nút loa và nút lưu.
///
/// Dùng lại ở màn hình bài học, danh sách tìm kiếm và mục Đã lưu, nên mọi thay
/// đổi về cách trình bày câu chỉ cần sửa ở đây.
class LineTile extends StatelessWidget {
  const LineTile({
    super.key,
    required this.line,
    required this.tint,
    this.showTip = true,
    this.trailing,
    this.onTap,
  });

  final SpokenLine line;
  final Color tint;
  final bool showTip;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.watch<LearnState>();
    final bool saved = state.isSaved(line.id);
    final BoxCard? box = state.peekBox(line.id);

    return GlassCard(
      tint: tint,
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  line.english,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(line.vietnamese, style: theme.textTheme.bodyMedium),
                if (showTip && line.tip.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.lightbulb_rounded,
                        size: 14,
                        color: tint,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          line.tip,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
                if (box != null && box.seen > 0) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    'Hộp ${box.box} trên ${BoxCard.topBox}',
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ],
            ),
          ),
          Column(
            children: <Widget>[
              IconButton(
                onPressed: () => state.say(line.english),
                icon: const Icon(Icons.volume_up_rounded),
                color: tint,
                tooltip: 'Nghe câu này',
              ),
              IconButton(
                onPressed: () => state.toggleSaved(line.id),
                icon: Icon(
                  saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                ),
                color: saved ? tint : theme.colorScheme.onSurfaceVariant,
                tooltip: saved ? 'Bỏ lưu' : 'Lưu câu này',
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ],
      ),
    );
  }
}
