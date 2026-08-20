import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/reference.dart';
import '../../models/topic.dart';
import '../../state/learn_state.dart';
import '../screens/reference_screen.dart';
import '../screens/search_screen.dart';
import '../screens/topic_screen.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

/// Tab Chủ đề: hai chế độ xem trong cùng một tab.
///
/// "Bài học" là hai mươi chủ đề giao tiếp, "Sổ tay" là năm mục tra cứu. Gộp lại
/// một tab vì người dùng đi tìm nội dung thì nghĩ theo chủ đề chứ không nghĩ
/// theo kiểu nội dung.
class TopicsTab extends StatefulWidget {
  const TopicsTab({super.key});

  @override
  State<TopicsTab> createState() => _TopicsTabState();
}

class _TopicsTabState extends State<TopicsTab> {
  bool _showReference = false;
  SpeakLevel? _levelFilter;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.watch<LearnState>();
    final List<Topic> topics = _levelFilter == null
        ? state.library.topics
        : state.library.topics
            .where((Topic t) => t.level == _levelFilter)
            .toList();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  _showReference ? 'Sổ tay' : 'Chủ đề',
                  style: theme.textTheme.headlineMedium,
                ),
              ),
              IconButton.filledTonal(
                onPressed: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const SearchScreen(),
                  ),
                ),
                icon: const Icon(Icons.search_rounded),
                tooltip: 'Tìm kiếm',
              ),
            ],
          ),
          const SizedBox(height: 14),
          SegmentedButton<bool>(
            segments: const <ButtonSegment<bool>>[
              ButtonSegment<bool>(
                value: false,
                label: Text('Bài học'),
                icon: Icon(Icons.grid_view_rounded, size: 17),
              ),
              ButtonSegment<bool>(
                value: true,
                label: Text('Sổ tay'),
                icon: Icon(Icons.menu_book_rounded, size: 17),
              ),
            ],
            selected: <bool>{_showReference},
            showSelectedIcon: false,
            onSelectionChanged: (Set<bool> value) =>
                setState(() => _showReference = value.first),
          ),
          const SizedBox(height: 16),
          if (_showReference)
            ..._referenceCards(state)
          else ...<Widget>[
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _LevelChip(
                    label: 'Tất cả',
                    selected: _levelFilter == null,
                    onTap: () => setState(() => _levelFilter = null),
                  ),
                  for (final SpeakLevel level in SpeakLevel.values)
                    _LevelChip(
                      label: level.label,
                      selected: _levelFilter == level,
                      onTap: () => setState(() => _levelFilter = level),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Text(
                _levelFilter == null
                    ? 'Mọi chủ đề đều mở sẵn, học theo thứ tự nào cũng được.'
                    : _levelFilter!.blurb,
                style: theme.textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 8),
            for (final Topic topic in topics) ...<Widget>[
              _TopicCard(
                topic: topic,
                progress: state.topicProgress(topic),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ],
      ),
    );
  }

  List<Widget> _referenceCards(LearnState state) {
    final ThemeData theme = Theme.of(context);
    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          'Năm mục tra cứu, tổng cộng ${state.library.referenceCount} mục. '
          'Không có mục nào bị khoá.',
          style: theme.textTheme.bodySmall,
        ),
      ),
      const SizedBox(height: 14),
      for (final RefSection section in state.library.reference) ...<Widget>[
        GlassCard(
          tint: section.tint,
          onTap: () => Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder: (_) => ReferenceScreen(section: section),
            ),
          ),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: section.tint.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(section.icon, color: section.tint),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(section.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 3),
                    Text(section.subtitle, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Pill(label: '${section.entryCount}', tint: section.tint),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    ];
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({required this.topic, required this.progress});

  final Topic topic;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      tint: topic.tint,
      onTap: () => Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => TopicScreen(topic: topic)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: topic.tint.withValues(alpha: 0.17),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  topic.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(topic.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 3),
                    Text(
                      topic.subtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              Pill(label: topic.level.label, tint: topic.tint),
              Pill(
                label: '${topic.lineCount} câu',
                icon: Icons.chat_bubble_outline_rounded,
                tint: topic.tint,
              ),
              Pill(
                label: '${topic.words.length} từ',
                icon: Icons.text_fields_rounded,
                tint: topic.tint,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ProgressBar(value: progress, tint: topic.tint),
        ],
      ),
    );
  }
}
