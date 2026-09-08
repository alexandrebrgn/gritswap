import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/game_session.dart';
import '../game/pattern_source.dart';
import '../game/puzzle_round.dart';
import '../game/session_stats.dart';
import '../theme/palette.dart';
import '../widgets/flip_tile.dart';
import '../widgets/target_preview.dart';
import 'game_over_screen.dart';

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
    _session = GameSession(patternRepository: PatternSource.repository);
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), _onTick);
  }

  void _onTick(Timer timer) {
    if (_session.isGameOver) {
      timer.cancel();
      _goToGameOver();
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

    if (_session.isGameOver) {
      _ticker?.cancel();
      _goToGameOver();
    }
  }

  Future<void> _goToGameOver() async {
    SessionStats.reportGameOver(_session.level);
    final action = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => GameOverScreen(levelReached: _session.level)),
    );
    if (!mounted) return;
    if (action == 'menu') {
      Navigator.of(context).pop();
    } else {
      setState(_startNewSession);
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
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: TargetPreview(target: round.target),
              ),
              const SizedBox(height: 16),
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

