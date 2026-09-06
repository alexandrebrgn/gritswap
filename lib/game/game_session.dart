import 'dart:math';

import 'difficulty.dart';
import 'pattern_repository.dart';
import 'puzzle_round.dart';
import 'shuffle.dart';

/// Enchaîne les niveaux : choisit un modèle de la bonne taille, mélange,
/// gère le chrono (bonus/malus de temps) et la progression de niveau.
///
/// Les valeurs de temps par défaut sont des placeholders — claude.md dit
/// explicitement qu'elles seront réglées ensemble en testant le jeu, donc
/// elles sont injectables plutôt que figées en dur.
class GameSession {
  final PatternRepository patternRepository;
  final Random random;
  final double initialTimeSeconds;
  final double successTimeBonus;
  final double failureTimePenalty;

  int level = 1;
  late double timeRemaining;
  late PuzzleRound currentRound;

  GameSession({
    required this.patternRepository,
    Random? random,
    this.initialTimeSeconds = 60, // TODO: à ajuster ensemble en playtest
    this.successTimeBonus = 10, // TODO: à ajuster ensemble en playtest
    this.failureTimePenalty = 3, // TODO: à ajuster ensemble en playtest
  }) : random = random ?? Random() {
    timeRemaining = initialTimeSeconds;
    _startRound();
  }

  bool get isGameOver => timeRemaining <= 0;

  void _startRound() {
    final config = Difficulty.forLevel(level);
    final pattern = patternRepository.randomForSize(config.gridSize, random: random);
    final target = pattern.toGrid();
    final initialGrid = shuffle(target, config.shuffleMoves, random: random);
    currentRound = PuzzleRound(
      target: target,
      initialGrid: initialGrid,
      movesAllowed: config.shuffleMoves,
    );
  }

  /// Fait avancer le temps de [deltaSeconds] (appelé par le timer de l'UI,
  /// par ex. à chaque frame).
  void tick(double deltaSeconds) {
    if (isGameOver) return;
    timeRemaining -= deltaSeconds;
    if (timeRemaining < 0) timeRemaining = 0;
  }

  /// Joue un coup sur le niveau en cours. Applique automatiquement le
  /// bonus/malus de temps et passe au niveau suivant en cas de réussite.
  RoundOutcome tap(int row, int col) {
    if (isGameOver) return RoundOutcome.pending;

    final outcome = currentRound.tap(row, col);
    switch (outcome) {
      case RoundOutcome.solved:
        timeRemaining += successTimeBonus;
        level++;
        _startRound();
        break;
      case RoundOutcome.failed:
        timeRemaining -= failureTimePenalty;
        if (timeRemaining < 0) timeRemaining = 0;
        break;
      case RoundOutcome.pending:
        break;
    }
    return outcome;
  }
}
