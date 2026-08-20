import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/library.dart';
import '../../state/learn_state.dart';
import '../../theme/palette.dart';
import '../widgets/aurora_background.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

/// Màn hình chào mừng, hiện đúng một lần ở lần mở app đầu tiên.
///
/// Không có đăng ký, không có đăng nhập, không hỏi quyền nào. Người dùng chỉ
/// chọn mục tiêu mỗi ngày rồi vào thẳng nội dung — toàn bộ hai mươi chủ đề đều
/// mở sẵn ngay từ giây đầu tiên.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _goal = 12;

  static const List<int> _goalOptions = <int>[6, 12, 20, 30];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Library library = Library.instance;

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
            children: <Widget>[
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: Palette.brandGradient,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Palette.fuchsia.withValues(alpha: 0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.graphic_eq_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 24),
              Text('Nói Ngay', style: theme.textTheme.displaySmall),
              const SizedBox(height: 8),
              Text(
                'Luyện phản xạ tiếng Anh giao tiếp bằng những câu bạn thật sự '
                'dùng trong ngày — không cần tài khoản, không cần mạng.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Trong app có sẵn', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 14),
                    _FactRow(
                      icon: Icons.grid_view_rounded,
                      tint: Palette.cyan,
                      text: '${library.topics.length} chủ đề, '
                          '${library.lineCount} câu giao tiếp có mẹo dùng',
                    ),
                    const SizedBox(height: 10),
                    _FactRow(
                      icon: Icons.forum_rounded,
                      tint: Palette.violet,
                      text: '${library.allConversations.length} đoạn hội thoại '
                          'mẫu và ${library.wordCount} từ vựng kèm IPA',
                    ),
                    const SizedBox(height: 10),
                    _FactRow(
                      icon: Icons.menu_book_rounded,
                      tint: Palette.amber,
                      text: '${library.referenceCount} mục sổ tay: ngữ pháp, '
                          'cụm động từ, thành ngữ, động từ bất quy tắc, bảng âm',
                    ),
                    const SizedBox(height: 10),
                    _FactRow(
                      icon: Icons.wifi_off_rounded,
                      tint: Palette.mint,
                      text: 'Chạy hoàn toàn ngoại tuyến, tiến độ chỉ nằm trên '
                          'máy bạn',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Mỗi ngày bạn muốn ôn bao nhiêu câu?',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Đổi lại bất cứ lúc nào trong tab Cá nhân.',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        for (final int option in _goalOptions)
                          ChoiceChip(
                            selected: _goal == option,
                            onSelected: (_) => setState(() => _goal = option),
                            label: Text('$option câu'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GradientButton(
                label: 'Bắt đầu học',
                icon: Icons.arrow_forward_rounded,
                onPressed: () async {
                  final LearnState state = context.read<LearnState>();
                  await state.setDailyGoal(_goal);
                  await state.completeOnboarding();
                },
              ),
              const SizedBox(height: 14),
              Text(
                'Nội dung do đội ngũ Nói Ngay biên soạn. App không thu thập dữ '
                'liệu, không có quảng cáo và không có mua trong ứng dụng.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({
    required this.icon,
    required this.tint,
    required this.text,
  });

  final IconData icon;
  final Color tint;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: tint.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 16, color: tint),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
