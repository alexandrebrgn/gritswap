import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:grit_swap/main.dart';

void main() {
  setUpAll(() {
    // Évite que les tests essaient de télécharger les polices Google Fonts.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('affiche le niveau 1 avec une grille 4x4 tapable', (WidgetTester tester) async {
    await tester.pumpWidget(const GritSwapApp());
    await tester.pump();

    expect(find.text('NIVEAU 1'), findsOneWidget);
    expect(find.text('COUPS RESTANTS : 1'), findsOneWidget);
    expect(find.byType(GestureDetector), findsNWidgets(16));

    // Démonte l'écran pour annuler proprement le timer du chrono avant la fin du test.
    await tester.pumpWidget(const SizedBox());
  });
}
