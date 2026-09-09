import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/game_session.dart';
import '../game/pattern_source.dart';
import '../game/puzzle_round.dart';
import '../game/session_stats.dart';
import '../models/grid.dart';
import '../theme/palette.dart';
import '../widgets/flip_tile.dart';
import '../widgets/target_preview.dart';
import 'game_over_screen.dart';

/// Écran de jeu : affiche la grille courante, reliée à [GameSession].
///
/// Le dernier coup d'un niveau (réussite ou échec) déclenche une transition
/// (nouveau niveau / retour au mélange de départ) — on garde l'affichage figé
/// sur l'état juste après ce coup le temps que l'animation de retournement se
/// joue, avant de révéler la suite. Sans ça, la transition (qui se produit
/// au même instant dans GameSession) court-circuite l'animation.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

enum _TransitionPhase { none, squish, exit, enter }

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late GameSession _session;
  late AnimationController _phaseController;
  Timer? _ticker;
  (int, int)? _lastTap;
  int _tileEpoch = 0;
  bool _gameOverHandled = false;
  _TransitionPhase _phase = _TransitionPhase.none;

  // Snapshot du round/grille/niveau à afficher pendant qu'on attend la fin
  // de l'animation du dernier coup ; null = affichage normal (live).
  ({PuzzleRound round, Grid grid, int level})? _transition;

  @override
  void initState() {
    super.initState();
    _phaseController = AnimationController(vsync: this);
    _startNewSession();
  }

  void _startNewSession() {
    _session = GameSession(patternRepository: PatternSource.repository);
    _tileEpoch++;
    _transition = null;
    _phase = _TransitionPhase.none;
    _gameOverHandled = false;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), _onTick);
  }

  void _onTick(Timer timer) {
    if (_session.isGameOver) {
      timer.cancel();
      _handleGameOver();
      return;
    }
    setState(() => _session.tick(0.1));
  }

  Future<void> _handleTap(int row, int col) async {
    if (_session.isGameOver || _transition != null || _phase != _TransitionPhase.none) return;

    final round = _session.currentRound;
    final flippedGrid = round.currentGrid.flip(row, col);
    final outcome = _session.tap(row, col);

    setState(() {
      _lastTap = (row, col);
      if (outcome != RoundOutcome.pending) {
        _transition = (
          round: round,
          grid: flippedGrid,
          level: outcome == RoundOutcome.solved ? _session.level - 1 : _session.level,
        );
      }
    });

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

    if (outcome == RoundOutcome.pending) return;

    // Laisse le temps au flip (+ décalage sur la case la plus loin) de jouer.
    final flipHold = FlipTile.flipDuration + FlipTile.staggerStep * (flippedGrid.size - 1);
    await Future.delayed(flipHold);
    if (!mounted) return;

    if (outcome == RoundOutcome.solved) {
      await _playSolveTransition();
    } else {
      // Échec : pause courte puis la grille revient au mélange de départ —
      // le retour est déjà animé par FlipTile (même clé, comparaison des états).
      await Future.delayed(const Duration(milliseconds: 150));
      if (!mounted) return;
      setState(() => _transition = null);
    }

    if (_session.isGameOver) {
      _ticker?.cancel();
      _handleGameOver();
    }
  }

  /// Le puzzle résolu se tasse puis rebondit, glisse vers le bas et sort de
  /// l'écran (ease-in), puis le niveau suivant tombe depuis le haut (ease-out).
  Future<void> _playSolveTransition() async {
    setState(() => _phase = _TransitionPhase.squish);
    _phaseController.duration = const Duration(milliseconds: 180);
    await _phaseController.forward(from: 0);
    if (!mounted) return;

    setState(() => _phase = _TransitionPhase.exit);
    _phaseController.duration = const Duration(milliseconds: 260);
    await _phaseController.forward(from: 0);
    if (!mounted) return;

    setState(() {
      _transition = null;
      _tileEpoch++;
      _phase = _TransitionPhase.enter;
    });
    _phaseController.duration = const Duration(milliseconds: 320);
    await _phaseController.forward(from: 0);
    if (!mounted) return;

    setState(() => _phase = _TransitionPhase.none);
  }

  Widget _applyPhaseTransform(Widget child) {
    final t = _phaseController.value;
    switch (_phase) {
      case _TransitionPhase.squish:
        final scale = t < 0.5 ? _lerp(1.0, 0.9, t / 0.5) : _lerp(0.9, 1.0, (t - 0.5) / 0.5);
        return Transform.scale(scale: scale, child: child);
      case _TransitionPhase.exit:
        final curved = Curves.easeIn.transform(t);
        return FractionalTranslation(translation: Offset(0, curved), child: child);
      case _TransitionPhase.enter:
        final curved = Curves.easeOut.transform(t);
        return FractionalTranslation(translation: Offset(0, _lerp(-1.0, 0.0, curved)), child: child);
      case _TransitionPhase.none:
        return child;
    }
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  void _handleGameOver() {
    if (_gameOverHandled) return;
    _gameOverHandled = true;
    _goToGameOver();
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
    _phaseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final liveRound = _session.currentRound;
    final displayRound = _transition?.round ?? liveRound;
    final displayGrid = _transition?.grid ?? liveRound.currentGrid;
    final displayLevel = _transition?.level ?? _session.level;
    final displayMovesRemaining = _transition != null ? 0 : liveRound.movesRemaining;
    final size = displayGrid.size;

    return Scaffold(
      backgroundColor: Palette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _Header(
                level: displayLevel,
                movesRemaining: displayMovesRemaining,
                timeRemaining: _session.timeRemaining,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: TargetPreview(target: displayRound.target),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: AnimatedBuilder(
                      animation: _phaseController,
                      builder: (context, child) => _applyPhaseTransform(child!),
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
                          final isFace = displayGrid.cellAt(row, col);
                          return FlipTile(
                            // La clé ne change que sur un vrai nouveau mélange
                            // (après la réussite d'un niveau) : un coup joué
                            // dans le même niveau, ou le retour en arrière sur
                            // échec, réutilise les mêmes tuiles et anime.
                            key: ValueKey('${_tileEpoch}_${row}_$col'),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final int level;
  final int movesRemaining;
  final double timeRemaining;

  const _Header({required this.level, required this.movesRemaining, required this.timeRemaining});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NIVEAU $level',
              style: GoogleFonts.pressStart2p(fontSize: 10, color: Palette.gold),
            ),
            const SizedBox(height: 6),
            Text(
              'COUPS RESTANTS : $movesRemaining',
              style: GoogleFonts.silkscreen(fontWeight: FontWeight.w700, fontSize: 13, color: Palette.cream),
            ),
          ],
        ),
        Text(
          '${timeRemaining.toStringAsFixed(1)} s',
          style: GoogleFonts.pressStart2p(fontSize: 16, color: Palette.cream),
        ),
      ],
    );
  }
}
