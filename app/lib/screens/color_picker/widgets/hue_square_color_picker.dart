import 'dart:math';

import 'package:flutter/material.dart';

import 'utils.dart';

class _HueSquareColorPickerPainter extends CustomPainter {
  final double hue;
  final Offset center;
  final double radius;
  final double holeThickness;

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
    required this.hue,
    required this.center,
    required this.radius,
    required this.holeThickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    drawHueRing(
      canvas: canvas,
      center: center,
      radius: radius,
      holeThickness: holeThickness,
    );

    final holeRadius = radius - holeThickness;

    final left = (center.dx - (holeRadius / sqrt(2)));
    final top = (center.dy - (holeRadius / sqrt(2)));
    final rectSize = holeRadius * sqrt(2);

    final rect = Rect.fromLTWH(left, top, rectSize, rectSize);

    canvas.drawRect(
        rect,
        Paint()
          ..color =
              HSVColor.fromAHSV(1, (-1 * hue + 360) % 360, 1, 1).toColor());
    canvas.drawRect(
        rect, Paint()..shader = _saturationGradient.createShader(rect));
    canvas.drawRect(
        rect, Paint()..shader = _brightnessGradient.createShader(rect));

    final knobPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final knobPosition = Offset(
      center.dx + (radius - (holeThickness / 2)) * cos((hue * pi) / 180),
      center.dy + (radius - (holeThickness / 2)) * sin((hue * pi) / 180),
    );

    canvas.drawCircle(knobPosition, 5, knobPaint);
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

class _HueSquareColorPickerState extends State<HueSquareColorPicker> {
  Offset? _center;
  var _selectedHue = 0.0;
  bool _isDraggingHueRing = false;

  void _updateHue(Offset position) {
    final degrees = atan2(
          position.dy - _center!.dy,
          position.dx - _center!.dx,
        ) *
        (180 / pi);
    final degreesNorm = (degrees + 360) % 360;

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
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              _center = size.center(Offset.zero);
              final radius = min(size.width, size.height) / 2;

              final holeThickness = radius * 0.15;

              return GestureDetector(
                onPanDown: (details) {
                  final offsetFromCenter = details.localPosition - _center!;
                  final distance = offsetFromCenter.distance;

                  final innerRadius = radius - holeThickness;
                  final isInHueRing =
                      distance >= innerRadius && distance <= radius;

                  _isDraggingHueRing = isInHueRing;

                  if (_isDraggingHueRing) {
                    _updateHue(details.localPosition);
                  }
                },
                onPanUpdate: (details) {
                  if (_isDraggingHueRing) {
                    _updateHue(details.localPosition);
                  }
                },
                onPanEnd: (details) {
                  _isDraggingHueRing = false;
                },
                child: CustomPaint(
                  painter: _HueSquareColorPickerPainter(
                    hue: _selectedHue,
                    center: _center!,
                    radius: radius,
                    holeThickness: holeThickness,
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
