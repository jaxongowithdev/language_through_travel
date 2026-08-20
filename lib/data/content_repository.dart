import '../models/dialogue.dart';
import '../models/phrase.dart';
import '../models/scenario.dart';
import 'content_en.dart';
import 'content_ja.dart';
import 'content_ko.dart';
import 'content_th.dart';

/// Điểm truy cập duy nhất tới toàn bộ nội dung học.
class ContentRepository {
  const ContentRepository();

  static const Map<String, Map<String, List<Phrase>>> _phrasesByLanguage =
      <String, Map<String, List<Phrase>>>{
    'en': enPhrases,
    'ja': jaPhrases,
    'ko': koPhrases,
    'th': thPhrases,
  };

  static const Map<String, Map<String, List<Dialogue>>> _dialoguesByLanguage =
      <String, Map<String, List<Dialogue>>>{
    'en': enDialogues,
    'ja': jaDialogues,
    'ko': koDialogues,
    'th': thDialogues,
  };

  /// Toàn bộ tình huống của [languageCode], đã sắp theo thứ tự hành trình.
  List<Scenario> scenariosFor(String languageCode) {
    final Map<String, List<Phrase>> phrases =
        _phrasesByLanguage[languageCode] ?? const <String, List<Phrase>>{};
    final Map<String, List<Dialogue>> dialogues =
        _dialoguesByLanguage[languageCode] ?? const <String, List<Dialogue>>{};

    final List<Scenario> result = ScenarioMeta.all
        .map((ScenarioMeta meta) => Scenario(
              code: meta.code,
              title: meta.title,
              tagline: meta.tagline,
              icon: meta.icon,
              color: meta.color,
              order: meta.order,
              phrases: phrases[meta.code] ?? const <Phrase>[],
              dialogues: dialogues[meta.code] ?? const <Dialogue>[],
            ))
        .toList();
    result.sort((Scenario a, Scenario b) => a.order.compareTo(b.order));
    return result;
  }

  Scenario scenario(String languageCode, String scenarioCode) {
    return scenariosFor(languageCode)
        .firstWhere((Scenario s) => s.code == scenarioCode);
  }

  /// Tất cả câu/từ của một ngôn ngữ, gộp mọi tình huống.
  List<Phrase> allPhrases(String languageCode) {
    return <Phrase>[
      for (final Scenario s in scenariosFor(languageCode)) ...s.phrases,
    ];
  }

  /// Tra cứu một [Phrase] theo id đầy đủ. Trả về null nếu không tìm thấy.
  Phrase? phraseById(String id) {
    final List<String> parts = id.split('.');
    if (parts.length < 3) return null;
    final List<Phrase> pool =
        _phrasesByLanguage[parts[0]]?[parts[1]] ?? const <Phrase>[];
    for (final Phrase p in pool) {
      if (p.id == id) return p;
    }
    return null;
  }
}
