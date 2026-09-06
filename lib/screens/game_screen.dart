import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/placeholder_patterns.dart';
import '../game/game_session.dart';
import '../game/puzzle_round.dart';
import '../theme/palette.dart';
import '../widgets/flip_tile.dart';

/// Écran de jeu statique : affiche la grille courante et la relie à
/// [GameSession]. Pas d'animation pour l'instant (viendra plus tard) — le
/// tap change juste l'état affiché immédiatement.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameSession _session;
  Timer? _ticker;
  (int, int)? _lastTap;

  @override
  void initState() {
    super.initState();
    _startNewSession();
  }

  void _startNewSession() {
    _session = GameSession(patternRepository: placeholderPatternRepository());
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), _onTick);
  }

  void _onTick(Timer timer) {
    if (_session.isGameOver) {
      timer.cancel();
      setState(() {});
      return;
    }
    setState(() => _session.tick(0.1));
  }

  void _handleTap(int row, int col) {
    if (_session.isGameOver) return;
    final outcome = _session.tap(row, col);
    setState(() => _lastTap = (row, col));

    final message = switch (outcome) {
      RoundOutcome.solved => 'Niveau ${_session.level - 1} réussi !',
      RoundOutcome.failed => 'Raté ! Retour au mélange de départ.',
      RoundOutcome.pending => null,
    };
    if (message != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(message, style: GoogleFonts.silkscreen(fontWeight: FontWeight.w700)),
          backgroundColor: outcome == RoundOutcome.solved ? Palette.gold : Palette.danger,
          duration: const Duration(milliseconds: 700),
        ));
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final round = _session.currentRound;
    final size = round.currentGrid.size;

    return Scaffold(
      backgroundColor: Palette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _Header(session: _session),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: size,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                      ),
                      itemCount: size * size,
                      itemBuilder: (context, index) {
                        final row = index ~/ size;
                        final col = index % size;
                        final isFace = round.currentGrid.cellAt(row, col);
                        return FlipTile(
                          // La clé inclut le niveau : un nouveau niveau remonte
                          // des tuiles fraîches (pas d'animation sur le nouveau
                          // mélange), alors qu'un coup joué dans le même niveau
                          // anime bien la transition.
                          key: ValueKey('${_session.level}_${row}_$col'),
                          isFace: isFace,
                          row: row,
                          col: col,
                          lastTap: _lastTap,
                          onTap: () => _handleTap(row, col),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_session.isGameOver)
                _GameOverBanner(
                  session: _session,
                  onRestart: () => setState(_startNewSession),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final GameSession session;

  const _Header({required this.session});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NIVEAU ${session.level}',
              style: GoogleFonts.pressStart2p(fontSize: 10, color: Palette.gold),
            ),
            const SizedBox(height: 6),
            Text(
              'COUPS RESTANTS : ${session.currentRound.movesRemaining}',
              style: GoogleFonts.silkscreen(fontWeight: FontWeight.w700, fontSize: 13, color: Palette.cream),
            ),
          ],
        ),
        Text(
          '${session.timeRemaining.toStringAsFixed(1)} s',
          style: GoogleFonts.pressStart2p(fontSize: 16, color: Palette.cream),
        ),
      ],
    );
  }
}

class _GameOverBanner extends StatelessWidget {
  final GameSession session;
  final VoidCallback onRestart;

  const _GameOverBanner({required this.session, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Palette.panel,
        border: Border.all(color: Palette.panelBorder, width: 3),
      ),
      child: Column(
        children: [
          Text(
            'TEMPS ECOULE !',
            style: GoogleFonts.pressStart2p(fontSize: 14, color: Palette.danger),
          ),
          const SizedBox(height: 10),
          Text(
            'Niveau atteint : ${session.level}',
            style: GoogleFonts.silkscreen(fontWeight: FontWeight.w700, fontSize: 14, color: Palette.cream),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onRestart,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              width: double.infinity,
              color: Palette.gold,
              alignment: Alignment.center,
              child: Text(
                'REJOUER',
                style: GoogleFonts.pressStart2p(fontSize: 12, color: const Color(0xFF4A2E0A)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
