import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grit_swap/game/shuffle.dart';
import 'package:grit_swap/models/grid.dart';

void main() {
  test('le mélange à 0 coup renvoie la grille cible telle quelle', () {
    final target = Grid.fromInts([
      [1, 0],
      [0, 1],
    ]);
    final result = shuffle(target, 0);
    expect(result, equals(target));
  });

  test('le mélange à 1 coup change bien la grille', () {
    final target = Grid.fromInts(List.generate(4, (_) => List.filled(4, 0)));
    final result = shuffle(target, 1, random: Random(42));
    expect(result.matches(target), isFalse);
  });

  test('le mélange est reproductible avec la même seed', () {
    final target = Grid.fromInts(List.generate(4, (_) => List.filled(4, 0)));
    final a = shuffle(target, 3, random: Random(7));
    final b = shuffle(target, 3, random: Random(7));
    expect(a, equals(b));
  });
}
