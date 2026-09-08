import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:grit_swap/game/pattern_source.dart';
import 'package:grit_swap/main.dart';
import 'package:grit_swap/widgets/flip_tile.dart';

void main() {
  setUpAll(() async {
    // Évite que les tests essaient de télécharger les polices Google Fonts.
    GoogleFonts.config.allowRuntimeFetching = false;
    await PatternSource.init();
  });

  testWidgets('le menu affiche le logo et permet de lancer une partie', (WidgetTester tester) async {
    await tester.pumpWidget(const GritSwapApp());
    await tester.pump();

    expect(find.text('GRITSWAP'), findsOneWidget);

    await tester.tap(find.text('JOUER'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300)); // laisse la transition de page se terminer

    expect(find.text('NIVEAU 1'), findsOneWidget);
    expect(find.byType(FlipTile), findsNWidgets(16));

    // Démonte l'écran pour annuler proprement le timer du chrono avant la fin du test.
    await tester.pumpWidget(const SizedBox());
  });
}
