import 'package:flutter/material.dart';

import 'game/pattern_source.dart';
import 'game/session_stats.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionStats.init();
  await PatternSource.init();
  runApp(const GritSwapApp());
}

class GritSwapApp extends StatelessWidget {
  const GritSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'GritSwap',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
