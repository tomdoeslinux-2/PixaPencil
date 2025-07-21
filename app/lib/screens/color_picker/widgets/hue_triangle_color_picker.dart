import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'utils.dart';

double _dot(
  Offset a,
  Offset b,
) {
  return a.dx * b.dx + a.dy * b.dy;
}

List<double> _computeBarycentric(
  Offset p,
  Offset a,
  Offset b,
  Offset c,
) {
  final v0 = b - a;
  final v1 = c - a;
  final v2 = p - a;

  final d00 = _dot(v0, v0);
  final d01 = _dot(v0, v1);
  final d11 = _dot(v1, v1);
  final d20 = _dot(v2, v0);
  final d21 = _dot(v2, v1);

  final denom = d00 * d11 - (d01 * d01);
  final v = ((d11 * d20) - (d01 * d21)) / denom;
  final w = ((d00 * d21) - (d01 * d20)) / denom;
  final u = 1 - v - w;

  return [u, v, w];
}

Color _getColorFromTrianglePoint({
  required Offset point,
  required Offset a,
  required Offset b,
  required Offset c,
  required double hue,
}) {
  final [u, v, w] = _computeBarycentric(point, a, b, c);
  final total = u + v + w;

  final saturation = u / total;
  final value = (u + v) / total;

  print(
      "Saturation $saturation , value $value for point $point in a $a b $b c $c");

  return HSVColor.fromAHSV(
          1.0, hue, saturation.clamp(0.0, 1.0), value.clamp(0.0, 1.0))
      .toColor();
}

Offset _computeEquilateralVertex({
  required double degrees,
  required Offset center,
  required double radius,
}) {
  final angleRadians = degToRad(degrees);

  return Offset(
    center.dx + radius * cos(angleRadians),
    center.dy + radius * sin(angleRadians),
  );
}

bool _isPointInTriangle({
  required Offset point,
  required Offset a,
  required Offset b,
  required Offset c,
}) {
  final bary = _computeBarycentric(point, a, b, c);
  final u = bary[0];
  final v = bary[1];
  final w = bary[2];

  return u >= 0 && v >= 0 && w >= 0;
}

(Offset, Offset, Offset) _getTrianglePoints({
  required Offset center,
  required double radius,
}) {
  return (
    _computeEquilateralVertex(
      degrees: -90,
      center: center,
      radius: radius,
    ),
    _computeEquilateralVertex(
      degrees: 30,
      center: center,
      radius: radius,
    ),
    _computeEquilateralVertex(
      degrees: 150,
      center: center,
      radius: radius,
    ),
  );
}

Offset _rotatePoint({
  required Offset point,
  required Offset center,
  required double degrees,
}) {
  final angle = degToRad(degrees);
  final dx = point.dx - center.dx;
  final dy = point.dy - center.dy;

  // Rotation matrix
  final rotatedX = dx * cos(angle) - dy * sin(angle);
  final rotatedY = dx * sin(angle) + dy * cos(angle);

  return Offset(rotatedX + center.dx, rotatedY + center.dy);
}

class _HueTriangleColorPickerPainter extends CustomPainter {
  final HSVColor color;
  final ui.FragmentProgram triangleFrag;
  final Offset center;
  final double radius;

  double get _hue => color.hue;
  double get _saturation => color.saturation;
  double get _value => color.value;

  double get _adjHue => -(_hue - 90);
  double get _holeRadius => radius - getHueRingHoleThickness(radius);

