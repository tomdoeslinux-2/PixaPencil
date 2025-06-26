import 'dart:math';

import 'package:flutter/material.dart';

import 'utils.dart';

class _HueSquareColorPickerPainter extends CustomPainter {
  final HSVColor color;
  final Offset center;
  final double radius;
  final double holeThickness;
  final Rect innerRect;

  double get _hue => color.hue;
  double get _saturation => color.saturation;
  double get _value => color.value;

  static final _shadowPaint = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 0.15)
    ..style = PaintingStyle.stroke
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.79);

  static const _saturationGradient = LinearGradient(
    colors: [Colors.white, Color.fromRGBO(255, 255, 255, 0.0)],
    stops: [0.0, 1],
  );
  static const _brightnessGradient = LinearGradient(
    colors: [Colors.black, Color.fromRGBO(0, 0, 0, 0.0)],
    stops: [0.0, 1],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  const _HueSquareColorPickerPainter({
    required this.color,
    required this.center,
    required this.radius,
    required this.holeThickness,
    required this.innerRect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    drawHueRing(
      canvas: canvas,
      center: center,
      radius: radius,
      holeThickness: holeThickness,
    );

    _drawSaturationBrightnessSquare(canvas, innerRect);
    _drawHueKnob(canvas);
    _drawSaturationBrightnessKnob(canvas, innerRect);
  }

  void _drawHueKnob(Canvas canvas) {
    final knobWidth = holeThickness;
    final knobHeight = 0.3 * knobWidth;
    final knobStrokeWidth = 0.4 * knobHeight;

    final knobPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = knobStrokeWidth;

    final angleRad = ((-1 * _hue + 360) % 360) * pi / 180;
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
        knobRRect, Paint()..color = HSVColor.fromAHSV(1, _hue, 1, 1).toColor());
    canvas.drawRRect(knobRRect, knobPaint);
    canvas.restore();
  }

  void _drawSaturationBrightnessKnob(Canvas canvas, Rect rect) {
    const knobStrokeWidth = 5.0;
    const knobSize = 23 - knobStrokeWidth;

    final knobPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = knobStrokeWidth;

    final dx = rect.left + (rect.width * _saturation);
    final dy = rect.top + (rect.height * (1 - _value));
    final offset = Offset(dx, dy);

    canvas.drawCircle(
        offset, knobSize / 2, _shadowPaint..strokeWidth = knobStrokeWidth);
    canvas.drawCircle(
      offset,
      knobSize / 2,
      Paint()
        ..color = color.withAlpha(1).toColor()
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(offset, knobSize / 2, knobPaint);
  }

  void _drawSaturationBrightnessSquare(Canvas canvas, Rect rect) {
    canvas.drawRect(
        rect, Paint()..color = HSVColor.fromAHSV(1, _hue, 1, 1).toColor());
    canvas.drawRect(
        rect, Paint()..shader = _saturationGradient.createShader(rect));
    canvas.drawRect(
        rect, Paint()..shader = _brightnessGradient.createShader(rect));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HueSquareColorPicker extends StatefulWidget {
  final void Function(Color) onColorSelected;

  const HueSquareColorPicker({
    super.key,
    required this.onColorSelected,
  });

  @override
  State<HueSquareColorPicker> createState() => _HueSquareColorPickerState();
}

enum _DragTarget {
  hueRing,
  innerRect,
}

class _HueSquareColorPickerState extends State<HueSquareColorPicker> {
  Offset? _center;
  var _selectedHue = 0.0;
  var _selectedSaturation = 0.0;
  var _selectedValue = 0.0;
  Rect? _innerRect;

  _DragTarget? _dragTarget;

  Rect _calculateInnerRect(double holeRadius) {
    final left = (_center!.dx - (holeRadius / sqrt(2)));
    final top = (_center!.dy - (holeRadius / sqrt(2)));
    final rectSize = holeRadius * sqrt(2);

    return Rect.fromLTWH(left, top, rectSize, rectSize);
  }

  void _updateSaturationValue(Offset position) {
    final localX = (position.dx - _innerRect!.left) / _innerRect!.width;
    final localY = (position.dy - _innerRect!.top) / _innerRect!.height;

    setState(() {
      _selectedSaturation = localX.clamp(0.0, 1.0);
      _selectedValue = (1.0 - localY).clamp(0.0, 1.0);
    });

    print(_selectedValue);
  }

  void _updateHue(Offset position) {
    final degrees = atan2(
          position.dy - _center!.dy,
          position.dx - _center!.dx,
        ) *
        (180 / pi);
    final degreesNorm = 360 - ((degrees + 360) % 360);

    setState(() {
      _selectedHue = degreesNorm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxWidth);
              _center = size.center(Offset.zero);
              final radius = min(size.width, size.height) / 2;
              final holeThickness = radius * 0.20;
              _innerRect = _calculateInnerRect(radius - holeThickness);

              return GestureDetector(
                onPanDown: (details) {
                  final offsetFromCenter = details.localPosition - _center!;
                  final distance = offsetFromCenter.distance;

                  final innerRadius = radius - holeThickness;
                  final isInHueRing =
                      distance >= innerRadius && distance <= radius;

                  if (isInHueRing) {
                    _dragTarget = _DragTarget.hueRing;
                    _updateHue(details.localPosition);
                    return;
                  }

                  final isInInnerRect =
                      _innerRect!.contains(details.localPosition);

                  if (isInInnerRect) {
                    _dragTarget = _DragTarget.innerRect;
                    _updateSaturationValue(details.localPosition);
                  }
                },
                onPanUpdate: (details) {
                  if (_dragTarget == _DragTarget.hueRing) {
                    _updateHue(details.localPosition);
                  }

                  if (_dragTarget == _DragTarget.innerRect) {
                    _updateSaturationValue(details.localPosition);
                  }
                },
                onPanEnd: (details) {
                  _dragTarget = null;
                },
                child: CustomPaint(
                  painter: _HueSquareColorPickerPainter(
                    color: HSVColor.fromAHSV(
                        0, _selectedHue, _selectedSaturation, _selectedValue),
                    center: _center!,
                    radius: radius,
                    holeThickness: holeThickness,
                    innerRect: _innerRect!,
                  ),
                  size: const Size(double.infinity, double.infinity),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
