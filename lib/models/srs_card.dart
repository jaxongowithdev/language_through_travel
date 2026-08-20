/// Chất lượng nhớ lại mà người học tự đánh giá sau mỗi thẻ.
enum RecallQuality {
  again(0, 'Quên rồi'),
  hard(1, 'Khó'),
  good(2, 'Nhớ được'),
  easy(3, 'Dễ');

  const RecallQuality(this.value, this.label);
  final int value;
  final String label;
}

/// Trạng thái lặp lại ngắt quãng của một [Phrase].
///
/// Thuật toán là biến thể rút gọn của SM-2: mỗi lần trả lời đúng, khoảng cách
/// ôn tập được nhân với hệ số dễ (`ease`); trả lời sai đưa thẻ về đầu hàng đợi.
class SrsCard {
  SrsCard({
    required this.phraseId,
    this.repetitions = 0,
    this.intervalDays = 0,
    this.ease = 2.5,
    this.dueDate,
    this.lapses = 0,
  });

  final String phraseId;

  /// Số lần trả lời đúng liên tiếp.
  int repetitions;

  /// Khoảng cách tới lần ôn kế tiếp, tính bằng ngày.
  int intervalDays;

  /// Hệ số dễ, tối thiểu 1.3.
  double ease;

  /// Thời điểm đến hạn ôn tập.
  DateTime? dueDate;

  /// Số lần quên sau khi đã thuộc.
  int lapses;

  bool get isNew => repetitions == 0 && dueDate == null;

  bool get isDue {
    final DateTime? due = dueDate;
    if (due == null) return true;
    return !due.isAfter(DateTime.now());
  }

  /// Thẻ được coi là "đã thuộc" khi khoảng cách ôn từ 21 ngày trở lên.
  bool get isMastered => intervalDays >= 21;

  /// Cập nhật lịch ôn dựa trên [quality].
  void review(RecallQuality quality) {
    final DateTime now = DateTime.now();

    if (quality == RecallQuality.again) {
      repetitions = 0;
      intervalDays = 0;
      lapses += 1;
      ease = (ease - 0.2).clamp(1.3, 3.0);
      // Ôn lại ngay trong phiên: đến hạn sau 10 phút.
      dueDate = now.add(const Duration(minutes: 10));
      return;
    }

    switch (quality) {
      case RecallQuality.hard:
        ease = (ease - 0.15).clamp(1.3, 3.0);
        break;
      case RecallQuality.good:
        break;
      case RecallQuality.easy:
        ease = (ease + 0.15).clamp(1.3, 3.0);
        break;
      case RecallQuality.again:
        break;
    }

    repetitions += 1;
    if (repetitions == 1) {
      intervalDays = quality == RecallQuality.easy ? 2 : 1;
    } else if (repetitions == 2) {
      intervalDays = quality == RecallQuality.hard ? 3 : 6;
    } else {
      final double next = intervalDays * ease *
          (quality == RecallQuality.hard ? 0.8 : 1.0);
      intervalDays = next.round().clamp(1, 365);
    }
    dueDate = DateTime(now.year, now.month, now.day)
        .add(Duration(days: intervalDays));
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'phraseId': phraseId,
        'repetitions': repetitions,
        'intervalDays': intervalDays,
        'ease': ease,
        'dueDate': dueDate?.toIso8601String(),
        'lapses': lapses,
      };

  factory SrsCard.fromJson(Map<String, dynamic> json) {
    final Object? due = json['dueDate'];
    return SrsCard(
      phraseId: json['phraseId'] as String,
      repetitions: (json['repetitions'] as num?)?.toInt() ?? 0,
      intervalDays: (json['intervalDays'] as num?)?.toInt() ?? 0,
      ease: (json['ease'] as num?)?.toDouble() ?? 2.5,
      dueDate: due is String ? DateTime.tryParse(due) : null,
      lapses: (json['lapses'] as num?)?.toInt() ?? 0,
    );
  }
}
