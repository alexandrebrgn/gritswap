import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/local_storage.dart';
import '../game/session_stats.dart';
import '../theme/palette.dart';

/// Réglages — musique/sons/vibrations sont sauvegardés localement via
/// [LocalStorage].
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _music = true;
  bool _sound = true;
  bool _vibration = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final music = await LocalStorage.loadMusicEnabled();
    final sound = await LocalStorage.loadSoundEnabled();
    final vibration = await LocalStorage.loadVibrationEnabled();
    if (!mounted) return;
    setState(() {
      _music = music;
      _sound = sound;
      _vibration = vibration;
    });
  }

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Palette.panel,
        title: Text('Réinitialiser ?', style: GoogleFonts.silkscreen(fontWeight: FontWeight.w700, color: Palette.cream)),
        content: Text(
          'Ton meilleur niveau atteint sera remis à zéro.',
          style: GoogleFonts.silkscreen(color: Palette.lavender),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Réinitialiser')),
        ],
      ),
    );
    if (confirmed == true) {
      SessionStats.bestLevel = 1;
      await LocalStorage.saveBestLevel(1);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Progression réinitialisée.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(color: Palette.panel, border: Border.all(color: Palette.panelBorder, width: 3)),
                      child: const Icon(Icons.arrow_back, color: Palette.cream, size: 18),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text('PARAMETRES', style: GoogleFonts.pressStart2p(fontSize: 14, color: Palette.gold)),
                ],
              ),
              const SizedBox(height: 26),
              _ToggleRow(
                label: 'MUSIQUE',
                value: _music,
                onChanged: (v) {
                  setState(() => _music = v);
                  LocalStorage.saveMusicEnabled(v);
                },
              ),
              const SizedBox(height: 12),
              _ToggleRow(
                label: 'SONS',
                value: _sound,
                onChanged: (v) {
                  setState(() => _sound = v);
                  LocalStorage.saveSoundEnabled(v);
                },
              ),
              const SizedBox(height: 12),
              _ToggleRow(
                label: 'VIBRATIONS',
                value: _vibration,
                onChanged: (v) {
                  setState(() => _vibration = v);
                  LocalStorage.saveVibrationEnabled(v);
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: _confirmReset,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(color: Palette.danger, border: Border.all(color: Palette.dangerBorder, width: 3)),
                  alignment: Alignment.center,
                  child: Text(
                    'REINITIALISER LA PROGRESSION',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.silkscreen(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(color: Palette.panel, border: Border.all(color: Palette.panelBorder, width: 3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.silkscreen(fontWeight: FontWeight.w700, fontSize: 14, color: Palette.cream)),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              width: 44,
              height: 22,
              padding: const EdgeInsets.all(3),
              color: const Color(0xFF12112A),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 14,
                height: 14,
                color: value ? Palette.gold : const Color(0xFF5A5580),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
