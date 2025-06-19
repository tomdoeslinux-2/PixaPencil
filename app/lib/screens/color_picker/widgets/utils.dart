import 'dart:math';

import 'package:flutter/material.dart';

final List<Color> _kHueColors = List.generate(
  7,
  (i) => HSVColor.fromAHSV(1.0, 360 - (i * 60.0), 1.0, 1.0)
      .toColor(), // why this not work
);

const List<double> _kHueStops = [
  0,
  1 / 6,
  2 / 6,
  3 / 6,
  4 / 6,
  5 / 6,
  1,
];

final SweepGradient kHueSweepGradient = SweepGradient(
  colors: _kHueColors,
  stops: _kHueStops,
);

final LinearGradient kHueLinearGradient = LinearGradient(
  colors: _kHueColors,
  stops: _kHueStops,
);

void drawHueRing({
  required Canvas canvas,
  required Offset center,
  required double radius,
  required double holeThickness,
}) {
  final rect = Rect.fromCircle(center: center, radius: radius);
  final huePaint = Paint()..shader = kHueSweepGradient.createShader(rect);

  canvas.saveLayer(rect, Paint());
  canvas.drawCircle(
    center,
    radius,
    huePaint,
  );

  final holePaint = Paint()..blendMode = BlendMode.clear;
  final holeRadius = radius - holeThickness;

  canvas.drawCircle(center, holeRadius, holePaint);
  canvas.restore();
}
