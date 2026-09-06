/// Une grille n×n de cases à deux faces (true = face, false = pile).
///
/// Immuable : `flip` retourne une nouvelle instance plutôt que de modifier
/// la grille en place, ce qui simplifie les tests et le undo/reset.
class Grid {
  final int size;
  final List<List<bool>> _cells;

  Grid(this.size, List<List<bool>> cells)
      : _cells = List.generate(size, (r) => List<bool>.from(cells[r]));

  /// Construit une grille à partir d'une matrice de 0/1, pratique pour écrire
  /// des modèles à la main (0 = pile, 1 = face).
  factory Grid.fromInts(List<List<int>> pattern) {
    final size = pattern.length;
    return Grid(size, [
      for (final row in pattern) [for (final v in row) v != 0],
    ]);
  }

  bool cellAt(int row, int col) => _cells[row][col];

  /// Retourne la case (row, col) et jusqu'à ses 8 voisines (moins sur les
  /// bords, moins encore dans les coins).
  Grid flip(int row, int col) {
    final newCells = List.generate(size, (r) => List<bool>.from(_cells[r]));
    for (var dr = -1; dr <= 1; dr++) {
      for (var dc = -1; dc <= 1; dc++) {
        final r = row + dr;
        final c = col + dc;
        if (r >= 0 && r < size && c >= 0 && c < size) {
          newCells[r][c] = !newCells[r][c];
        }
      }
    }
    return Grid(size, newCells);
  }

  bool matches(Grid other) {
    if (size != other.size) return false;
    for (var r = 0; r < size; r++) {
      for (var c = 0; c < size; c++) {
        if (_cells[r][c] != other._cells[r][c]) return false;
      }
    }
    return true;
  }

  @override
  bool operator ==(Object other) => other is Grid && matches(other);

  @override
  int get hashCode =>
      _cells.expand((row) => row).fold(0, (hash, v) => hash * 31 + (v ? 1 : 0));

  /// Rendu ASCII façon `*`/`-`, pratique pour lire une grille dans les logs de test.
  @override
  String toString() =>
      _cells.map((row) => row.map((v) => v ? '*' : '-').join()).join('\n');
}
