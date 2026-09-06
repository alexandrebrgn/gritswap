import 'package:flutter_test/flutter_test.dart';
import 'package:grit_swap/models/grid.dart';

void main() {
  group('Grid.flip', () {
    test('retourne la cellule centrale et ses 8 voisines', () {
      final grid = Grid.fromInts(List.generate(4, (_) => List.filled(4, 0)));
      final flipped = grid.flip(1, 1);
      final expected = Grid.fromInts([
        [1, 1, 1, 0],
        [1, 1, 1, 0],
        [1, 1, 1, 0],
        [0, 0, 0, 0],
      ]);
      expect(flipped, equals(expected));
    });

    test('retourne seulement 6 cellules sur un bord', () {
      final grid = Grid.fromInts(List.generate(4, (_) => List.filled(4, 0)));
      final flipped = grid.flip(0, 1);
      final expected = Grid.fromInts([
        [1, 1, 1, 0],
        [1, 1, 1, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ]);
      expect(flipped, equals(expected));
    });

    test('retourne seulement 4 cellules dans un coin', () {
      final grid = Grid.fromInts(List.generate(4, (_) => List.filled(4, 0)));
      final flipped = grid.flip(0, 0);
      final expected = Grid.fromInts([
        [1, 1, 0, 0],
        [1, 1, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ]);
      expect(flipped, equals(expected));
    });

    test('un flip appliqué deux fois sur la même case annule le premier', () {
      final grid = Grid.fromInts(List.generate(4, (_) => List.filled(4, 0)));
      final result = grid.flip(2, 2).flip(2, 2);
      expect(result, equals(grid));
    });

    test('flip ne modifie pas la grille d\'origine (immuabilité)', () {
      final grid = Grid.fromInts(List.generate(4, (_) => List.filled(4, 0)));
      final untouched = Grid.fromInts(List.generate(4, (_) => List.filled(4, 0)));
      grid.flip(1, 1);
      expect(grid, equals(untouched));
    });
  });

  group('Grid.matches', () {
    test('deux grilles identiques correspondent', () {
      final a = Grid.fromInts([
        [1, 0],
        [0, 1],
      ]);
      final b = Grid.fromInts([
        [1, 0],
        [0, 1],
      ]);
      expect(a.matches(b), isTrue);
    });

    test('deux grilles différentes ne correspondent pas', () {
      final a = Grid.fromInts([
        [1, 0],
        [0, 1],
      ]);
      final b = Grid.fromInts([
        [1, 1],
        [0, 1],
      ]);
      expect(a.matches(b), isFalse);
    });
  });
}
