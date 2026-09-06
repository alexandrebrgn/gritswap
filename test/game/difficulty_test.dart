import 'package:flutter_test/flutter_test.dart';
import 'package:grit_swap/game/difficulty.dart';

void main() {
  test('niveau 1 est une grille 4x4 avec 1 coup de mélange', () {
    final config = Difficulty.forLevel(1);
    expect(config.gridSize, 4);
    expect(config.shuffleMoves, 1);
  });

  test('niveau 6 passe en grille 5x5', () {
    expect(Difficulty.forLevel(6).gridSize, 5);
  });

  test('niveau 16 revient en 4x4 avec 3 coups de mélange', () {
    final config = Difficulty.forLevel(16);
    expect(config.gridSize, 4);
    expect(config.shuffleMoves, 3);
  });

  test('au-delà du niveau 18, on répète le dernier palier connu', () {
    final config = Difficulty.forLevel(50);
    expect(config.gridSize, 4);
    expect(config.shuffleMoves, 3);
  });
}
