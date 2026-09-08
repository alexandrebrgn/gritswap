import 'dart:convert';

import 'package:flutter/services.dart';

import '../data/placeholder_patterns.dart';
import '../models/level_pattern.dart';
import 'pattern_repository.dart';

/// Charge tes modèles de grilles depuis `assets/patterns/patterns.json`
/// (un seul fichier, un tableau `patterns`).
///
/// Toute taille pour laquelle tu n'as pas encore écrit de modèle reçoit
/// automatiquement le modèle placeholder (bordure/intérieur), pour que le
/// jeu reste jouable pendant que tu remplis ta collection petit à petit.
class AssetPatternLoader {
  static const _path = 'assets/patterns/patterns.json';
  static const _knownSizes = [4, 5, 6];

  static Future<PatternRepository> load() async {
    final raw = await rootBundle.loadString(_path);
    final decoded = json.decode(raw) as Map<String, dynamic>;
    final rawPatterns = decoded['patterns'] as List;

    final patterns = [
      for (final entry in rawPatterns) LevelPattern.fromJson(entry as Map<String, dynamic>),
    ];

    final coveredSizes = patterns.map((p) => p.size).toSet();
    for (final size in _knownSizes) {
      if (!coveredSizes.contains(size)) {
        patterns.add(borderPatternPlaceholder(size));
      }
    }

    return PatternRepository(patterns);
  }
}
