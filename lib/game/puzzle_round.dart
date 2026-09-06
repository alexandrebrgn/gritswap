import '../models/grid.dart';

enum RoundOutcome {
  /// Il reste des coups à jouer, rien à vérifier pour l'instant.
  pending,

  /// Le dernier coup autorisé a été joué et la grille correspond à l'objectif.
  solved,

  /// Le dernier coup autorisé a été joué et la grille ne correspond pas :
  /// la grille est déjà revenue à son état de départ (`initialGrid`).
  failed,
}

/// Une tentative sur un modèle donné : le joueur dispose exactement de
/// [movesAllowed] coups (le nombre de coups utilisés pour mélanger la
/// grille). La vérification de la réussite n'a lieu qu'après le dernier
/// coup — jamais avant, même si la grille correspond déjà à l'objectif par
/// hasard en cours de route.
///
/// En cas d'échec, la grille revient à son état de départ ([initialGrid],
/// pas l'objectif) et le compteur de coups est remis à zéro : le joueur peut
/// retenter le même modèle. La pénalité de temps sur échec est gérée par
/// l'appelant (session de jeu / timer), pas ici.
class PuzzleRound {
  final Grid target;
  final Grid initialGrid;
  final int movesAllowed;

  Grid currentGrid;
  int movesUsed = 0;

  PuzzleRound({
    required this.target,
    required this.initialGrid,
    required this.movesAllowed,
  }) : currentGrid = initialGrid;

  int get movesRemaining => movesAllowed - movesUsed;

  RoundOutcome tap(int row, int col) {
    currentGrid = currentGrid.flip(row, col);
    movesUsed++;

    if (movesUsed < movesAllowed) {
      return RoundOutcome.pending;
    }

    if (currentGrid.matches(target)) {
      return RoundOutcome.solved;
    }

    currentGrid = initialGrid;
    movesUsed = 0;
    return RoundOutcome.failed;
  }
}
