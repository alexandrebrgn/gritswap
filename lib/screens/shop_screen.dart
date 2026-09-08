import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/palette.dart';

/// Boutique — pour l'instant purement visuelle : pas de monnaie ni d'achat
/// réel branché (ça viendra avec le système de monnaie, une évolution
/// post-MVP). Sert à valider la navigation et l'habillage.
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const skins = [
      (name: 'CLASSIQUE', face: Palette.gold, faceBorder: Palette.goldBorder, pile: Palette.teal, pileBorder: Palette.tealBorder, owned: true),
      (name: 'CORAIL', face: Color(0xFFFF8C6B), faceBorder: Color(0xFFA34C2E), pile: Color(0xFF4A2159), pileBorder: Color(0xFF250F2E), owned: false),
      (name: 'FORET', face: Color(0xFF9BD65C), faceBorder: Color(0xFF567A2E), pile: Color(0xFF3B2A1A), pileBorder: Color(0xFF1E150C), owned: false),
      (name: 'NEON', face: Color(0xFFFF3E9A), faceBorder: Color(0xFFA3155E), pile: Color(0xFF0E4A47), pileBorder: Color(0xFF062522), owned: false),
    ];

    return Scaffold(
      backgroundColor: Palette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(color: Palette.panel, border: Border.all(color: Palette.panelBorder, width: 3)),
                      child: const Icon(Icons.arrow_back, color: Palette.cream, size: 18),
                    ),
                  ),
                  Text('BOUTIQUE', style: GoogleFonts.pressStart2p(fontSize: 14, color: Palette.gold)),
                  const SizedBox(width: 38),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: skins.length,
                  itemBuilder: (context, index) {
                    final skin = skins[index];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Palette.panel, border: Border.all(color: Palette.panelBorder, width: 3)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Taille fixe (au lieu d'une GridView imbriquée) pour
                          // éviter tout overflow dans la carte.
                          SizedBox(
                            width: 56,
                            height: 56,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(child: Container(color: skin.face)),
                                      const SizedBox(width: 3),
                                      Expanded(child: Container(color: skin.pile)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(child: Container(color: skin.pile)),
                                      const SizedBox(width: 3),
                                      Expanded(child: Container(color: skin.face)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(skin.name, style: GoogleFonts.silkscreen(fontWeight: FontWeight.w700, fontSize: 12, color: Palette.cream)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            color: const Color(0xFF1C1938),
                            child: Text(
                              skin.owned ? 'EQUIPE' : '---',
                              style: GoogleFonts.pressStart2p(fontSize: 7, color: skin.owned ? const Color(0xFF7CE3A0) : Palette.lavender),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
