import '../game/pattern_repository.dart';
import '../models/level_pattern.dart';

/// TEMPORAIRE — un seul modèle générique par taille (bordure face, intérieur
/// pile, comme dans ton exemple de claude.md), juste pour pouvoir faire
/// tourner et tester l'app en attendant que tu écrives tes vrais modèles.
///
/// À remplacer par un `PatternRepository` alimenté depuis `assets/patterns/`
/// une fois que tes fichiers JSON existeront.
PatternRepository placeholderPatternRepository() {
  return PatternRepository([
    for (final size in [4, 5, 6]) _borderPattern(size),
  ]);
}

LevelPattern _borderPattern(int size) {
  final pattern = List.generate(
    size,
    (r) => List.generate(
      size,
      (c) => r == 0 || r == size - 1 || c == 0 || c == size - 1,
    ),
  );
  return LevelPattern(size: size, targetPattern: pattern);
}
