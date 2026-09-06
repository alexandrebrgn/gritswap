import 'package:flutter_test/flutter_test.dart';
import 'package:grit_swap/game/puzzle_round.dart';
import 'package:grit_swap/models/grid.dart';

void main() {
  test('réussit quand le dernier coup autorisé ramène à l\'objectif', () {
    final target = Grid.fromInts(List.generate(4, (_) => List.filled(4, 0)));
    final initial = target.flip(1, 1); // mélange à 1 coup
    final round = PuzzleRound(target: target, initialGrid: initial, movesAllowed: 1);

    final outcome = round.tap(1, 1); // annule exactement le mélange

    expect(outcome, RoundOutcome.solved);
    expect(round.currentGrid, equals(target));
  });

  test('échoue et revient au mélange de départ si le dernier coup ne correspond pas', () {
    final target = Grid.fromInts(List.generate(4, (_) => List.filled(4, 0)));
    final initial = target.flip(1, 1);
    final round = PuzzleRound(target: target, initialGrid: initial, movesAllowed: 1);

    final outcome = round.tap(3, 3); // mauvaise case

    expect(outcome, RoundOutcome.failed);
    expect(round.currentGrid, equals(initial));
    expect(round.movesUsed, 0);
  });

  test('ne vérifie rien avant le dernier coup autorisé, même si ça matche par hasard', () {
    final target = Grid.fromInts(List.generate(4, (_) => List.filled(4, 0)));
    final initial = target.flip(0, 0).flip(3, 3); // mélange à 2 coups
    final round = PuzzleRound(target: target, initialGrid: initial, movesAllowed: 2);

    // Ce tap ramène la grille à l'objectif après 1 seul coup...
    final outcome = round.tap(0, 0);

    // ...mais comme il reste un coup à jouer, ce n'est pas encore vérifié.
    expect(outcome, RoundOutcome.pending);
    expect(round.movesRemaining, 1);
  });

  test('movesRemaining décompte correctement', () {
    final target = Grid.fromInts(List.generate(4, (_) => List.filled(4, 0)));
    final initial = target.flip(0, 0).flip(3, 3);
    final round = PuzzleRound(target: target, initialGrid: initial, movesAllowed: 2);

    expect(round.movesRemaining, 2);
    round.tap(1, 1);
    expect(round.movesRemaining, 1);
  });

  test('peut retenter le même modèle après un échec', () {
    final target = Grid.fromInts(List.generate(4, (_) => List.filled(4, 0)));
    final initial = target.flip(1, 1);
    final round = PuzzleRound(target: target, initialGrid: initial, movesAllowed: 1);

    round.tap(3, 3); // échec, reset
    final outcome = round.tap(1, 1); // bon coup cette fois

    expect(outcome, RoundOutcome.solved);
  });
}
