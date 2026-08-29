import 'package:flutter/material.dart';

/// A code-drawn dusk skyline of temple spires, used as the welcome screen's
/// hero background instead of a raster photo/illustration.
class TempleHeroBackground extends StatelessWidget {
  const TempleHeroBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1a0f08),
            Color(0xFF5c2408),
            Color(0xFFc06a24),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: CustomPaint(
        painter: _TempleSkylinePainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _Spire {
  const _Spire(this.centerX, this.width, this.height);

  /// Fraction (0-1) of the canvas width.
  final double centerX;

  /// Fraction (0-1) of the canvas width.
  final double width;

  /// Fraction (0-1) of the canvas height, measured up from the skyline base.
  final double height;
}

class _TempleSkylinePainter extends CustomPainter {
  static const List<_Spire> _spires = [
    _Spire(0.07, 0.11, 0.15),
    _Spire(0.23, 0.15, 0.24),
    _Spire(0.38, 0.17, 0.34),
    _Spire(0.50, 0.20, 0.48),
    _Spire(0.62, 0.17, 0.34),
    _Spire(0.77, 0.15, 0.24),
    _Spire(0.93, 0.11, 0.15),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final baseY = h * 0.66;

    // Soft glow behind the central spire, like a low sun.
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFffd27a).withValues(alpha: 0.55),
          const Color(0xFFffd27a).withValues(alpha: 0.0),
        ],
      ).createShader(
        Rect.fromCircle(center: Offset(w * 0.5, baseY), radius: w * 0.55),
      );
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), glowPaint);

    final silhouette = Paint()..color = const Color(0xFF190c04);
    final path = Path()
      ..moveTo(0, h)
      ..lineTo(0, baseY);

    for (final spire in _spires) {
      final cx = w * spire.centerX;
      final halfWidth = w * spire.width / 2;
      final peakY = baseY - h * spire.height;
      final shoulderY = baseY - (baseY - peakY) * 0.5;

      path
        ..lineTo(cx - halfWidth, baseY)
        ..quadraticBezierTo(cx - halfWidth, shoulderY, cx - halfWidth * 0.2, shoulderY - (baseY - peakY) * 0.2)
        ..quadraticBezierTo(cx, peakY + (baseY - peakY) * 0.12, cx, peakY)
        ..quadraticBezierTo(cx, peakY + (baseY - peakY) * 0.12, cx + halfWidth * 0.2, shoulderY - (baseY - peakY) * 0.2)
        ..quadraticBezierTo(cx + halfWidth, shoulderY, cx + halfWidth, baseY);

      // Kalasha (pinnacle finial) on the tallest, central spire.
      if (spire.centerX == 0.5) {
        canvas.drawCircle(Offset(cx, peakY - h * 0.012), h * 0.008, silhouette);
      }
    }

    path
      ..lineTo(w, baseY)
      ..lineTo(w, h)
      ..close();

    canvas.drawPath(path, silhouette);
  }

  @override
  bool shouldRepaint(covariant _TempleSkylinePainter oldDelegate) => false;
}
