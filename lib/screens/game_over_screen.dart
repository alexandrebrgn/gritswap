import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/palette.dart';

/// Écran de fin de partie. Se ferme via Navigator.pop en renvoyant
/// 'replay' ou 'menu' à l'appelant (voir game_screen.dart).
class GameOverScreen extends StatelessWidget {
  final int levelReached;

  const GameOverScreen({super.key, required this.levelReached});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                'TEMPS ECOULE !',
                textAlign: TextAlign.center,
                style: GoogleFonts.pressStart2p(fontSize: 18, color: const Color(0xFFFF97A6)),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(color: Palette.panel, border: Border.all(color: Palette.panelBorder, width: 3)),
                child: Column(
                  children: [
                    Text('NIVEAU ATTEINT', style: GoogleFonts.pressStart2p(fontSize: 8, color: Palette.lavender)),
                    const SizedBox(height: 8),
                    Text('$levelReached', style: GoogleFonts.silkscreen(fontWeight: FontWeight.w700, fontSize: 34, color: Palette.gold)),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.of(context).pop('replay'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(color: Palette.gold, border: Border.all(color: Palette.goldBorder, width: 3)),
                  alignment: Alignment.center,
                  child: Text('REJOUER', style: GoogleFonts.pressStart2p(fontSize: 13, color: const Color(0xFF4A2E0A))),
                ),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => Navigator.of(context).pop('menu'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(color: Palette.panel, border: Border.all(color: Palette.panelBorder, width: 3)),
                  alignment: Alignment.center,
                  child: Text('MENU', style: GoogleFonts.pressStart2p(fontSize: 11, color: Palette.cream)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
