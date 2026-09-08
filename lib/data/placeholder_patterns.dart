import '../game/pattern_repository.dart';
import '../models/level_pattern.dart';

/// TEMPORAIRE — un seul modèle générique par taille (bordure face, intérieur
/// pile, comme dans ton exemple de claude.md), pour faire tourner et tester
/// l'app en attendant que tu écrives tes vrais modèles.
///
/// Utilisé aussi comme repli par [AssetPatternLoader] pour toute taille dont
/// tu n'as pas encore écrit de vrai modèle.
PatternRepository placeholderPatternRepository() {
  return PatternRepository([
    for (final size in [4, 5, 6]) borderPatternPlaceholder(size),
  ]);
}

LevelPattern borderPatternPlaceholder(int size) {
  final pattern = List.generate(
    size,
    (r) => List.generate(
      size,
      (c) => r == 0 || r == size - 1 || c == 0 || c == size - 1,
    ),
  );
  return LevelPattern(size: size, targetPattern: pattern);
}
