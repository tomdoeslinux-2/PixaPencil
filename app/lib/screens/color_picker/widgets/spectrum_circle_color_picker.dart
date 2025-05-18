import 'dart:math';

import 'package:flutter/material.dart';

import 'constants.dart';

class ColorWheelPainter extends CustomPainter {
  static const _saturationGradient = RadialGradient(
    colors: [Colors.white, Color.fromRGBO(255, 255, 255, 0.0)],
    stops: [0.0, 1],
  );

  final Offset knobPosition;
  final Offset center;
  final double radius;
  final double devicePixelRatio;
  final double brightness;

  ColorWheelPainter({
    required this.knobPosition,
    required this.center,
    required this.radius,
    required this.devicePixelRatio,
    required this.brightness,
  });

  void _drawBackground(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final huePaint = Paint()..shader = kHueSweepGradient.createShader(rect);
    final saturationPaint = Paint()
      ..shader = _saturationGradient.createShader(rect);

    canvas.drawCircle(
      center,
      radius,
      huePaint,
    );
    canvas.drawCircle(
      center,
      radius,
      saturationPaint,
    );

    if (brightness < 1) {
      final brightnessPaint = Paint()
        ..color = Colors.black.withValues(alpha: 1 - brightness);

      canvas.drawCircle(
        center,
        radius,
        brightnessPaint,
      );
    }
  }

  void _drawKnob(Canvas canvas, Size size) {
    const thickness = 5;
    const radius = 23;

    final knobPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness / devicePixelRatio;

    canvas.drawCircle(
        knobPosition, (radius - thickness) / devicePixelRatio, knobPaint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawKnob(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BrightnessSliderPainter extends CustomPainter {
  final double hue;
  final double saturation;

  const BrightnessSliderPainter({
    required this.hue,
    required this.saturation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(colors: [
      Colors.black,
      HSVColor.fromAHSV(1.0, hue, saturation, 1.0).toColor(),
    ]);

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SpectrumCircleColorPicker extends StatefulWidget {
  const SpectrumCircleColorPicker({super.key});

  @override
  State<SpectrumCircleColorPicker> createState() =>
      _SpectrumCircleColorPickerState();
}

class _SpectrumCircleColorPickerState extends State<SpectrumCircleColorPicker> {
  var _selectedBrightness = 1.0;
  var _selectedColor = Colors.white;

  Offset? _knobPosition;
  Offset? _center;
  double? _radius;

  void _handleColorSelection(Offset position) {
    var clampedPosition = position;
    final offsetFromCenter = position - _center!;
    final distance = offsetFromCenter.distance;

    if (distance > _radius!) {
      clampedPosition =
          _center! + Offset.fromDirection(offsetFromCenter.direction, _radius!);
    }

    final hue = (-1 * offsetFromCenter.direction * 180 / pi + 360) % 360;
    final saturation = (distance / _radius!).clamp(0.0, 1.0);

    final hsvColor = HSVColor.fromAHSV(1, hue, saturation, _selectedBrightness);
    final color = hsvColor.toColor();

    setState(() {
      _knobPosition = clampedPosition;
      _selectedColor = color;
    });
  }

  void _updateBrightness(double dx, double maxWidth) {
    setState(() {
      _selectedBrightness = (dx / maxWidth).clamp(0.0, 1.0);
    });

    _handleColorSelection(_knobPosition!);
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
              _radius = min(size.width, size.height) / 2;

              if (_knobPosition == null) {
                _knobPosition = _center;
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _handleColorSelection(_knobPosition!));
              }

              final dpr = MediaQuery.of(context).devicePixelRatio;

              return GestureDetector(
                onPanDown: (details) {
                  _handleColorSelection(details.localPosition);
                },
                onPanUpdate: (details) {
                  _handleColorSelection(details.localPosition);
                },
                child: CustomPaint(
                  size: size,
                  painter: ColorWheelPainter(
                    knobPosition: _knobPosition!,
                    radius: _radius!,
                    center: _center!,
                    brightness: _selectedBrightness,
                    devicePixelRatio: dpr,
                  ),
                ),
              );
            },
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onPanDown: (details) {
                _updateBrightness(
                    details.localPosition.dx, constraints.maxWidth);
              },
              onPanUpdate: (details) {
                _updateBrightness(
                    details.localPosition.dx, constraints.maxWidth);
              },
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomPaint(
                  painter: BrightnessSliderPainter(
                    hue: HSVColor.fromColor(_selectedColor).hue,
                    saturation: HSVColor.fromColor(_selectedColor).saturation,
                  ),
                ),
              ),
            );
          },
        ),
        Container(
          color: _selectedColor,
          width: double.infinity,
          height: 100,
        ),
      ],
    );
  }
}
