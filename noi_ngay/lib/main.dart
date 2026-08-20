import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/prefs_store.dart';
import 'services/speech.dart';
import 'state/learn_state.dart';
import 'ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final PrefsStore store = await PrefsStore.open();
  runApp(
    ChangeNotifierProvider<LearnState>(
      create: (_) => LearnState(store: store, speech: Speech()),
      child: const NoiNgayApp(),
    ),
  );
}
