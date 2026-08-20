import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dialogue.dart';
import '../models/phrase.dart';
import '../models/scenario.dart';
import '../state/app_state.dart';
import '../widgets/phrase_tile.dart';
import 'dialogue_screen.dart';
import 'flashcard_screen.dart';
import 'quiz_screen.dart';

/// Chi tiết một chặng: danh sách câu/từ, hội thoại, và lối vào flashcard/quiz.
class ScenarioScreen extends StatelessWidget {
  const ScenarioScreen({super.key, required this.scenarioCode});

  final String scenarioCode;

  @override
  Widget build(BuildContext context) {
    final AppState state = context.watch<AppState>();
    final Scenario scenario =
        state.repository.scenario(state.language.code, scenarioCode);
    final ThemeData theme = Theme.of(context);

    final List<Phrase> sentences =
        scenario.phrases.where((Phrase p) => p.isSentence).toList();
    final List<Phrase> words =
        scenario.phrases.where((Phrase p) => !p.isSentence).toList();

    return Scaffold(
      appBar: AppBar(title: Text(scenario.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          _Header(scenario: scenario, state: state),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: _ActionButton(
                  icon: Icons.style_rounded,
                  label: 'Flashcard',
                  color: scenario.color,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => FlashcardScreen(
                        phrases: scenario.phrases,
                        title: scenario.title,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  icon: Icons.quiz_rounded,
                  label: 'Quiz',
                  color: scenario.color,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => QuizScreen(scenario: scenario),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (scenario.dialogues.isNotEmpty) ...<Widget>[
            _SectionTitle(
              title: 'Hội thoại tình huống',
              subtitle: 'Nghe và luyện theo đoạn hội thoại thật',
            ),
            const SizedBox(height: 10),
            ...scenario.dialogues.map(
              (Dialogue d) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: scenario.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.forum_rounded,
                        color: scenario.color,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      d.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(d.subtitle),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => DialogueScreen(dialogue: d),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          _SectionTitle(
            title: 'Câu giao tiếp',
            subtitle: '${sentences.length} câu bạn sẽ dùng ngay tại chỗ',
          ),
          const SizedBox(height: 10),
          ...sentences.map(
            (Phrase p) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PhraseTile(
                phrase: p,
                language: state.language,
                learned: state.cardFor(p.id).repetitions > 0,
                onSpeak: () => state.speak(p.target),
              ),
            ),
          ),
          if (words.isNotEmpty) ...<Widget>[
            const SizedBox(height: 14),
            _SectionTitle(
              title: 'Từ vựng',
              subtitle: '${words.length} từ cần nhận mặt',
            ),
            const SizedBox(height: 10),
            ...words.map(
              (Phrase p) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PhraseTile(
                  phrase: p,
                  language: state.language,
                  learned: state.cardFor(p.id).repetitions > 0,
                  onSpeak: () => state.speak(p.target),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.scenario, required this.state});

  final Scenario scenario;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int best = state.quizBest(scenario.code);

    return Card(
      color: scenario.color.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(scenario.icon, color: scenario.color, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    scenario.tagline,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: state.scenarioProgress(scenario),
                minHeight: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.4),
                valueColor: AlwaysStoppedAnimation<Color>(scenario.color),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${state.scenarioLearnedCount(scenario)}/${scenario.phraseCount} '
              'câu đã học${best > 0 ? '  ·  quiz cao nhất $best%' : ''}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.15),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
