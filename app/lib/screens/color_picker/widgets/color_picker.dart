import 'dart:math';

import 'package:flutter/material.dart';

class ColorWheelPainter extends CustomPainter {
  late final SweepGradient _hueGradient;

  // needs to start at shade of gray
  static const _saturationGradient = RadialGradient(
    colors: [Colors.white, Color.fromRGBO(255, 255, 255, 0.0)],
    stops: [0.0, 1],
  );

  final Offset knobPosition;
  final Offset center;
  final double radius;
  final double devicePixelRatio;
  final double saturation;

  ColorWheelPainter({
    required this.knobPosition,
    required this.center,
    required this.radius,
    required this.devicePixelRatio,
    required this.saturation,
  }) {
    _hueGradient = _generateHueGradient(saturation);
  }

  SweepGradient _generateHueGradient(double saturation) {
    return SweepGradient(
      colors: List.generate(
        7,
            (i) => HSVColor.fromAHSV(1.0, 360 - (i * 60.0), saturation, 1.0)
            .toColor(), // why this not work
      ),
      stops: const [
        0,
        1 / 6,
        2 / 6,
        3 / 6,
        4 / 6,
        5 / 6,
        1,
      ],
    );
  }

  void _drawBackground(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final huePaint = Paint()..shader = _hueGradient.createShader(rect);
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

class SaturationSliderPainter extends CustomPainter {
  final double hue;
  final double value;

  const SaturationSliderPainter({
    required this.hue,
    required this.value,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(colors: [
      Colors.black,
      HSVColor.fromAHSV(1.0, hue, 1.0, value).toColor(),
    ]);

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ColorPicker extends StatefulWidget {
  const ColorPicker({super.key});

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
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

    final hue = (offsetFromCenter.direction * 180 / pi + 360) % 360;
    final saturation = (distance / _radius!).clamp(0.0, 1.0);

    final hsvColor = HSVColor.fromAHSV(1, hue, saturation, 1);
    final color = hsvColor.toColor();

    setState(() {
      _knobPosition = clampedPosition;
      _selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Picker'),
      ),
      body: Column(
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
                      saturation: 1.0,
                      devicePixelRatio: dpr,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: CustomPaint(
              painter: SaturationSliderPainter(
                hue: HSVColor.fromColor(_selectedColor).hue,
                value: HSVColor.fromColor(_selectedColor).value,
              ),
            ),
          ),
          Container(
            color: _selectedColor,
            width: double.infinity,
            height: 100,
          ),
        ],
      ),
    );
  }
}
