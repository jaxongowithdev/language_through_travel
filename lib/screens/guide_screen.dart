import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/guide_content.dart';
import '../models/guide.dart';
import '../state/app_state.dart';

/// Tab "Cẩm nang": tra cứu nhanh những thứ không nằm trong bốn chặng —
/// số đếm, tiền bạc, câu khẩn cấp, phép lịch sự.
class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = context.watch<AppState>();
    final ThemeData theme = Theme.of(context);
    final List<GuideTopic> topics =
        guideTopicsByLanguage[state.language.code] ?? const <GuideTopic>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Cẩm nang')),
      body: topics.isEmpty
          ? const Center(child: Text('Chưa có cẩm nang cho ngôn ngữ này.'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: <Widget>[
                _IntroCard(
                  flag: state.language.flag,
                  languageName: state.language.name,
                  topicCount: topics.length,
                ),
                const SizedBox(height: 20),
                Text(
                  'Chủ đề',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                ...topics.map(
                  (GuideTopic topic) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _TopicTile(topic: topic),
                  ),
                ),
              ],
            ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({
    required this.flag,
    required this.languageName,
    required this.topicCount,
  });

  final String flag;
  final String languageName;
  final int topicCount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: <Widget>[
            Text(flag, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Bỏ túi trước chuyến đi',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$topicCount chủ đề tra cứu nhanh cho $languageName',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer
                          .withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({required this.topic});

  final GuideTopic topic;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: topic.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(topic.icon, color: topic.color, size: 22),
        ),
        title: Text(
          topic.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          '${topic.subtitle} · ${topic.entryCount} mục',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => GuideTopicScreen(topicId: topic.id),
          ),
        ),
      ),
    );
  }
}

/// Chi tiết một chủ đề cẩm nang.
///
/// Nhận [topicId] chứ không nhận cả [GuideTopic]: nếu người dùng đổi ngôn ngữ
/// khi màn hình này đang mở, nội dung tự chuyển sang ngôn ngữ mới thay vì kẹt
/// lại ở dữ liệu cũ.
class GuideTopicScreen extends StatelessWidget {
  const GuideTopicScreen({super.key, required this.topicId});

  final String topicId;

  @override
  Widget build(BuildContext context) {
    final AppState state = context.watch<AppState>();
    final List<GuideTopic> topics =
        guideTopicsByLanguage[state.language.code] ?? const <GuideTopic>[];
    final int index = topics.indexWhere((GuideTopic t) => t.id == topicId);

    if (index < 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cẩm nang')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'Chủ đề này chưa có nội dung cho ngôn ngữ đang chọn.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final GuideTopic topic = topics[index];

    return Scaffold(
      appBar: AppBar(title: Text(topic.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          Card(
            color: topic.color.withValues(alpha: 0.12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Icon(topic.icon, color: topic.color, size: 26),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      topic.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          ...topic.cards.map(
            (GuideCard card) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _GuideCardView(card: card, color: topic.color),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideCardView extends StatelessWidget {
  const _GuideCardView({required this.card, required this.color});

  final GuideCard card;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppState state = context.read<AppState>();
    final bool showRomanization = state.language.hasRomanization;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                if (card.emoji.isNotEmpty) ...<Widget>[
                  Text(card.emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    card.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (card.body.isNotEmpty) ...<Widget>[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  card.body,
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                ),
              ),
            ],
            if (card.entries.isNotEmpty) const SizedBox(height: 4),
            ...card.entries.map(
              (GuideEntry entry) => _EntryRow(
                entry: entry,
                showRomanization: showRomanization,
                onSpeak: () => state.speak(entry.target),
              ),
            ),
            if (card.entries.isEmpty) const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({
    required this.entry,
    required this.showRomanization,
    required this.onSpeak,
  });

  final GuideEntry entry;
  final bool showRomanization;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool withRomanization =
        showRomanization && entry.romanization.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entry.target,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                if (withRomanization)
                  Text(
                    entry.romanization,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                Text(
                  entry.vietnamese,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (entry.speakable)
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onSpeak,
              icon: const Icon(Icons.volume_up_rounded, size: 20),
              tooltip: 'Nghe phát âm',
            ),
        ],
      ),
    );
  }
}
