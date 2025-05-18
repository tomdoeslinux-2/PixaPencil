import 'package:flutter/material.dart';

import 'constants.dart';

class _HueSquareColorPickerPainter extends CustomPainter {
  final double hue;

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

  const _HueSquareColorPickerPainter({required this.hue});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawRect(
        rect, Paint()..color = HSVColor.fromAHSV(1, hue, 1, 1).toColor());
    canvas.drawRect(
        rect, Paint()..shader = _saturationGradient.createShader(rect));
    canvas.drawRect(
        rect, Paint()..shader = _brightnessGradient.createShader(rect));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _HueSliderPainter extends CustomPainter {
  final _hueLinearGradient =
      LinearGradient(colors: kHueColors, stops: kHueStops);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..shader = _hueLinearGradient.createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HueSquareColorPicker extends StatefulWidget {
  const HueSquareColorPicker({super.key});

  @override
  State<HueSquareColorPicker> createState() => _HueSquareColorPickerState();
}

class _HueSquareColorPickerState extends State<HueSquareColorPicker> {
  var _selectedHue = 0.0;

  void _updateHue(double dx, double maxWidth) {
    setState(() {
      _selectedHue = 360 - ((dx / maxWidth).clamp(0.0, 1.0) * 360);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: CustomPaint(
            painter: _HueSquareColorPickerPainter(hue: _selectedHue),
            size: const Size(double.infinity, double.infinity),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onPanDown: (details) {
                _updateHue(details.localPosition.dx, constraints.maxWidth);
                print(_selectedHue);
              },
              onPanUpdate: (details) {
                _updateHue(details.localPosition.dx, constraints.maxWidth);
              },
              child: CustomPaint(
                painter: _HueSliderPainter(),
                size: const Size(double.infinity, 50),
              ),
            );
          },
        ),
      ],
    );
  }
}
