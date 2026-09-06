import 'dart:math';

import '../models/level_pattern.dart';

/// Choisit un [LevelPattern] au hasard parmi ceux d'une taille donnée.
///
/// Volontairement indépendant du chargement des fichiers (assets Flutter,
/// réseau, etc.) : cette classe ne connaît qu'une liste de modèles déjà en
/// mémoire, ce qui la rend testable sans dépendre de Flutter. Le chargement
/// réel depuis `assets/patterns/` viendra dans une classe séparée une fois
/// que les fichiers de modèles existeront.
class PatternRepository {
  final List<LevelPattern> _patterns;

  PatternRepository(List<LevelPattern> patterns) : _patterns = patterns;

  LevelPattern randomForSize(int size, {Random? random}) {
    final candidates = _patterns.where((p) => p.size == size).toList();
    if (candidates.isEmpty) {
      throw StateError('Aucun modèle disponible pour une grille ${size}x$size');
    }
    final rng = random ?? Random();
    return candidates[rng.nextInt(candidates.length)];
  }
}
