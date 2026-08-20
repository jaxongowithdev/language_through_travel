import 'package:flutter_test/flutter_test.dart';
import 'package:language_through_travel/data/content_repository.dart';
import 'package:language_through_travel/models/dialogue.dart';
import 'package:language_through_travel/models/language.dart';
import 'package:language_through_travel/models/phrase.dart';
import 'package:language_through_travel/models/scenario.dart';

void main() {
  const ContentRepository repo = ContentRepository();

  group('ContentRepository', () {
    test('mỗi ngôn ngữ có đủ 4 chặng, đúng thứ tự', () {
      for (final LearningLanguage lang in LearningLanguage.all) {
        final List<Scenario> scenarios = repo.scenariosFor(lang.code);
        expect(scenarios.length, 4, reason: lang.code);
        expect(
          scenarios.map((Scenario s) => s.code).toList(),
          <String>['airport', 'hotel', 'restaurant', 'taxi'],
          reason: lang.code,
        );
      }
    });

    test('không chặng nào bị rỗng nội dung', () {
      for (final LearningLanguage lang in LearningLanguage.all) {
        for (final Scenario s in repo.scenariosFor(lang.code)) {
          expect(s.phrases, isNotEmpty, reason: '${lang.code}/${s.code}');
          expect(s.dialogues, isNotEmpty, reason: '${lang.code}/${s.code}');
        }
      }
    });

    test('id của mọi câu là duy nhất và khớp ngôn ngữ + chặng', () {
      final Set<String> seen = <String>{};
      for (final LearningLanguage lang in LearningLanguage.all) {
        for (final Scenario s in repo.scenariosFor(lang.code)) {
          for (final Phrase p in s.phrases) {
            expect(seen.add(p.id), isTrue, reason: 'id trùng: ${p.id}');
            expect(p.languageCode, lang.code);
            expect(p.scenarioCode, s.code);
          }
        }
      }
    });

    test('phraseById tra cứu được mọi câu', () {
      for (final LearningLanguage lang in LearningLanguage.all) {
        for (final Phrase p in repo.allPhrases(lang.code)) {
          expect(repo.phraseById(p.id)?.target, p.target);
        }
      }
      expect(repo.phraseById('khong.ton.tai'), isNull);
      expect(repo.phraseById('sai-dinh-dang'), isNull);
    });

    test('ngôn ngữ có phiên âm thì mọi câu đều có phiên âm', () {
      for (final LearningLanguage lang in LearningLanguage.all) {
        if (!lang.hasRomanization) continue;
        for (final Phrase p in repo.allPhrases(lang.code)) {
          expect(p.romanization, isNotEmpty, reason: p.id);
        }
      }
    });

    test('mọi câu đều có nghĩa tiếng Việt và nội dung ngôn ngữ đích', () {
      for (final LearningLanguage lang in LearningLanguage.all) {
        for (final Phrase p in repo.allPhrases(lang.code)) {
          expect(p.target.trim(), isNotEmpty, reason: p.id);
          expect(p.vietnamese.trim(), isNotEmpty, reason: p.id);
        }
      }
    });

    test('hội thoại luôn có ít nhất một lượt của người học', () {
      for (final LearningLanguage lang in LearningLanguage.all) {
        for (final Scenario s in repo.scenariosFor(lang.code)) {
          for (final Dialogue d in s.dialogues) {
            expect(
              d.lines.any((DialogueLine l) => l.isUser),
              isTrue,
              reason: d.id,
            );
          }
        }
      }
    });

    test('mỗi chặng có đủ câu để dựng quiz 4 đáp án', () {
      for (final LearningLanguage lang in LearningLanguage.all) {
        for (final Scenario s in repo.scenariosFor(lang.code)) {
          expect(s.phrases.length, greaterThanOrEqualTo(4),
              reason: '${lang.code}/${s.code}');
        }
      }
    });
  });

  group('LearningLanguage', () {
    test('byCode trả về đúng ngôn ngữ, mã lạ thì rơi về mặc định', () {
      expect(LearningLanguage.byCode('ja').nativeName, '日本語');
      expect(LearningLanguage.byCode('zz').code, LearningLanguage.all.first.code);
    });
  });
}
