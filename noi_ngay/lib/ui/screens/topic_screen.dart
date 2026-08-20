import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/conversation.dart';
import '../../models/lesson.dart';
import '../../models/topic.dart';
import '../../models/word_card.dart';
import '../../state/learn_state.dart';
import '../widgets/aurora_background.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';
import 'conversation_screen.dart';
import 'lesson_screen.dart';

/// Màn hình một chủ đề: ba bài học, từ vựng kèm IPA và hội thoại mẫu.
class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.watch<LearnState>();

    return Scaffold(
      body: AuroraBackground(
        topTint: topic.tint,
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                title: Text(topic.title),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    GlassCard(
                      tint: topic.tint,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                topic.emoji,
                                style: const TextStyle(fontSize: 30),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  topic.subtitle,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ProgressBar(
                            value: state.topicProgress(topic),
                            tint: topic.tint,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${(state.topicProgress(topic) * 100).round()} phần '
                            'trăm câu đã chạm tới · ${topic.itemCount} mục nội '
                            'dung trong chủ đề này',
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SectionHeader(
                      title: 'Bài học',
                      subtitle: 'Mỗi bài tám câu, học chừng năm phút',
                    ),
                    for (final Lesson lesson in topic.lessons) ...<Widget>[
                      _LessonRow(lesson: lesson, topic: topic),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 12),
                    for (final Conversation talk
                        in topic.conversations) ...<Widget>[
                      const SectionHeader(
                        title: 'Hội thoại mẫu',
                        subtitle: 'Nghe cả đoạn để quen nhịp nói thật',
                      ),
                      GlassCard(
                        tint: topic.tint,
                        onTap: () => Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) => ConversationScreen(
                              conversation: talk,
                              tint: topic.tint,
                            ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                color: topic.tint.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(
                                Icons.forum_rounded,
                                color: topic.tint,
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    talk.title,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    talk.setting,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    const SectionHeader(
                      title: 'Từ vựng',
                      subtitle: 'Chạm vào từ để nghe cách đọc',
                    ),
                    for (final WordCard word in topic.words) ...<Widget>[
                      _WordRow(word: word, tint: topic.tint),
                      const SizedBox(height: 10),
                    ],
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonRow extends StatelessWidget {
  const _LessonRow({required this.lesson, required this.topic});

  final Lesson lesson;
  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.watch<LearnState>();
    final double progress = state.lessonProgress(lesson);
    final bool done = state.isLessonDone(lesson.id);

    return GlassCard(
      tint: topic.tint,
      onTap: () => Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => LessonScreen(lesson: lesson, tint: topic.tint),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: topic.tint.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: done
                    ? Icon(Icons.check_rounded, color: topic.tint, size: 20)
                    : Text(
                        lesson.id.split('.').last.replaceAll('l', ''),
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: topic.tint),
                      ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(lesson.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(lesson.goal, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${lesson.lineCount} câu',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ProgressBar(value: progress, tint: topic.tint, height: 6),
        ],
      ),
    );
  }
}

class _WordRow extends StatelessWidget {
  const _WordRow({required this.word, required this.tint});

  final WordCard word;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.read<LearnState>();

    return GlassCard(
      tint: tint,
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      onTap: () => state.say(word.word),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        word.word,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      word.partOfSpeech,
                      style: theme.textTheme.labelSmall?.copyWith(color: tint),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(word.ipa, style: theme.textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(word.vietnamese, style: theme.textTheme.bodyMedium),
                if (word.hasExample) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    word.example,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(word.exampleVi, style: theme.textTheme.bodySmall),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () => state.say(
              word.hasExample ? word.example : word.word,
            ),
            icon: const Icon(Icons.volume_up_rounded),
            color: tint,
            tooltip: 'Nghe',
          ),
        ],
      ),
    );
  }
}
