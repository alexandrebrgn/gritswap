/// Taille de grille et nombre de coups de mélange pour un niveau donné.
class LevelConfig {
  final int gridSize;
  final int shuffleMoves;

  const LevelConfig({required this.gridSize, required this.shuffleMoves});
}

/// Table de progression telle que définie dans claude.md (niveaux 1 à 18).
/// La suite au-delà du niveau 18 n'est pas encore décidée : on répète le
/// dernier palier en attendant.
class Difficulty {
  static const List<LevelConfig> _table = [
    LevelConfig(gridSize: 4, shuffleMoves: 1), // niveau 1
    LevelConfig(gridSize: 4, shuffleMoves: 1), // niveau 2
    LevelConfig(gridSize: 4, shuffleMoves: 1), // niveau 3
    LevelConfig(gridSize: 4, shuffleMoves: 2), // niveau 4
    LevelConfig(gridSize: 4, shuffleMoves: 2), // niveau 5
    LevelConfig(gridSize: 5, shuffleMoves: 1), // niveau 6
    LevelConfig(gridSize: 5, shuffleMoves: 1), // niveau 7
    LevelConfig(gridSize: 5, shuffleMoves: 1), // niveau 8
    LevelConfig(gridSize: 5, shuffleMoves: 2), // niveau 9
    LevelConfig(gridSize: 5, shuffleMoves: 2), // niveau 10
    LevelConfig(gridSize: 6, shuffleMoves: 1), // niveau 11
    LevelConfig(gridSize: 6, shuffleMoves: 1), // niveau 12
    LevelConfig(gridSize: 6, shuffleMoves: 1), // niveau 13
    LevelConfig(gridSize: 6, shuffleMoves: 2), // niveau 14
    LevelConfig(gridSize: 6, shuffleMoves: 2), // niveau 15
    LevelConfig(gridSize: 4, shuffleMoves: 3), // niveau 16
    LevelConfig(gridSize: 4, shuffleMoves: 3), // niveau 17
    LevelConfig(gridSize: 4, shuffleMoves: 3), // niveau 18
  ];

  static LevelConfig forLevel(int level) {
    final index = level - 1;
    if (index >= 0 && index < _table.length) return _table[index];
    return _table.last;
  }
}
