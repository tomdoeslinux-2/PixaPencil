import 'dart:math';

import 'package:flutter/material.dart';

final List<Color> kHueColors = List.generate(
  7,
  (i) => HSVColor.fromAHSV(1.0, 360 - (i * 60.0), 1.0, 1.0).toColor(),
);

const List<double> kHueStops = [
  0,
  1 / 6,
  2 / 6,
  3 / 6,
  4 / 6,
  5 / 6,
  1,
];

final SweepGradient kHueSweepGradient = SweepGradient(
  colors: kHueColors,
  stops: kHueStops,
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

  final angleRad = degToRad(((-1 * hue + 360) % 360));
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

double radToDeg(double rad) => rad * (180 / pi);
double degToRad(double deg) => deg * (pi / 180);

void drawKnob({
  required Canvas canvas,
  required Color color,
  required Offset position,
}) {
  const knobStrokeWidth = 5.0;
  const knobSize = 23 - knobStrokeWidth;

  final knobPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = knobStrokeWidth;

  canvas.drawCircle(
    position,
    knobSize / 2,
    _shadowPaint..strokeWidth = knobStrokeWidth,
  );
  canvas.drawCircle(
    position,
    knobSize / 2,
    Paint()
      ..color = color.withAlpha(255)
      ..style = PaintingStyle.fill,
  );
  canvas.drawCircle(position, knobSize / 2, knobPaint);
}

double computeHueFromPosition({
  required Offset position,
  required Offset center,
}) {
  final degrees = radToDeg(atan2(
        position.dy - center.dy,
        position.dx - center.dx,
      ));
  final degreesNorm = 360 -
      ((degrees + 360) %
          360);

  return degreesNorm;
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
