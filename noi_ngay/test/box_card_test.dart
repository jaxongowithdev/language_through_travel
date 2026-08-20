import 'package:flutter_test/flutter_test.dart';
import 'package:noi_ngay/models/box_card.dart';

/// Kiểm tra hệ thống hộp Leitner.
///
/// Lịch ôn là thứ người học tin tưởng, nên hành vi lên hộp, xuống hộp và tính
/// ngày đến hạn được khoá lại bằng test thay vì kiểm bằng mắt.
void main() {
  group('Lên và xuống hộp', () {
    test('thẻ mới nằm ở hộp một và đến hạn ngay', () {
      final BoxCard card = BoxCard(lineId: 'demo.l1.01');
      expect(card.box, 1);
      expect(card.isNew, isTrue);
      expect(card.isDue, isTrue);
      expect(card.isLearned, isFalse);
    });

    test('nhớ rõ đẩy thẻ lên một hộp mỗi lần', () {
      final BoxCard card = BoxCard(lineId: 'demo.l1.01');
      card.grade(Recall.solid);
      expect(card.box, 2);
      card.grade(Recall.solid);
      expect(card.box, 3);
      card.grade(Recall.solid);
      card.grade(Recall.solid);
      expect(card.box, BoxCard.topBox);
      expect(card.isLearned, isTrue);
    });

    test('hộp không vượt quá hộp cuối', () {
      final BoxCard card = BoxCard(lineId: 'demo.l1.01', box: BoxCard.topBox);
      card.grade(Recall.solid);
      expect(card.box, BoxCard.topBox);
    });

    test('chưa nhớ đưa thẻ về hộp một', () {
      final BoxCard card = BoxCard(lineId: 'demo.l1.01', box: 4);
      card.grade(Recall.missed);
      expect(card.box, 1);
      expect(card.isLearned, isFalse);
    });

    test('lơ mơ chỉ lùi một hộp và không xuống dưới hộp một', () {
      final BoxCard card = BoxCard(lineId: 'demo.l1.01', box: 3);
      card.grade(Recall.shaky);
      expect(card.box, 2);
      card.grade(Recall.shaky);
      expect(card.box, 1);
      card.grade(Recall.shaky);
      expect(card.box, 1);
    });
  });

  group('Lịch đến hạn', () {
    test('thẻ ở hộp một quay lại ngay trong phiên', () {
      final BoxCard card = BoxCard(lineId: 'demo.l1.01');
      card.grade(Recall.missed);
      final DateTime due = card.dueAt!;
      expect(due.isAfter(DateTime.now()), isTrue);
      expect(
        due.difference(DateTime.now()).inMinutes,
        lessThanOrEqualTo(12),
      );
      expect(card.isDue, isFalse);
    });

    test('lên hộp cao thì lịch giãn theo bảng cố định', () {
      final BoxCard card = BoxCard(lineId: 'demo.l1.01');
      card.grade(Recall.solid); // hộp 2 → 1 ngày
      final DateTime midnight = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      expect(card.dueAt!.difference(midnight).inDays, 1);

      card.grade(Recall.solid); // hộp 3 → 3 ngày
      expect(card.dueAt!.difference(midnight).inDays, 3);

      card.grade(Recall.solid); // hộp 4 → 7 ngày
      expect(card.dueAt!.difference(midnight).inDays, 7);

      card.grade(Recall.solid); // hộp 5 → 16 ngày
      expect(card.dueAt!.difference(midnight).inDays, 16);
    });
  });

  group('Thống kê và lưu trữ', () {
    test('đếm số lần ôn và số lần nhớ rõ', () {
      final BoxCard card = BoxCard(lineId: 'demo.l1.01');
      card.grade(Recall.solid);
      card.grade(Recall.missed);
      card.grade(Recall.solid);
      expect(card.seen, 3);
      expect(card.correct, 2);
      expect(card.accuracy, closeTo(2 / 3, 0.001));
      expect(card.lastResult, Recall.solid.value);
    });

    test('ghi ra JSON rồi đọc lại giữ nguyên trạng thái', () {
      final BoxCard card = BoxCard(lineId: 'demo.l1.01');
      card.grade(Recall.solid);
      card.grade(Recall.solid);
      final BoxCard restored = BoxCard.fromJson(card.toJson());
      expect(restored.lineId, card.lineId);
      expect(restored.box, card.box);
      expect(restored.seen, card.seen);
      expect(restored.correct, card.correct);
      expect(restored.dueAt, card.dueAt);
    });

    test('dữ liệu hỏng vẫn đọc được về giá trị an toàn', () {
      final BoxCard restored = BoxCard.fromJson(<String, dynamic>{
        'id': 'demo.l1.02',
        'box': 99,
      });
      expect(restored.box, BoxCard.topBox);
      expect(restored.seen, 0);
      expect(restored.dueAt, isNull);
    });
  });
}
