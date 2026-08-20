import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/reference.dart';
import '../../state/learn_state.dart';
import '../widgets/aurora_background.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

/// Một mục sổ tay: danh sách có ô lọc nhanh ngay trên đầu.
class ReferenceScreen extends StatefulWidget {
  const ReferenceScreen({super.key, required this.section});

  final RefSection section;

  @override
  State<ReferenceScreen> createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final RefSection section = widget.section;
    final String q = _query.trim().toLowerCase();
    final List<RefEntry> entries = q.isEmpty
        ? section.entries
        : section.entries
            .where((RefEntry e) =>
                e.headword.toLowerCase().contains(q) ||
                e.meaning.toLowerCase().contains(q) ||
                e.formula.toLowerCase().contains(q) ||
                e.explain.toLowerCase().contains(q))
            .toList();

    return Scaffold(
      body: AuroraBackground(
        topTint: section.tint,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 18, 4),
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
                          Text(section.title,
                              style: theme.textTheme.titleLarge),
                          Text(
                            '${entries.length} trên ${section.entryCount} mục',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: TextField(
                  onChanged: (String value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Lọc trong ${section.title.toLowerCase()}',
                    prefixIcon: const Icon(Icons.search_rounded),
                  ),
                ),
              ),
              Expanded(
                child: entries.isEmpty
                    ? const EmptyHint(
                        icon: Icons.search_off_rounded,
                        title: 'Không có mục nào khớp',
                        body: 'Thử một từ khoá ngắn hơn xem sao.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: entries.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (BuildContext context, int i) =>
                            RefEntryCard(
                          entry: entries[i],
                          tint: section.tint,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Thẻ hiển thị một mục tra cứu, dùng chung với màn hình tìm kiếm.
class RefEntryCard extends StatelessWidget {
  const RefEntryCard({super.key, required this.entry, required this.tint});

  final RefEntry entry;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.read<LearnState>();

    return GlassCard(
      tint: tint,
      padding: const EdgeInsets.fromLTRB(18, 16, 10, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(entry.headword, style: theme.textTheme.titleMedium),
                if (entry.formula.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    entry.formula,
                    style: theme.textTheme.bodySmall?.copyWith(color: tint),
                  ),
                ],
                if (entry.meaning.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 6),
                  Text(entry.meaning, style: theme.textTheme.bodyMedium),
                ],
                if (entry.explain.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(entry.explain, style: theme.textTheme.bodySmall),
                ],
                for (final RefExample example in entry.examples) ...<Widget>[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: tint.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          example.english,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(example.vietnamese,
                            style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () => state.say(entry.speakable),
            icon: const Icon(Icons.volume_up_rounded),
            color: tint,
            tooltip: 'Nghe ví dụ',
          ),
        ],
      ),
    );
  }
}
