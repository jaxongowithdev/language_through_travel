import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_through_travel/screens/main_shell.dart';
import 'package:language_through_travel/services/storage_service.dart';
import 'package:language_through_travel/services/tts_service.dart';
import 'package:language_through_travel/state/app_state.dart';
import 'package:language_through_travel/widgets/journey_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Điều đáng lo nhất khi thêm thanh tab dưới cùng: mở màn hình con thì thanh
/// tab biến mất, hoặc AppBar mất nút back. Các test dưới đây khoá lại hành vi đó.
///
/// Lưu ý khi đọc test: [IndexedStack] bọc tab không được chọn trong
/// `Visibility.maintain`, nên widget của các tab ẩn **vẫn nằm trong cây**.
/// Vì vậy phải dùng `.hitTestable()` khi muốn kiểm tra "đang nhìn thấy".

/// Thứ tự tab trong [MainShell].
const int kTabJourney = 0;
const int kTabPhrasebook = 1;
const int kTabPractice = 2;
const int kTabGuide = 3;
const int kTabProgress = 4;

Future<void> _pumpShell(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'onboarding_done': true,
    'selected_language': 'en',
  });
  final StorageService storage = await StorageService.create();

  await tester.pumpWidget(
    ChangeNotifierProvider<AppState>(
      create: (_) => AppState(storage: storage, tts: TtsService()),
      child: const MaterialApp(home: MainShell()),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tapTab(WidgetTester tester, int index) async {
  await tester.tap(find.byType(NavigationDestination).at(index));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('màn hình gốc: có thanh tab, chưa có nút back', (
    WidgetTester tester,
  ) async {
    await _pumpShell(tester);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Hành trình của bạn').hitTestable(), findsOneWidget);
    expect(find.byType(BackButton), findsNothing);
  });

  testWidgets('thanh tab có đủ năm tab', (WidgetTester tester) async {
    await _pumpShell(tester);

    expect(find.byType(NavigationDestination), findsNWidgets(5));
  });

  testWidgets('mở chi tiết chặng: thanh tab còn, nút back xuất hiện', (
    WidgetTester tester,
  ) async {
    await _pumpShell(tester);

    await tester.tap(find.byType(JourneyCard).first);
    await tester.pumpAndSettle();

    expect(
      find.byType(NavigationBar),
      findsOneWidget,
      reason: 'thanh tab phải còn khi mở màn hình con',
    );
    expect(
      find.byType(BackButton),
      findsOneWidget,
      reason: 'màn hình con phải có nút back',
    );
    expect(find.text('Flashcard'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Flashcard'), findsNothing);
    expect(find.byType(BackButton), findsNothing);
  });

  testWidgets('đổi tab rồi quay lại: ngăn xếp của tab cũ được giữ nguyên', (
    WidgetTester tester,
  ) async {
    await _pumpShell(tester);

    await tester.tap(find.byType(JourneyCard).first);
    await tester.pumpAndSettle();
    expect(find.byType(BackButton), findsOneWidget);

    await _tapTab(tester, kTabProgress);
    expect(find.text('Theo chặng').hitTestable(), findsOneWidget);

    // Quay lại tab Hành trình: vẫn đang đứng ở màn hình chi tiết chặng.
    await _tapTab(tester, kTabJourney);
    expect(find.text('Flashcard').hitTestable(), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
  });

  testWidgets('mỗi tab mở đúng màn hình gốc của nó', (
    WidgetTester tester,
  ) async {
    await _pumpShell(tester);

    await _tapTab(tester, kTabPhrasebook);
    expect(
      find.text('Tìm câu, nghĩa tiếng Việt hoặc phiên âm…').hitTestable(),
      findsOneWidget,
    );

    await _tapTab(tester, kTabPractice);
    expect(find.text('Trò luyện tập').hitTestable(), findsOneWidget);

    await _tapTab(tester, kTabGuide);
    expect(find.text('Bỏ túi trước chuyến đi').hitTestable(), findsOneWidget);

    await _tapTab(tester, kTabProgress);
    expect(find.text('Huy hiệu').hitTestable(), findsOneWidget);
  });

  testWidgets('Sổ tay lọc được theo từ khoá', (WidgetTester tester) async {
    await _pumpShell(tester);
    await _tapTab(tester, kTabPhrasebook);

    await tester.enterText(find.byType(TextField), 'zzzz-khong-ton-tai');
    await tester.pumpAndSettle();

    expect(find.text('0 kết quả').hitTestable(), findsOneWidget);
  });
}
