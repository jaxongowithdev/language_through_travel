import 'package:flutter_test/flutter_test.dart';
import 'package:noi_ngay/data/library.dart';
import 'package:noi_ngay/models/conversation.dart';
import 'package:noi_ngay/models/lesson.dart';
import 'package:noi_ngay/models/reference.dart';
import 'package:noi_ngay/models/spoken_line.dart';
import 'package:noi_ngay/models/topic.dart';
import 'package:noi_ngay/models/word_card.dart';

/// Khoá lại hình dạng của kho nội dung.
///
/// Nội dung được viết dưới dạng bảng văn bản nên lỗi hay gặp nhất là thiếu một
/// cột hoặc gõ nhầm dấu ngăn. Những test này bắt đúng loại lỗi đó, và bắt ngay
/// khi chạy `flutter test` chứ không đợi tới lúc mở app.
void main() {
  final Library library = Library.instance;

  group('Chủ đề', () {
    test('có đúng hai mươi chủ đề, mã không trùng', () {
      expect(library.topics.length, 20);
      final Set<String> codes =
          library.topics.map((Topic t) => t.code).toSet();
      expect(codes.length, library.topics.length);
    });

    test('mỗi chủ đề có ba bài học, mỗi bài tám câu', () {
      for (final Topic topic in library.topics) {
        expect(topic.lessons.length, 3, reason: topic.code);
        for (final Lesson lesson in topic.lessons) {
          expect(lesson.lines.length, 8, reason: lesson.id);
          expect(lesson.title, isNotEmpty, reason: lesson.id);
          expect(lesson.goal, isNotEmpty, reason: lesson.id);
        }
      }
    });

    test('mỗi chủ đề có mười từ vựng đủ IPA và nghĩa', () {
      for (final Topic topic in library.topics) {
        expect(topic.words.length, 10, reason: topic.code);
        for (final WordCard word in topic.words) {
          expect(word.word, isNotEmpty, reason: word.id);
          expect(word.ipa.startsWith('/'), isTrue, reason: word.id);
          expect(word.ipa.endsWith('/'), isTrue, reason: word.id);
          expect(word.vietnamese, isNotEmpty, reason: word.id);
        }
      }
    });

    test('mỗi chủ đề có một hội thoại tám lượt, có lượt của người học', () {
      for (final Topic topic in library.topics) {
        expect(topic.conversations.length, 1, reason: topic.code);
        final Conversation talk = topic.conversations.first;
        expect(talk.turns.length, 8, reason: talk.id);
        expect(talk.learnerTurnCount, greaterThan(0), reason: talk.id);
        for (final ConversationTurn turn in talk.turns) {
          expect(turn.speaker, isNotEmpty);
          expect(turn.speaker.startsWith('>'), isFalse,
              reason: 'dấu > phải bị cắt khỏi tên vai');
          expect(turn.english, isNotEmpty);
          expect(turn.vietnamese, isNotEmpty);
        }
      }
    });
  });

  group('Câu', () {
    test('id duy nhất trên toàn app', () {
      final List<SpokenLine> lines = library.allLines;
      final Set<String> ids = lines.map((SpokenLine l) => l.id).toSet();
      expect(ids.length, lines.length);
    });

    test('không có câu nào thiếu bản tiếng Anh hoặc nghĩa', () {
      for (final SpokenLine line in library.allLines) {
        expect(line.english.trim(), isNotEmpty, reason: line.id);
        expect(line.vietnamese.trim(), isNotEmpty, reason: line.id);
      }
    });

    test('id chỉ đúng về chủ đề và bài học của nó', () {
      for (final Topic topic in library.topics) {
        for (final SpokenLine line in topic.lines) {
          expect(line.topicCode, topic.code);
          expect(library.lineById(line.id), isNotNull);
        }
      }
    });

    test('đủ câu ngắn cho trò sắp xếp từ', () {
      final int usable = library.allLines
          .where((SpokenLine l) => l.wordCount >= 5 && l.wordCount <= 10)
          .length;
      expect(usable, greaterThan(100));
    });
  });

  group('Sổ tay', () {
    test('có năm mục và không mục nào rỗng', () {
      expect(library.reference.length, 5);
      for (final RefSection section in library.reference) {
        expect(section.entries, isNotEmpty, reason: section.id);
        for (final RefEntry entry in section.entries) {
          expect(entry.headword.trim(), isNotEmpty, reason: entry.id);
          expect(entry.speakable.trim(), isNotEmpty, reason: entry.id);
        }
      }
    });

    test('mọi mục ngữ pháp đều có ít nhất một ví dụ song ngữ', () {
      for (final RefEntry entry in library.refSection('grammar').entries) {
        expect(entry.examples, isNotEmpty, reason: entry.id);
        for (final RefExample example in entry.examples) {
          expect(example.english.trim(), isNotEmpty, reason: entry.id);
          expect(example.vietnamese.trim(), isNotEmpty, reason: entry.id);
        }
      }
    });

    test('bảng âm dùng ký hiệu IPA đặt trong hai dấu gạch chéo', () {
      for (final RefEntry entry in library.refSection('sound').entries) {
        expect(entry.headword.startsWith('/'), isTrue, reason: entry.id);
        expect(entry.headword.endsWith('/'), isTrue, reason: entry.id);
      }
    });
  });

  group('Tìm kiếm và mẹo', () {
    test('tìm được cả bằng tiếng Anh lẫn tiếng Việt', () {
      expect(library.searchLines('sorry'), isNotEmpty);
      expect(library.searchLines('xin lỗi'), isNotEmpty);
      expect(library.searchWords('deadline'), isNotEmpty);
      expect(library.searchReference('look after'), isNotEmpty);
    });

    test('truy vấn rỗng không trả về gì', () {
      expect(library.searchLines('   '), isEmpty);
      expect(library.searchWords(''), isEmpty);
      expect(library.searchReference(''), isEmpty);
    });

    test('mẹo mỗi ngày ổn định trong cùng một ngày', () {
      final DateTime day = DateTime(2026, 3, 14);
      expect(library.tipFor(day).title, library.tipFor(day).title);
      expect(library.tips.length, greaterThanOrEqualTo(30));
    });
  });

  test('tổng số mục nội dung vượt một nghìn', () {
    expect(library.lineCount, 480);
    expect(library.wordCount, 200);
    expect(library.conversationTurnCount, 160);
    expect(library.totalItemCount, greaterThan(1000));
  });
}
