import 'dart:math';

import '../models/grid.dart';

/// Mélange une grille objectif en lui appliquant [moves] retournements
/// aléatoires, en partant de la cible (jamais l'inverse).
///
/// Note : deux retournements sur exactement la même case s'annulent
/// (voir `Grid.flip`), ce qui réduirait la difficulté réelle en dessous de
/// [moves]. On évite ce cas trivial (case identique au coup précédent), mais
/// des annulations partielles restent possibles avec des cases voisines qui
/// se chevauchent — acceptable pour une v1.
Grid shuffle(Grid target, int moves, {Random? random}) {
  final rng = random ?? Random();
  var grid = target;
  int? lastRow, lastCol;
  for (var i = 0; i < moves; i++) {
    int row, col;
    do {
      row = rng.nextInt(grid.size);
      col = rng.nextInt(grid.size);
    } while (row == lastRow && col == lastCol && grid.size * grid.size > 1);
    grid = grid.flip(row, col);
    lastRow = row;
    lastCol = col;
  }
  return grid;
}
