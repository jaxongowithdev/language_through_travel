import 'package:flutter_test/flutter_test.dart';
import 'package:language_through_travel/models/srs_card.dart';

void main() {
  group('SrsCard', () {
    test('thẻ mới thì đến hạn ngay', () {
      final SrsCard card = SrsCard(phraseId: 'en.airport.01');
      expect(card.isNew, isTrue);
      expect(card.isDue, isTrue);
      expect(card.isMastered, isFalse);
    });

    test('trả lời "Nhớ được" giãn dần khoảng cách ôn', () {
      final SrsCard card = SrsCard(phraseId: 'en.airport.01');

      card.review(RecallQuality.good);
      expect(card.repetitions, 1);
      expect(card.intervalDays, 1);

      card.review(RecallQuality.good);
      expect(card.repetitions, 2);
      expect(card.intervalDays, 6);

      card.review(RecallQuality.good);
      expect(card.repetitions, 3);
      expect(card.intervalDays, greaterThan(6));
    });

    test('trả lời "Quên rồi" đưa thẻ về đầu hàng đợi và giảm ease', () {
      final SrsCard card = SrsCard(phraseId: 'en.airport.01');
      card.review(RecallQuality.good);
      card.review(RecallQuality.good);
      final double easeBefore = card.ease;

      card.review(RecallQuality.again);

      expect(card.repetitions, 0);
      expect(card.intervalDays, 0);
      expect(card.lapses, 1);
      expect(card.ease, lessThan(easeBefore));
      expect(card.dueDate!.isAfter(DateTime.now()), isTrue);
    });

    test('ease không bao giờ xuống dưới 1.3', () {
      final SrsCard card = SrsCard(phraseId: 'en.airport.01');
      for (int i = 0; i < 20; i++) {
        card.review(RecallQuality.again);
      }
      expect(card.ease, greaterThanOrEqualTo(1.3));
    });

    test('thẻ được coi là đã thuộc khi khoảng cách >= 21 ngày', () {
      final SrsCard card = SrsCard(phraseId: 'en.airport.01', intervalDays: 21);
      expect(card.isMastered, isTrue);
    });

    test('toJson/fromJson giữ nguyên trạng thái', () {
      final SrsCard card = SrsCard(phraseId: 'ja.hotel.03');
      card.review(RecallQuality.easy);
      card.review(RecallQuality.good);

      final SrsCard restored = SrsCard.fromJson(card.toJson());

      expect(restored.phraseId, card.phraseId);
      expect(restored.repetitions, card.repetitions);
      expect(restored.intervalDays, card.intervalDays);
      expect(restored.ease, closeTo(card.ease, 0.0001));
      expect(restored.dueDate, card.dueDate);
      expect(restored.lapses, card.lapses);
    });
  });
}
