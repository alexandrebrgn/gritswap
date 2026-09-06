import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper autour de shared_preferences : progression et réglages qui
/// doivent survivre au redémarrage de l'app.
class LocalStorage {
  LocalStorage._();

  static const _bestLevelKey = 'best_level';
  static const _musicKey = 'music_enabled';
  static const _soundKey = 'sound_enabled';
  static const _vibrationKey = 'vibration_enabled';

  static Future<int> loadBestLevel() async =>
      (await SharedPreferences.getInstance()).getInt(_bestLevelKey) ?? 1;

  static Future<void> saveBestLevel(int level) async =>
      (await SharedPreferences.getInstance()).setInt(_bestLevelKey, level);

  static Future<bool> loadMusicEnabled() async =>
      (await SharedPreferences.getInstance()).getBool(_musicKey) ?? true;

  static Future<void> saveMusicEnabled(bool value) async =>
      (await SharedPreferences.getInstance()).setBool(_musicKey, value);

  static Future<bool> loadSoundEnabled() async =>
      (await SharedPreferences.getInstance()).getBool(_soundKey) ?? true;

  static Future<void> saveSoundEnabled(bool value) async =>
      (await SharedPreferences.getInstance()).setBool(_soundKey, value);

  static Future<bool> loadVibrationEnabled() async =>
      (await SharedPreferences.getInstance()).getBool(_vibrationKey) ?? false;

  static Future<void> saveVibrationEnabled(bool value) async =>
      (await SharedPreferences.getInstance()).setBool(_vibrationKey, value);
}
