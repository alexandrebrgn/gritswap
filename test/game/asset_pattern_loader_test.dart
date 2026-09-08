import 'package:flutter_test/flutter_test.dart';
import 'package:grit_swap/game/asset_pattern_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('charge le modèle exemple et complète les tailles sans fichier avec le repli', () async {
    final repository = await AssetPatternLoader.load();

    final size4 = repository.randomForSize(4);
    expect(size4.size, 4);

    // 5x5 et 6x6 n'ont pas encore de vrai fichier : le repli doit prendre le relais.
    final size5 = repository.randomForSize(5);
    expect(size5.size, 5);
    final size6 = repository.randomForSize(6);
    expect(size6.size, 6);
  });
}
