/// Kết quả người học tự chấm sau mỗi câu ôn.
enum Recall {
  missed(0, 'Chưa nhớ', 'Đưa câu về hộp 1, ôn lại trong hôm nay'),
  shaky(1, 'Lơ mơ', 'Lùi một hộp, ôn lại sớm hơn'),
  solid(2, 'Nhớ rõ', 'Lên một hộp, giãn lịch ôn');

  const Recall(this.value, this.label, this.effect);
  final int value;
  final String label;
  final String effect;
}

/// Trạng thái ôn tập của một câu theo **hệ thống hộp Leitner năm ngăn**.
///
/// Khác với các thuật toán tính hệ số động, Leitner dùng lịch cố định nên người
/// học đoán trước được: nhớ rõ thì câu leo lên một hộp, quên thì rơi về hộp 1.
/// Lịch của từng hộp nằm ở [boxIntervals], tính bằng ngày.
///
///   hộp 1 → 0 ngày (ôn lại ngay trong phiên)
///   hộp 2 → 1 ngày
///   hộp 3 → 3 ngày
///   hộp 4 → 7 ngày
///   hộp 5 → 16 ngày  (đạt hộp 5 coi như đã thuộc)
class BoxCard {
  BoxCard({
    required this.lineId,
    this.box = 1,
    this.dueAt,
    this.seen = 0,
    this.correct = 0,
    this.lastResult = -1,
  });

  static const List<int> boxIntervals = <int>[0, 1, 3, 7, 16];
  static const int topBox = 5;

  /// Id của [SpokenLine] mà thẻ này theo dõi.
  final String lineId;

  /// Hộp hiện tại, từ 1 tới [topBox].
  int box;

  /// Thời điểm đến hạn ôn. null nghĩa là chưa từng ôn → đến hạn ngay.
  DateTime? dueAt;

  /// Số lần đã ôn.
  int seen;

  /// Số lần chấm "Nhớ rõ".
  int correct;

  /// Kết quả lần ôn gần nhất, -1 nếu chưa ôn. Dùng để tô màu lịch sử.
  int lastResult;

  bool get isNew => seen == 0;

  bool get isDue {
    final DateTime? due = dueAt;
    if (due == null) return true;
    return !due.isAfter(DateTime.now());
  }

  /// Câu đã leo tới hộp cuối được coi là thuộc.
  bool get isLearned => box >= topBox;

  /// Tỉ lệ nhớ, dùng cho thống kê ở tab Cá nhân.
  double get accuracy => seen == 0 ? 0 : correct / seen;

  /// Cập nhật hộp và lịch ôn theo [result].
  void grade(Recall result) {
    final DateTime now = DateTime.now();
    seen += 1;
    lastResult = result.value;

    switch (result) {
      case Recall.missed:
        box = 1;
        break;
      case Recall.shaky:
        box = box > 1 ? box - 1 : 1;
        break;
      case Recall.solid:
        correct += 1;
        box = box < topBox ? box + 1 : topBox;
        break;
    }

    final int days = boxIntervals[box - 1];
    if (days == 0) {
      // Hộp 1 quay lại ngay trong phiên học, sau 12 phút.
      dueAt = now.add(const Duration(minutes: 12));
    } else {
      final DateTime midnight = DateTime(now.year, now.month, now.day);
      dueAt = midnight.add(Duration(days: days));
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': lineId,
        'box': box,
        'due': dueAt?.toIso8601String(),
        'seen': seen,
        'ok': correct,
        'last': lastResult,
      };

  factory BoxCard.fromJson(Map<String, dynamic> json) {
    final Object? due = json['due'];
    final int rawBox = (json['box'] as num?)?.toInt() ?? 1;
    return BoxCard(
      lineId: json['id'] as String,
      box: rawBox.clamp(1, topBox),
      dueAt: due is String ? DateTime.tryParse(due) : null,
      seen: (json['seen'] as num?)?.toInt() ?? 0,
      correct: (json['ok'] as num?)?.toInt() ?? 0,
      lastResult: (json['last'] as num?)?.toInt() ?? -1,
    );
  }
}
