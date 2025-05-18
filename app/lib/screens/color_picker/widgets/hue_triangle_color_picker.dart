import 'dart:math';
import 'dart:ui' as ui;

import 'package:app/models/bitmap_extensions.dart';
import 'package:app/models/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:graphics/graphics.dart';

import 'constants.dart';

(double, double, double) _computeBarycentric(
  GVector point,
  GVector a,
  GVector b,
  GVector c,
) {
  final v0 = b.subtract(a);
  final v1 = c.subtract(a);
  final v2 = point.subtract(a);

  final d00 = v0.dot(v0);
  final d01 = v0.dot(v1);
  final d11 = v1.dot(v1);
  final d20 = v2.dot(v0);
  final d21 = v2.dot(v1);

  final denom = d00 * d11 - (d01 * d01);
  final v = ((d11 * d20) - (d01 * d21)) / denom;
  final w = ((d00 * d21) - (d01 * d20)) / denom;
  final u = 1 - v - w;

  return (u, v, w);
}

GBitmap _drawHueTriangleBitmap({
  required double hue,
  required int width,
  required int height,
}) {
  final bitmap = GBitmap(
    width,
    height,
    config: GBitmapConfig.rgba,
  );

  final GVector a = (width / 2, 0); // top vertex
  final GVector b = (0, height.toDouble()); // bottom left vertex
  final GVector c =
      (width.toDouble(), height.toDouble()); // bottom right vertex

  final stopwatch = Stopwatch()..start();

  for (int y = 0; y < bitmap.height; ++y) {
    for (int x = 0; x < bitmap.width; ++x) {
      final GVector point = (x.toDouble(), y.toDouble());
      final (u, v, w) = _computeBarycentric(point, a, b, c);

      // check if point in triangle
      if (u >= 0 && v >= 0 && w >= 0) {
        final saturation = u;
        final value = u + v;
        final color = HSVColor.fromAHSV(1.0, hue, saturation, value);

        bitmap.setPixel(x, y, color.toColor().toGColor());
      }
    }
  }

  stopwatch.stop();
  print('Elapsed time: ${stopwatch.elapsedMilliseconds} ms');

  return bitmap;
}

class _HueTriangleColorPickerPainter extends CustomPainter {
  final ui.Image triangleImage;
  final Offset center;
  final double radius;
  final double holeThickness;
  final double rotation;

  const _HueTriangleColorPickerPainter({
    required this.triangleImage,
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

    final srcRect = Rect.fromLTWH(
        0, 0, triangleImage.width.toDouble(), triangleImage.height.toDouble());

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

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation * pi / 180);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawImageRect(triangleImage, srcRect, dstRect, Paint());
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

  bool _isDraggingHueRing = false;

  ui.Image? _triangleImage;

  void _handleHueRotation({
    required Offset position,
    required double holeThickness,
    required int triangleWidth,
    required int triangleHeight,
  }) {
    final offsetFromCenter = position - _center!;
    final angle = offsetFromCenter.direction;

    setState(() {
      _rotation = angle * 180 / pi + 90;
    });
    
    _updateTriangleImage(width: triangleWidth, height: triangleHeight);
  }

  Future<void> _updateTriangleImage({
    required int width,
    required int height,
  }) async {
    final newTriangleImage = await _drawHueTriangleBitmap(
      hue: -1 * (_rotation - 90) % 360,
      width: width,
      height: height,
    ).toFlutterImage();

    setState(() {
      _triangleImage = newTriangleImage;
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
              final holeRadius = _radius! - holeThickness;

              final dpr = MediaQuery.of(context).devicePixelRatio;
              final triangleRenderRadius = holeRadius * dpr;

              final triangleWidth = ((triangleRenderRadius * sqrt(3)).ceil() / 2.0).round();
              final triangleHeight = (triangleRenderRadius.ceil() / 2.0).round();

              if (_triangleImage == null) {
                _updateTriangleImage(width: triangleWidth, height: triangleHeight);

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
                    _handleHueRotation(
                      position: details.localPosition,
                      holeThickness: holeThickness,
                      triangleWidth: triangleWidth,
                      triangleHeight: triangleHeight,
                    );
                  }
                },
                onPanUpdate: (details) {
                  if (_isDraggingHueRing) {
                    _handleHueRotation(
                      position: details.localPosition,
                      holeThickness: holeThickness,
                      triangleWidth: triangleWidth,
                      triangleHeight: triangleHeight,
                    );
                  }
                },
                onPanEnd: (details) {
                  _isDraggingHueRing = false;
                },
                child: CustomPaint(
                  size: size,
                  painter: _HueTriangleColorPickerPainter(
                    radius: _radius!,
                    center: _center!,
                    triangleImage: _triangleImage!,
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
