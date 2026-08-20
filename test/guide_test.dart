import 'package:flutter_test/flutter_test.dart';
import 'package:language_through_travel/data/guide_content.dart';
import 'package:language_through_travel/models/guide.dart';
import 'package:language_through_travel/models/language.dart';

void main() {
  group('Cẩm nang', () {
    test('mọi ngôn ngữ đều có nội dung cẩm nang', () {
      for (final LearningLanguage lang in LearningLanguage.all) {
        expect(
          guideTopicsByLanguage[lang.code],
          isNotNull,
          reason: 'thiếu cẩm nang cho ${lang.code}',
        );
        expect(guideTopicsByLanguage[lang.code], isNotEmpty, reason: lang.code);
      }
    });

    test('id chủ đề không trùng nhau trong cùng một ngôn ngữ', () {
      for (final LearningLanguage lang in LearningLanguage.all) {
        final Set<String> seen = <String>{};
        for (final GuideTopic topic in guideTopicsByLanguage[lang.code]!) {
          expect(
            seen.add(topic.id),
            isTrue,
            reason: 'id trùng: ${lang.code}/${topic.id}',
          );
        }
      }
    });

    test('mọi ngôn ngữ đều có chủ đề khẩn cấp', () {
      for (final LearningLanguage lang in LearningLanguage.all) {
        expect(
          guideTopicsByLanguage[lang.code]!
              .any((GuideTopic t) => t.id == 'emergency'),
          isTrue,
          reason: lang.code,
        );
      }
    });

    test('thẻ nào cũng có tiêu đề và có nội dung để đọc', () {
      for (final LearningLanguage lang in LearningLanguage.all) {
        for (final GuideTopic topic in guideTopicsByLanguage[lang.code]!) {
          expect(topic.cards, isNotEmpty, reason: '${lang.code}/${topic.id}');
          for (final GuideCard card in topic.cards) {
            expect(card.title.trim(), isNotEmpty, reason: topic.id);
            expect(
              card.body.trim().isNotEmpty || card.entries.isNotEmpty,
              isTrue,
              reason: 'thẻ rỗng: ${lang.code}/${topic.id}/${card.title}',
            );
          }
        }
      }
    });

    test('mọi mục đều có nghĩa tiếng Việt', () {
      for (final LearningLanguage lang in LearningLanguage.all) {
        for (final GuideTopic topic in guideTopicsByLanguage[lang.code]!) {
          for (final GuideCard card in topic.cards) {
            for (final GuideEntry entry in card.entries) {
              expect(
                entry.vietnamese.trim(),
                isNotEmpty,
                reason: '${lang.code}/${topic.id}: ${entry.target}',
              );
            }
          }
        }
      }
    });

    test('ngôn ngữ có phiên âm thì mục nào cũng kèm phiên âm', () {
      for (final LearningLanguage lang in LearningLanguage.all) {
        if (!lang.hasRomanization) continue;
        for (final GuideTopic topic in guideTopicsByLanguage[lang.code]!) {
          for (final GuideCard card in topic.cards) {
            for (final GuideEntry entry in card.entries) {
              if (!entry.speakable) continue;
              expect(
                entry.romanization.trim(),
                isNotEmpty,
                reason: '${lang.code}/${topic.id}: ${entry.target}',
              );
            }
          }
        }
      }
    });

    test('entryCount đếm đúng tổng số mục', () {
      for (final GuideTopic topic in guideTopicsByLanguage['ja']!) {
        int expected = 0;
        for (final GuideCard card in topic.cards) {
          expected += card.entries.length;
        }
        expect(topic.entryCount, expected, reason: topic.id);
      }
    });
  });
}
