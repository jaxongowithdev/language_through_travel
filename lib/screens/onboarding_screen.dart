import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/language.dart';
import '../models/scenario.dart';
import '../state/app_state.dart';

/// Màn hình chào mừng: giới thiệu hành trình và chọn ngôn ngữ muốn học.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  LearningLanguage _selected = LearningLanguage.all.first;

  /// Lưu lựa chọn. `main.dart` đang nghe [AppState] nên sẽ tự chuyển sang
  /// HomeScreen — không cần điều hướng thủ công ở đây.
  Future<void> _start() => context.read<AppState>().completeOnboarding(_selected);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                children: <Widget>[
                  Text(
                    '✈️',
                    style: theme.textTheme.displaySmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Language\nThrough Travel',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Học ngôn ngữ theo đúng thứ tự bạn sẽ cần khi đi du lịch.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _JourneyPreview(),
                  const SizedBox(height: 32),
                  Text(
                    'Bạn muốn học ngôn ngữ nào?',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...LearningLanguage.all.map(
                    (LearningLanguage lang) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _LanguageOption(
                        language: lang,
                        selected: lang.code == _selected.code,
                        onTap: () => setState(() => _selected = lang),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _start,
                  child: Text('Bắt đầu học ${_selected.name}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JourneyPreview extends StatelessWidget {
  const _JourneyPreview();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        for (int i = 0; i < ScenarioMeta.all.length; i++) ...<Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: ScenarioMeta.all[i].color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  ScenarioMeta.all[i].icon,
                  size: 16,
                  color: ScenarioMeta.all[i].color,
                ),
                const SizedBox(width: 6),
                Text(
                  ScenarioMeta.all[i].title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: ScenarioMeta.all[i].color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (i < ScenarioMeta.all.length - 1)
            Icon(
              Icons.arrow_forward_rounded,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
        ],
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final LearningLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerLow,
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            Text(language.flag, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    language.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    language.nativeName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
