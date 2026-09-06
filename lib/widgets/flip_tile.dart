import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/palette.dart';

/// Un carré de la grille, avec l'effet de retournement 3D (rotation sur
/// l'axe Y + perspective). La couleur affichée bascule au milieu de la
/// rotation (à 90°), comme une vraie carte qui se retourne.
///
/// Le décalage (stagger) par rapport à la case tapée est géré via [lastTap] :
/// plus une case est loin de la case tapée, plus son animation démarre tard.
class FlipTile extends StatefulWidget {
  final bool isFace;
  final int row;
  final int col;
  final (int, int)? lastTap;
  final VoidCallback onTap;

  const FlipTile({
    super.key,
    required this.isFace,
    required this.row,
    required this.col,
    required this.lastTap,
    required this.onTap,
  });

  @override
  State<FlipTile> createState() => _FlipTileState();
}

class _FlipTileState extends State<FlipTile> with SingleTickerProviderStateMixin {
  static const _flipDuration = Duration(milliseconds: 260);
  static const _staggerStep = Duration(milliseconds: 45);

  late final AnimationController _controller;
  late bool _displayedIsFace;

  @override
  void initState() {
    super.initState();
    _displayedIsFace = widget.isFace;
    _controller = AnimationController(vsync: this, duration: _flipDuration)
      ..addListener(_onTick);
  }

  void _onTick() {
    if (_controller.value >= 0.5 && _displayedIsFace != widget.isFace) {
      setState(() => _displayedIsFace = widget.isFace);
    }
  }

  @override
  void didUpdateWidget(covariant FlipTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFace != widget.isFace) {
      _controller.value = 0;
      final delay = _staggerDelay();
      if (delay == Duration.zero) {
        _controller.forward();
      } else {
        Future.delayed(delay, () {
          if (mounted) _controller.forward(from: 0);
        });
      }
    }
  }

  Duration _staggerDelay() {
    final tap = widget.lastTap;
    if (tap == null) return Duration.zero;
    final distance = math.max((widget.row - tap.$1).abs(), (widget.col - tap.$2).abs());
    return _staggerStep * distance;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * math.pi;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(angle),
            child: Container(
              decoration: BoxDecoration(
                color: _displayedIsFace ? Palette.gold : Palette.teal,
                border: Border.all(
                  color: _displayedIsFace ? Palette.goldBorder : Palette.tealBorder,
                  width: 3,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
