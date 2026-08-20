import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import 'guide_screen.dart';
import 'home_screen.dart';
import 'phrasebook_screen.dart';
import 'practice_hub_screen.dart';
import 'progress_screen.dart';

/// Khung chính của app: thanh tab dưới cùng + một [Navigator] riêng cho mỗi tab.
///
/// Mỗi tab giữ ngăn xếp điều hướng riêng, nên khi mở màn hình con (chi tiết
/// chặng, flashcard, hội thoại…) thanh tab vẫn hiển thị **và** AppBar tự sinh
/// nút back. Nếu dùng một Navigator gốc duy nhất thì màn hình con sẽ che mất
/// thanh tab; nếu bỏ Navigator con thì mất nút back.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const int _homeTab = 0;
  static const int _tabCount = 5;

  final List<GlobalKey<NavigatorState>> _navKeys =
      List<GlobalKey<NavigatorState>>.generate(
    _tabCount,
    (int _) => GlobalKey<NavigatorState>(),
  );

  int _index = _homeTab;

  NavigatorState? get _currentNavigator => _navKeys[_index].currentState;

  void _onTabTapped(int index) {
    if (index == _index) {
      // Chạm lại tab đang mở: quay về màn hình gốc của tab đó.
      _navKeys[index].currentState?.popUntil((Route<dynamic> r) => r.isFirst);
      return;
    }
    setState(() => _index = index);
  }

  /// Thứ tự xử lý nút back của hệ thống:
  /// 1. Còn màn hình con trong tab → lùi một bước.
  /// 2. Đang ở gốc của tab khác → về tab Hành trình.
  /// 3. Đang ở gốc tab Hành trình → thoát app.
  void _handleBack() {
    final NavigatorState? nav = _currentNavigator;
    if (nav != null && nav.canPop()) {
      nav.pop();
      return;
    }
    if (_index != _homeTab) {
      setState(() => _index = _homeTab);
      return;
    }
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = context.watch<AppState>();

    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: <Widget>[
            _TabNavigator(
              navigatorKey: _navKeys[0],
              builder: (_) => const HomeScreen(),
            ),
            _TabNavigator(
              navigatorKey: _navKeys[1],
              builder: (_) => const PhrasebookScreen(),
            ),
            _TabNavigator(
              navigatorKey: _navKeys[2],
              builder: (_) => const PracticeHubScreen(),
            ),
            _TabNavigator(
              navigatorKey: _navKeys[3],
              builder: (_) => const GuideScreen(),
            ),
            _TabNavigator(
              navigatorKey: _navKeys[4],
              builder: (_) => const ProgressScreen(),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _onTabTapped,
          destinations: <Widget>[
            const NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map_rounded),
              label: 'Hành trình',
            ),
            const NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book_rounded),
              label: 'Sổ tay',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: state.dueCount > 0,
                label: Text('${state.dueCount}'),
                child: const Icon(Icons.sports_esports_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: state.dueCount > 0,
                label: Text('${state.dueCount}'),
                child: const Icon(Icons.sports_esports_rounded),
              ),
              label: 'Luyện tập',
            ),
            const NavigationDestination(
              icon: Icon(Icons.travel_explore_outlined),
              selectedIcon: Icon(Icons.travel_explore_rounded),
              label: 'Cẩm nang',
            ),
            const NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights_rounded),
              label: 'Tiến độ',
            ),
          ],
        ),
      ),
    );
  }
}

/// Navigator con của một tab. Màn hình gốc do [builder] dựng.
class _TabNavigator extends StatelessWidget {
  const _TabNavigator({required this.navigatorKey, required this.builder});

  final GlobalKey<NavigatorState> navigatorKey;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (RouteSettings settings) => MaterialPageRoute<void>(
        settings: settings,
        builder: builder,
      ),
    );
  }
}
