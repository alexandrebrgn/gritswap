import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grit_swap/game/pattern_repository.dart';
import 'package:grit_swap/models/level_pattern.dart';

void main() {
  final patterns4 = [
    LevelPattern(
      size: 4,
      targetPattern: List.generate(4, (_) => List.filled(4, true)),
    ),
    LevelPattern(
      size: 4,
      targetPattern: List.generate(4, (_) => List.filled(4, false)),
    ),
  ];
  final patterns5 = [
    LevelPattern(
      size: 5,
      targetPattern: List.generate(5, (_) => List.filled(5, true)),
    ),
  ];

  test('choisit un modèle de la bonne taille', () {
    final repo = PatternRepository([...patterns4, ...patterns5]);
    final picked = repo.randomForSize(5);
    expect(picked.size, 5);
  });

  test('choisit aléatoirement parmi plusieurs modèles de même taille', () {
    final repo = PatternRepository(patterns4);
    final seen = <List<List<bool>>>{};
    for (var i = 0; i < 20; i++) {
      seen.add(repo.randomForSize(4, random: Random(i)).targetPattern);
    }
    expect(seen.length, greaterThan(1));
  });

  test('erreur si aucun modèle disponible pour la taille demandée', () {
    final repo = PatternRepository(patterns4);
    expect(() => repo.randomForSize(6), throwsStateError);
  });
}
