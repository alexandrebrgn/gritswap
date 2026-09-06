import 'grid.dart';

/// Un modèle de grille objectif, tel qu'écrit à la main dans un fichier JSON
/// (voir plan.md). Volontairement séparé du numéro de niveau : plusieurs
/// modèles peuvent exister pour une même taille, et le jeu en choisit un au
/// hasard (voir [PatternRepository]).
class LevelPattern {
  final int size;
  final List<List<bool>> targetPattern;

  const LevelPattern({required this.size, required this.targetPattern});

  factory LevelPattern.fromJson(Map<String, dynamic> json) {
    final size = json['size'] as int;
    final rawPattern = json['targetPattern'] as List;
    final pattern = [
      for (final row in rawPattern)
        [for (final v in row as List) v == 1 || v == true],
    ];
    if (pattern.length != size || pattern.any((row) => row.length != size)) {
      throw FormatException(
        'targetPattern ne correspond pas à size=$size',
      );
    }
    return LevelPattern(size: size, targetPattern: pattern);
  }

  Grid toGrid() => Grid(size, targetPattern);
}
