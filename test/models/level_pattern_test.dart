import 'package:flutter_test/flutter_test.dart';
import 'package:grit_swap/models/level_pattern.dart';

void main() {
  test('parse un modèle JSON avec des 0/1', () {
    final pattern = LevelPattern.fromJson({
      'size': 4,
      'targetPattern': [
        [1, 1, 1, 1],
        [1, 0, 0, 1],
        [1, 0, 0, 1],
        [1, 1, 1, 1],
      ],
    });

    expect(pattern.size, 4);
    expect(pattern.targetPattern[0], [true, true, true, true]);
    expect(pattern.targetPattern[1], [true, false, false, true]);
  });

  test('rejette un modèle dont la taille ne correspond pas à size', () {
    expect(
      () => LevelPattern.fromJson({
        'size': 4,
        'targetPattern': [
          [1, 1],
          [1, 1],
        ],
      }),
      throwsFormatException,
    );
  });
}
