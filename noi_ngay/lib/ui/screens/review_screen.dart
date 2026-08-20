import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/spoken_line.dart';
import '../../state/learn_state.dart';
import '../../theme/palette.dart';
import 'lesson_screen.dart';

/// Phiên ôn tập các câu đã tới hạn.
///
/// Danh sách câu được chốt một lần khi mở màn hình. Nếu lấy lại danh sách sau
/// mỗi lần chấm thì câu vừa chấm "Chưa nhớ" sẽ nhảy vào giữa phiên và người học
/// không bao giờ thấy phiên kết thúc.
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key, this.limit = 20});

  final int limit;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late final List<SpokenLine> _lines;

  @override
  void initState() {
    super.initState();
    final List<SpokenLine> due = context.read<LearnState>().dueLines;
    _lines = due.take(widget.limit).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LessonScreen.fromLines(
      title: 'Phiên ôn tập',
      lines: _lines,
      tint: Palette.rose,
    );
  }
}
