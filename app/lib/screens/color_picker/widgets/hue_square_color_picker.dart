import 'dart:math';

import 'package:app/providers/color_picker_color_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'utils.dart';

class _HueSquareColorPickerPainter extends CustomPainter {
  final HSVColor color;
  final Offset center;
  final double radius;
  final Rect innerRect;

  double get _hue => color.hue;
  double get _saturation => color.saturation;
  double get _value => color.value;

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
    required this.innerRect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    drawHueRingWithKnob(
      canvas: canvas,
      center: center,
      radius: radius,
      hue: _hue,
    );
    _drawSaturationBrightnessSquare(canvas, innerRect);
    _drawSaturationBrightnessKnob(canvas, innerRect);
  }

  void _drawSaturationBrightnessKnob(Canvas canvas, Rect rect) {
    final dx = rect.left + (rect.width * _saturation);
    final dy = rect.top + (rect.height * (1 - _value));

    drawKnob(canvas: canvas, color: color.toColor(), position: Offset(dx, dy));
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

class HueSquareColorPicker extends ConsumerStatefulWidget {
  final void Function(HSVColor) onColorSelected;

  const HueSquareColorPicker({
    super.key,
    required this.onColorSelected,
  });

  @override
  ConsumerState<HueSquareColorPicker> createState() =>
      _HueSquareColorPickerState();
}

enum _DragTarget {
  hueRing,
  innerRect,
}

class _HueSquareColorPickerState extends ConsumerState<HueSquareColorPicker> {
  Offset? _center;
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

    final hsv = ref.read(colorPickerColorProvider);
    final newColor = hsv
        .withSaturation(localX.clamp(0.0, 1.0))
        .withValue((1.0 - localY).clamp(0.0, 1.0));

    ref.read(colorPickerColorProvider.notifier).state = newColor;
  }

  void _updateHue(Offset position) {
    final hsv = ref.read(colorPickerColorProvider);
    final newHue = computeHueFromPosition(
      position: position,
      center: _center!,
    );

    ref.read(colorPickerColorProvider.notifier).state = hsv.withHue(newHue);
  }

  @override
  Widget build(BuildContext context) {
    final hsv = ref.watch(colorPickerColorProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxWidth);
            _center = size.center(Offset.zero);
            final radius = min(size.width, size.height) / 2;
            final holeThickness = getHueRingHoleThickness(radius);
            _innerRect = _calculateInnerRect(radius - holeThickness);

            return SizedBox(
              width: size.width,
              height: size.height,
              child: GestureDetector(
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
                    color: hsv,
                    center: _center!,
                    radius: radius,
                    innerRect: _innerRect!,
                  ),
                  size: const Size(double.infinity, double.infinity),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
