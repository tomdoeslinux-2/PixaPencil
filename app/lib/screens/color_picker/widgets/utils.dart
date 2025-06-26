import 'dart:math';

import 'package:flutter/material.dart';

final List<Color> _kHueColors = List.generate(
  7,
  (i) => HSVColor.fromAHSV(1.0, 360 - (i * 60.0), 1.0, 1.0)
      .toColor(),
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

final _shadowPaint = Paint()
  ..color = const Color.fromRGBO(0, 0, 0, 0.15)
  ..style = PaintingStyle.stroke
  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.79);

void _drawHueKnob({
  required Canvas canvas,
  required Offset center,
  required double radius,
  required double holeThickness,
  required double hue,
}) {
  final knobWidth = holeThickness;
  final knobHeight = 0.3 * knobWidth;
  final knobStrokeWidth = 0.4 * knobHeight;

  final knobPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = knobStrokeWidth;

  final angleRad = ((-1 * hue + 360) % 360) * pi / 180;
  final knobPosition = Offset(
    center.dx + (radius - (holeThickness / 2)) * cos(angleRad),
    center.dy + (radius - (holeThickness / 2)) * sin(angleRad),
  );

  final knobRect = Rect.fromCenter(
    center: Offset.zero,
    width: knobWidth,
    height: knobHeight,
  );
  final knobRRect =
      RRect.fromRectAndRadius(knobRect, Radius.circular(knobWidth / 2));

  canvas.save();
  canvas.translate(knobPosition.dx, knobPosition.dy);
  canvas.rotate(angleRad);
  canvas.drawRRect(knobRRect, _shadowPaint..strokeWidth = knobStrokeWidth);
  canvas.drawRRect(
      knobRRect, Paint()..color = HSVColor.fromAHSV(1, hue, 1, 1).toColor());
  canvas.drawRRect(knobRRect, knobPaint);
  canvas.restore();
}

void _drawHueRing({
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

double getHueRingHoleThickness(double radius) => radius * 0.2;

void drawHueRingWithKnob({
  required Canvas canvas,
  required Offset center,
  required double radius,
  required double hue,
}) {
  final holeThickness = getHueRingHoleThickness(radius);

  _drawHueRing(
    canvas: canvas,
    center: center,
    radius: radius,
    holeThickness: holeThickness,
  );
  _drawHueKnob(
    canvas: canvas,
    center: center,
    radius: radius,
    holeThickness: holeThickness,
    hue: hue,
  );
}
