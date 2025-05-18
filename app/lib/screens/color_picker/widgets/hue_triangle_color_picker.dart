import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'constants.dart';

class _HueTriangleColorPickerPainter extends CustomPainter {
  final ui.FragmentProgram triangleFrag;
  final Offset center;
  final double radius;
  final double holeThickness;
  final double rotation;

  const _HueTriangleColorPickerPainter({
    required this.triangleFrag,
    required this.center,
    required this.radius,
    required this.holeThickness,
    required this.rotation,
  });

  Offset _computeEquilateralVertex({
    required double degrees,
    required Offset center,
    required double radius,
  }) {
    final angleRadians = degrees * pi / 180;

    return Offset(
      center.dx + radius * cos(angleRadians),
      center.dy + radius * sin(angleRadians),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final huePaint = Paint()..shader = kHueSweepGradient.createShader(rect);

    final layerBounds = Rect.fromCircle(center: center, radius: radius);
    canvas.saveLayer(layerBounds, Paint());

    canvas.drawCircle(
      center,
      radius,
      huePaint,
    );

    final holePaint = Paint()..blendMode = BlendMode.clear;
    final holeRadius = radius - holeThickness;

    canvas.drawCircle(center, holeRadius, holePaint);
    canvas.restore();

    final p1 = _computeEquilateralVertex(
      degrees: -90,
      center: center,
      radius: holeRadius,
    );
    final p2 = _computeEquilateralVertex(
      degrees: 30,
      center: center,
      radius: holeRadius,
    );
    final p3 = _computeEquilateralVertex(
      degrees: 150,
      center: center,
      radius: holeRadius,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation * pi / 180);
    canvas.translate(-center.dx, -center.dy);

    final shader = triangleFrag.fragmentShader();
    final hue = -1 * (rotation - 90) % 360;

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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HueTriangleColorPicker extends StatefulWidget {
  const HueTriangleColorPicker({super.key});

  @override
  State<HueTriangleColorPicker> createState() => _HueTriangleColorPickerState();
}

class _HueTriangleColorPickerState extends State<HueTriangleColorPicker> {
  Offset? _center;
  double? _radius;
  double _rotation = 0;

  ui.FragmentProgram? _triangleFrag;

  bool _isDraggingHueRing = false;

  @override
  void initState() {
    super.initState();
    _loadFragmentShader();
  }

  Future<void> _loadFragmentShader() async {
    final program =
        await ui.FragmentProgram.fromAsset('shaders/hue_triangle_shader.frag');

    setState(() {
      _triangleFrag = program;
    });
  }

  void _handleHueRotation({required Offset position}) {
    final offsetFromCenter = position - _center!;
    final angle = offsetFromCenter.direction;

    setState(() {
      _rotation = angle * 180 / pi + 90;
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
              _radius = min(size.width, size.height) / 2;

              final holeThickness = _radius! * 0.15;

              if (_triangleFrag == null) {
                return const SizedBox.shrink();
              }

              return GestureDetector(
                onPanDown: (details) {
                  final offsetFromCenter = details.localPosition - _center!;
                  final distance = offsetFromCenter.distance;

                  final innerRadius = _radius! - holeThickness;
                  final isInHueRing =
                      distance >= innerRadius && distance <= _radius!;

                  _isDraggingHueRing = isInHueRing;

                  if (_isDraggingHueRing) {
                    _handleHueRotation(position: details.localPosition);
                  }
                },
                onPanUpdate: (details) {
                  if (_isDraggingHueRing) {
                    _handleHueRotation(position: details.localPosition);
                  }
                },
                onPanEnd: (details) {
                  _isDraggingHueRing = false;
                },
                child: CustomPaint(
                  size: size,
                  painter: _HueTriangleColorPickerPainter(
                    triangleFrag: _triangleFrag!,
                    radius: _radius!,
                    center: _center!,
                    holeThickness: holeThickness,
                    rotation: _rotation,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
