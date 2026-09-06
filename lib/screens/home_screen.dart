import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/session_stats.dart';
import '../theme/palette.dart';
import 'game_screen.dart';
import 'settings_screen.dart';
import 'shop_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'GRITSWAP',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 26,
                        color: Palette.gold,
                        shadows: [
                          Shadow(offset: const Offset(4, 4), color: Palette.goldBorder),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'RETOURNE. MATCHE. SURVIS.',
                      style: GoogleFonts.silkscreen(fontWeight: FontWeight.w700, fontSize: 12, color: Palette.lavender),
                    ),
                    const SizedBox(height: 40),
                    _MenuButton(
                      label: 'JOUER',
                      color: Palette.gold,
                      borderColor: Palette.goldBorder,
                      textColor: const Color(0xFF4A2E0A),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const GameScreen()),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _MenuButton(
                      label: 'BOUTIQUE',
                      color: Palette.panel,
                      borderColor: Palette.panelBorder,
                      textColor: Palette.cream,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ShopScreen()),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: Palette.panel,
                  border: Border.all(color: Palette.panelBorder, width: 3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MEILLEUR NIVEAU',
                      style: GoogleFonts.pressStart2p(fontSize: 8, color: Palette.lavender),
                    ),
                    Text(
                      '${SessionStats.bestLevel}',
                      style: GoogleFonts.silkscreen(fontWeight: FontWeight.w700, fontSize: 18, color: Palette.cream),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Palette.panel,
                    border: Border.all(color: Palette.panelBorder, width: 3),
                  ),
                  child: const Icon(Icons.settings, color: Palette.cream, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _MenuButton({
    required this.label,
    required this.color,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: color, border: Border.all(color: borderColor, width: 3)),
        alignment: Alignment.center,
        child: Text(label, style: GoogleFonts.pressStart2p(fontSize: 13, color: textColor)),
      ),
    );
  }
}