  _HueTriangleColorPickerPainter({
    required this.color,
    required this.triangleFrag,
    required this.center,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    drawHueRingWithKnob(
      canvas: canvas,
      center: center,
      radius: radius,
      hue: _hue,
    );
    _drawTriangle(canvas);
    _drawTriangleKnob(canvas);
  }

  void _drawTriangle(Canvas canvas) {
    final (p1, p2, p3) =
        _getTrianglePoints(center: center, radius: _holeRadius);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(degToRad(_adjHue));
    canvas.translate(-center.dx, -center.dy);

    final shader = triangleFrag.fragmentShader();
    final hue = -1 * (_adjHue - 90) % 360;

    shader.setFloat(0, hue);
    shader.setFloat(1, p1.dx);
    shader.setFloat(2, p1.dy);
    shader.setFloat(3, p2.dx);
    shader.setFloat(4, p2.dy);
    shader.setFloat(5, p3.dx);
    shader.setFloat(6, p3.dy);

    final paint = Paint()..shader = shader;

    final dstRect = Rect.fromPoints(
      Offset(
        min(
          p1.dx,
          min(p2.dx, p3.dx),
        ),
        min(
          p1.dy,
          min(p2.dy, p3.dy),
        ),
      ),
      Offset(
        max(
          p1.dx,
          max(p2.dx, p3.dx),
        ),
        max(
          p1.dy,
          max(p2.dy, p3.dy),
        ),
      ),
    );

    canvas.drawRect(dstRect, paint);
    canvas.restore();
  }

  Offset _weightedSum(
    Offset a,
    Offset b,
    Offset c,
    double u,
    double v,
    double w,
  ) {
    return Offset(
      a.dx * u + b.dx * v + c.dx * w,
      a.dy * u + b.dy * v + c.dy * w,
    );
  }

  void _drawTriangleKnob(Canvas canvas) {
    final (p1, p2, p3) =
        _getTrianglePoints(center: center, radius: _holeRadius);

    final u = _saturation;
    final v = _value - _saturation;
    final w = 1.0 - u - v;

    final unrotatedPos = _weightedSum(p1, p2, p3, u, v, w);
    final rotatedPos = _rotatePoint(
      point: unrotatedPos,
      center: center,
      degrees: _adjHue,
    );

    drawKnob(canvas: canvas, color: color.toColor(), position: rotatedPos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HueTriangleColorPicker extends StatefulWidget {
  final void Function(HSVColor) onColorSelected;

  const HueTriangleColorPicker({
    super.key,
    required this.onColorSelected,
  });

  @override
  State<HueTriangleColorPicker> createState() => _HueTriangleColorPickerState();
}

enum _DragTarget {
  hueRing,
  triangle,
}

class _HueTriangleColorPickerState extends State<HueTriangleColorPicker> {
  Offset? _center;
  double? _radius;
  double _selectedHue = 0;
  double _selectedSaturation = 0;
  double _selectedValue = 0;

  double get _adjHue => -(_selectedHue - 90);

  ui.FragmentProgram? _triangleFrag;

  _DragTarget? _dragTarget;

  @override
  void initState() {
    super.initState();
    _loadFragmentShader();
  }

  void _updateSaturationValue({
    required Offset position,
    required double radius,
  }) {
    final holeRadius = radius - getHueRingHoleThickness(radius);
    final unrotated = _rotatePoint(
      point: position,
      center: _center!,
      degrees: -_adjHue,
    );

    final (p1, p2, p3) =
        _getTrianglePoints(center: _center!, radius: holeRadius);

    final color = _getColorFromTrianglePoint(
      point: unrotated,
      a: p1,
      b: p2,
      c: p3,
      hue: _selectedHue,
    );
    final colorHSV = HSVColor.fromColor(color);

    setState(() {
      _selectedSaturation = colorHSV.saturation;
      _selectedValue = colorHSV.value;
    });
  }

  void _updateHue(Offset position) {
    setState(() {
      _selectedHue = computeHueFromPosition(
        position: position,
        center: _center!,
      );
    });
  }

  Future<void> _loadFragmentShader() async {
    final program =
        await ui.FragmentProgram.fromAsset('shaders/hue_triangle_shader.frag');

    setState(() {
      _triangleFrag = program;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxWidth);
            _center = size.center(Offset.zero);
            _radius = min(size.width, size.height) / 2;

            final holeThickness = getHueRingHoleThickness(_radius!);

            if (_triangleFrag == null) {
              return const SizedBox.shrink();
            }

            return SizedBox(
              width: size.width,
              height: size.height,
              child: GestureDetector(
                onPanDown: (details) {
                  final offsetFromCenter = details.localPosition - _center!;
                  final distance = offsetFromCenter.distance;

                  final innerRadius = _radius! - holeThickness;
                  final isInHueRing =
                      distance >= innerRadius && distance <= _radius!;

                  if (isInHueRing) {
                    _dragTarget = _DragTarget.hueRing;
                    _updateHue(details.localPosition);
                    return;
                  }

                  final holeRadius = _radius! - holeThickness;
                  final unrotatedPoint = _rotatePoint(
                    point: details.localPosition,
                    center: _center!,
                    degrees: -_adjHue,
                  );
                  final (p1, p2, p3) =
                      _getTrianglePoints(center: _center!, radius: holeRadius);
                  final isInTriangle = _isPointInTriangle(
                      point: unrotatedPoint, a: p1, b: p2, c: p3);

                  if (isInTriangle) {
                    _dragTarget = _DragTarget.triangle;
                    _updateSaturationValue(
                        position: details.localPosition, radius: _radius!);
                  }
                },
                onPanUpdate: (details) {
                  if (_dragTarget == _DragTarget.hueRing) {
                    _updateHue(details.localPosition);
                  }

                  if (_dragTarget == _DragTarget.triangle) {
                    _updateSaturationValue(
                        position: details.localPosition, radius: _radius!);
                  }
                },
                onPanEnd: (details) {
                  _dragTarget = null;
                },
                child: CustomPaint(
                  size: const Size(double.infinity, double.infinity),
                  painter: _HueTriangleColorPickerPainter(
                    color: HSVColor.fromAHSV(
                        1, _selectedHue, _selectedSaturation, _selectedValue),
                    triangleFrag: _triangleFrag!,
                    radius: _radius!,
                    center: _center!,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
