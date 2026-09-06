import 'package:flutter/material.dart';

import 'screens/game_screen.dart';

void main() {
  runApp(const GritSwapApp());
}

class GritSwapApp extends StatelessWidget {
  const GritSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'GritSwap',
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}
