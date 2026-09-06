import '../data/local_storage.dart';

/// Progression du joueur, sauvegardée localement via [LocalStorage].
/// [init] doit être appelé une fois au démarrage de l'app, avant runApp.
class SessionStats {
  SessionStats._();

  static int bestLevel = 1;

  static Future<void> init() async {
    bestLevel = await LocalStorage.loadBestLevel();
  }

  static void reportGameOver(int levelReached) {
    if (levelReached > bestLevel) {
      bestLevel = levelReached;
      LocalStorage.saveBestLevel(bestLevel);
    }
  }
}
