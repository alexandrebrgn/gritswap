import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grit_swap/game/game_session.dart';
import 'package:grit_swap/game/pattern_repository.dart';
import 'package:grit_swap/game/puzzle_round.dart';
import 'package:grit_swap/models/level_pattern.dart';

/// Cherche, par force brute, la case qui ramène `currentGrid` vers `target`
/// en un seul coup — ne fonctionne que quand `movesAllowed == 1`, ce qui est
/// le cas du niveau 1 (grille 4x4, 1 coup de mélange).
(int, int) _findSolvingTap(PuzzleRound round) {
  final size = round.currentGrid.size;
  for (var r = 0; r < size; r++) {
    for (var c = 0; c < size; c++) {
      if (round.currentGrid.flip(r, c).matches(round.target)) {
        return (r, c);
      }
    }
  }
  throw StateError('Aucun coup ne résout ce mélange en 1 tap');
}

PatternRepository _repository() {
  return PatternRepository([
    for (final size in [4, 5, 6])
      LevelPattern(
        size: size,
        targetPattern: List.generate(size, (_) => List.filled(size, false)),
      ),
  ]);
}

void main() {
  test('démarre au niveau 1 avec le temps initial', () {
    final session = GameSession(
      patternRepository: _repository(),
      random: Random(1),
      initialTimeSeconds: 30,
    );
    expect(session.level, 1);
    expect(session.timeRemaining, 30);
    expect(session.isGameOver, isFalse);
  });

  test('tick fait décroître le temps', () {
    final session = GameSession(
      patternRepository: _repository(),
      random: Random(1),
      initialTimeSeconds: 30,
    );
    session.tick(5);
    expect(session.timeRemaining, 25);
  });

  test('réussir un niveau ajoute le bonus de temps et passe au niveau suivant', () {
    final session = GameSession(
      patternRepository: _repository(),
      random: Random(1),
      initialTimeSeconds: 30,
      successTimeBonus: 10,
    );
    final (row, col) = _findSolvingTap(session.currentRound);

    final outcome = session.tap(row, col);

    expect(outcome, RoundOutcome.solved);
    expect(session.level, 2);
    expect(session.timeRemaining, 40);
  });

  test('rater un niveau retire le malus de temps et garde le même niveau', () {
    final session = GameSession(
      patternRepository: _repository(),
      random: Random(1),
      initialTimeSeconds: 30,
      failureTimePenalty: 3,
    );
    final (goodRow, goodCol) = _findSolvingTap(session.currentRound);
    // On tape volontairement une autre case que la bonne.
    final wrongRow = (goodRow + 1) % session.currentRound.currentGrid.size;

    final outcome = session.tap(wrongRow, goodCol);

    expect(outcome, RoundOutcome.failed);
    expect(session.level, 1);
    expect(session.timeRemaining, 27);
  });

  test('le temps ne descend jamais sous 0 et déclenche la fin de partie', () {
    final session = GameSession(
      patternRepository: _repository(),
      random: Random(1),
      initialTimeSeconds: 5,
    );
    session.tick(999);
    expect(session.timeRemaining, 0);
    expect(session.isGameOver, isTrue);
  });

  test('aucun coup n\'est pris en compte une fois la partie terminée', () {
    final session = GameSession(
      patternRepository: _repository(),
      random: Random(1),
      initialTimeSeconds: 1,
    );
    session.tick(999);
    final levelBefore = session.level;

    final outcome = session.tap(0, 0);

    expect(outcome, RoundOutcome.pending);
    expect(session.level, levelBefore);
  });
}
