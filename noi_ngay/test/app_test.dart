import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noi_ngay/services/prefs_store.dart';
import 'package:noi_ngay/services/speech.dart';
import 'package:noi_ngay/state/learn_state.dart';
import 'package:noi_ngay/ui/app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Test giao diện ở mức khung: app mở được, bốn tab đều dựng được màn hình gốc,
/// và nút back của hệ thống đưa người dùng về tab đầu thay vì thoát app.
Future<LearnState> _bootState({required bool onboarded}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'onboarded': onboarded,
  });
  final PrefsStore store = await PrefsStore.open();
  return LearnState(store: store, speech: Speech());
}

Future<void> _pump(WidgetTester tester, LearnState state) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<LearnState>.value(
      value: state,
      child: const NoiNgayApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('lần mở đầu hiện màn hình chào mừng, không hỏi tài khoản',
      (WidgetTester tester) async {
    final LearnState state = await _bootState(onboarded: false);
    await _pump(tester, state);

    expect(find.text('Nói Ngay'), findsWidgets);
    expect(find.text('Bắt đầu học'), findsOneWidget);
    // Không có bất kỳ ô nhập tài khoản hay mật khẩu nào.
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('bấm Bắt đầu học là vào thẳng khung bốn tab',
      (WidgetTester tester) async {
    final LearnState state = await _bootState(onboarded: false);
    await _pump(tester, state);

    await tester.tap(find.text('Bắt đầu học'));
    await tester.pumpAndSettle();

    expect(find.text('Hôm nay'), findsWidgets);
    expect(find.text('Chủ đề'), findsWidgets);
    expect(find.text('Luyện tập'), findsWidgets);
    expect(find.text('Cá nhân'), findsWidgets);
  });

  testWidgets('mỗi tab mở được màn hình gốc của nó',
      (WidgetTester tester) async {
    final LearnState state = await _bootState(onboarded: true);
    await _pump(tester, state);

    await tester.tap(find.text('Chủ đề').last);
    await tester.pumpAndSettle();
    expect(find.text('Bài học'), findsWidgets);

    await tester.tap(find.text('Luyện tập').last);
    await tester.pumpAndSettle();
    expect(find.text('Bốn trò luyện'), findsOneWidget);

    await tester.tap(find.text('Cá nhân').last);
    await tester.pumpAndSettle();
    expect(find.text('Tiến độ tổng'), findsOneWidget);

    await tester.tap(find.text('Hôm nay').last);
    await tester.pumpAndSettle();
    expect(find.text('Mục tiêu hôm nay'), findsOneWidget);
  });

  testWidgets('nút back của hệ thống đưa về tab Hôm nay trước khi thoát',
      (WidgetTester tester) async {
    final LearnState state = await _bootState(onboarded: true);
    await _pump(tester, state);

    await tester.tap(find.text('Cá nhân').last);
    await tester.pumpAndSettle();
    expect(find.text('Tiến độ tổng'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Mục tiêu hôm nay'), findsOneWidget);
  });

  testWidgets('mở được một chủ đề và một bài học', (WidgetTester tester) async {
    final LearnState state = await _bootState(onboarded: true);
    await _pump(tester, state);

    await tester.tap(find.text('Chủ đề').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Chào hỏi & bắt chuyện').first);
    await tester.pumpAndSettle();
    expect(find.text('Hội thoại mẫu'), findsOneWidget);

    await tester.tap(find.text('Mở lời').first);
    await tester.pumpAndSettle();
    expect(find.text('Xem đáp án'), findsOneWidget);
  });
}
