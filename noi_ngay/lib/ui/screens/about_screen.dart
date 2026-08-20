import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/library.dart';
import '../../state/learn_state.dart';
import '../../theme/palette.dart';
import '../widgets/aurora_background.dart';
import '../widgets/glass_card.dart';

/// Trang giới thiệu app.
///
/// Trang này viết cho hai người đọc cùng lúc: người dùng muốn biết app có gì,
/// và người duyệt ứng dụng muốn biết app làm gì, lấy dữ liệu ở đâu và có thu
/// thập gì không. Mọi con số đều lấy thẳng từ kho nội dung nên không bao giờ
/// lệch với thực tế trong app.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Library library = context.read<LearnState>().library;

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
                      child: Text('Về ứng dụng',
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
                          Text('Nói Ngay',
                              style: theme.textTheme.headlineSmall),
                          const SizedBox(height: 4),
                          Text('Phiên bản 1.0.0',
                              style: theme.textTheme.bodySmall),
                          const SizedBox(height: 12),
                          Text(
                            'Nói Ngay giúp người Việt luyện phản xạ nói tiếng '
                            'Anh trong những tình huống lặp lại mỗi ngày: chào '
                            'hỏi, công sở, mua sắm, gọi điện, đi khám, phỏng '
                            'vấn. Mỗi câu học theo chiều Việt sang Anh để bạn '
                            'phải tự bật ra câu, chứ không chỉ đọc hiểu.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _Block(
                      icon: Icons.inventory_2_rounded,
                      tint: Palette.cyan,
                      title: 'Nội dung trong app',
                      lines: <String>[
                        '${library.topics.length} chủ đề, mỗi chủ đề ba bài học',
                        '${library.lineCount} câu giao tiếp kèm nghĩa và mẹo dùng',
                        '${library.allConversations.length} đoạn hội thoại mẫu, '
                            '${library.conversationTurnCount} lượt nói',
                        '${library.wordCount} từ vựng kèm phiên âm IPA và ví dụ',
                        '${library.referenceCount} mục sổ tay tra cứu',
                        '${library.tips.length} mẹo học, mỗi ngày một mẹo',
                        'Tổng cộng ${library.totalItemCount} mục nội dung',
                      ],
                    ),
                    const SizedBox(height: 14),
                    _Block(
                      icon: Icons.school_rounded,
                      tint: Palette.violet,
                      title: 'Cách app dạy',
                      lines: <String>[
                        'Bài học hỏi ngược: thấy tiếng Việt, tự nói tiếng Anh',
                        'Hệ thống hộp Leitner năm ngăn với lịch cố định '
                            'không ngày, một ngày, ba ngày, bảy ngày, mười sáu ngày',
                        'Bốn trò luyện: điền từ, sắp xếp câu, nghe chọn, ghép '
                            'nghĩa 60 giây',
                        'Chế độ nhại theo với tốc độ đọc chỉnh được',
                        'Không có nội dung nào bị khoá, học theo thứ tự nào '
                            'cũng được',
                      ],
                    ),
                    const SizedBox(height: 14),
                    _Block(
                      icon: Icons.lock_rounded,
                      tint: Palette.mint,
                      title: 'Quyền riêng tư',
                      lines: <String>[
                        'App không yêu cầu tài khoản và không có đăng nhập',
                        'App không thực hiện bất kỳ kết nối mạng nào',
                        'Tiến độ lưu trong bộ nhớ cục bộ của máy, xoá được '
                            'trong phần Cài đặt',
                        'Không có quảng cáo, không có mua trong ứng dụng',
                        'Không xin quyền vị trí, danh bạ, máy ảnh, ảnh hay '
                            'thông báo',
                        'Không có nội dung do người dùng đăng tải',
                      ],
                    ),
                    const SizedBox(height: 14),
                    _Block(
                      icon: Icons.record_voice_over_rounded,
                      tint: Palette.amber,
                      title: 'Về giọng đọc',
                      lines: <String>[
                        'Nút loa dùng bộ đọc có sẵn của hệ điều hành',
                        'App không ghi âm và không dùng micrô',
                        'Nếu máy chưa cài giọng tiếng Anh, nút loa im lặng '
                            'thay vì báo lỗi',
                      ],
                    ),
                    const SizedBox(height: 14),
                    _Block(
                      icon: Icons.copyright_rounded,
                      tint: Palette.fuchsia,
                      title: 'Bản quyền nội dung',
                      lines: <String>[
                        'Toàn bộ câu, hội thoại, ví dụ và phần giải thích do '
                            'đội ngũ Nói Ngay tự biên soạn',
                        'Không sử dụng giáo trình, nhãn hiệu hay hình ảnh của '
                            'bên thứ ba',
                        'Biểu tượng và hình minh hoạ đều do chúng tôi tạo ra',
                      ],
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

class _Block extends StatelessWidget {
  const _Block({
    required this.icon,
    required this.tint,
    required this.title,
    required this.lines,
  });

  final IconData icon;
  final Color tint;
  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      tint: tint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: tint, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, style: theme.textTheme.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final String line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: tint,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(line, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
