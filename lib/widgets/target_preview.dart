import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/grid.dart';
import '../theme/palette.dart';

/// Petit aperçu non-interactif de la grille objectif, pour que le joueur sache
/// vers quel motif il doit aller (sans ça, le mélange est illisible seul).
class TargetPreview extends StatelessWidget {
  final Grid target;

  const TargetPreview({super.key, required this.target});

  static const _cell = 12.0;
  static const _gap = 2.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Palette.panel,
        border: Border.all(color: Palette.panelBorder, width: 3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'OBJECTIF',
            style: GoogleFonts.pressStart2p(fontSize: 8, color: Palette.lavender),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var r = 0; r < target.size; r++)
                Padding(
                  padding: EdgeInsets.only(bottom: r == target.size - 1 ? 0 : _gap),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var c = 0; c < target.size; c++)
                        Padding(
                          padding: EdgeInsets.only(right: c == target.size - 1 ? 0 : _gap),
                          child: Container(
                            width: _cell,
                            height: _cell,
                            decoration: BoxDecoration(
                              color: target.cellAt(r, c) ? Palette.gold : Palette.teal,
                              border: Border.all(
                                color: target.cellAt(r, c) ? Palette.goldBorder : Palette.tealBorder,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
