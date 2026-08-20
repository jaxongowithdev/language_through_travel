import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/learn_state.dart';
import '../widgets/aurora_background.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

/// Cài đặt: mục tiêu ngày, giao diện, tốc độ đọc và nút đặt lại tiến độ.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const List<int> _goals = <int>[6, 12, 20, 30, 45];

  Future<void> _confirmReset(BuildContext context) async {
    final bool? yes = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Đặt lại toàn bộ tiến độ?'),
        content: const Text(
          'Thao tác này xoá lịch ôn, câu đã lưu, cột mốc và kỷ lục các trò '
          'chơi trên máy này. Nội dung bài học vẫn giữ nguyên. Không thể hoàn '
          'tác.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Huỷ'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Đặt lại'),
          ),
        ],
      ),
    );
    if (yes != true || !context.mounted) return;
    await context.read<LearnState>().resetEverything();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã đặt lại tiến độ trên máy này.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.watch<LearnState>();

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 18, 8),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    Expanded(
                      child: Text('Cài đặt',
                          style: theme.textTheme.titleLarge),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                  children: <Widget>[
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Mục tiêu mỗi ngày',
                              style: theme.textTheme.titleMedium),
                          const SizedBox(height: 6),
                          Text(
                            'Số câu bạn muốn ôn trong một ngày. Vòng tròn ở '
                            'tab Hôm nay đo theo con số này.',
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: <Widget>[
                              for (final int goal in _goals)
                                ChoiceChip(
                                  label: Text('$goal câu'),
                                  selected: state.dailyGoal == goal,
                                  onSelected: (_) => state.setDailyGoal(goal),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            value: state.darkMode,
                            onChanged: state.setDarkMode,
                            title: const Text('Giao diện tối'),
                            subtitle: const Text(
                              'Tắt để chuyển sang nền sáng.',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Tốc độ đọc',
                              style: theme.textTheme.titleMedium),
                          const SizedBox(height: 6),
                          Text(
                            'Áp dụng cho mọi nút loa trong app.',
                            style: theme.textTheme.bodySmall,
                          ),
                          Slider(
                            value: state.speechRate,
                            min: 0.25,
                            max: 0.7,
                            divisions: 9,
                            label: state.speechRate < 0.38
                                ? 'Chậm'
                                : state.speechRate < 0.55
                                    ? 'Vừa'
                                    : 'Nhanh',
                            onChanged: state.setSpeechRate,
                          ),
                          const SizedBox(height: 4),
                          OutlinedButton.icon(
                            onPressed: () => state.say(
                              'This is how fast I will read your sentences.',
                            ),
                            icon: const Icon(Icons.volume_up_rounded, size: 18),
                            label: const Text('Nghe thử'),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Nút loa dùng giọng đọc cài sẵn của hệ điều hành. '
                            'Nếu máy chưa có giọng tiếng Anh thì nút sẽ im '
                            'lặng thay vì báo lỗi; cài giọng trong phần Trợ '
                            'năng của máy là chạy được.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Dữ liệu của bạn',
                              style: theme.textTheme.titleMedium),
                          const SizedBox(height: 6),
                          Text(
                            'Toàn bộ tiến độ nằm trên máy này và không được '
                            'gửi đi đâu. App không có tài khoản nên cũng không '
                            'có gì để xoá trên máy chủ.',
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 14),
                          OutlinedButton.icon(
                            onPressed: () => _confirmReset(context),
                            icon: const Icon(Icons.delete_outline_rounded,
                                size: 18),
                            label: const Text('Đặt lại tiến độ'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const EmptyHint(
                      icon: Icons.wifi_off_rounded,
                      title: 'Không cần mạng',
                      body: 'Mọi bài học, sổ tay và trò chơi đều chạy được ở '
                          'chế độ máy bay.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
