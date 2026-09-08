import 'asset_pattern_loader.dart';
import 'pattern_repository.dart';

/// Charge les modèles une seule fois au démarrage (voir [init] appelé dans
/// main.dart), pour que [GameSession] puisse y accéder de façon synchrone.
class PatternSource {
  PatternSource._();

  static late PatternRepository repository;

  static Future<void> init() async {
    repository = await AssetPatternLoader.load();
  }
}
