import 'dart:math';
import 'dart:ui' as ui;

import 'package:app/models/bitmap_extensions.dart';
import 'package:app/models/canvas_controller.dart';
import 'package:app/providers/drawing_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphics/graphics.dart';

class CanvasPainter extends CustomPainter {
  final ui.Image image;
  final double zoom;
  final Offset zoomOrigin;
  final Offset panOffset;

  late Rect _artboardRect;
  static final _artboardPaint = Paint()..color = Colors.white;
  static final _artboardStrokePaint = Paint()
    ..color = const Color(
      0xFFD9D9D9,
    )
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  CanvasPainter({
    required this.image,
    required this.zoom,
    required this.zoomOrigin,
    required this.panOffset,
  });

  Rect get artboardRect => _artboardRect;

  void _calculateArtboardRect(Size canvasSize) {
    final originalWidth =
    min(canvasSize.width, image.width * (canvasSize.height / image.height));
    final originalHeight = originalWidth * (image.height / image.width);

    final left = (canvasSize.width - originalWidth) / 2 + panOffset.dx;
    final top = (canvasSize.height - originalHeight) / 2 + panOffset.dy;

    _artboardRect = Rect.fromLTWH(
      left - zoomOrigin.dx,
      top - zoomOrigin.dy,
      originalWidth * zoom,
      originalHeight * zoom,
    );
  }

  Rect _getSrcRect() {
    return Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    _calculateArtboardRect(size);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFEBEBEB),
    );
    canvas.drawRect(_artboardRect, _artboardPaint);
    canvas.drawRect(_artboardRect, _artboardStrokePaint);
    canvas.drawImageRect(image, _getSrcRect(), _artboardRect, Paint());
  }

  // todo not sure what this does
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingCanvasArea extends ConsumerStatefulWidget {
  const DrawingCanvasArea({super.key});

  @override
  ConsumerState<DrawingCanvasArea> createState() => _DrawingCanvasAreaState();
}

class _DrawingCanvasAreaState extends ConsumerState<DrawingCanvasArea> {
  late final CanvasController _canvasController;
  ui.Image? _canvasOutput;

  @override
  void initState() {
    super.initState();
    _canvasController = ref.read(canvasControllerProvider);
    _canvasController.addListener(() => _updateCanvasOutput());
    _updateCanvasOutput();
  }

  Future<void> _updateCanvasOutput() async {
    final output = await _canvasController.draw().toFlutterImage();

    setState(() {
      _canvasOutput = output;
    });
  }

  GPoint _convertLocalToBitmapCoordinates(
      Offset localPosition, Rect artboardRect) {
    final artboardPosition = localPosition - artboardRect.topLeft;

    final x =
    ((artboardPosition.dx / artboardRect.width) * _canvasController.width)
        .toInt();
    final y =
    ((artboardPosition.dy / artboardRect.height) * _canvasController.height)
        .toInt();

    return (x: x, y: y);
  }

  @override
  Widget build(BuildContext context) {
    if (_canvasOutput == null) {
      return const CircularProgressIndicator();
    }
    // todo do we need to create instance each time
    final canvasPainter = CanvasPainter(
      image: _canvasOutput!,
      zoom: 1.0,
      zoomOrigin: const Offset(1.0, 1.0),
      panOffset: const Offset(1.0, 1.0),
    );

    return Container(
      color: Colors.grey,
      child: GestureDetector(
        onScaleStart: (details) {
          final selectedTool = ref.read(drawingStateProvider).selectedTool;
          final point = _convertLocalToBitmapCoordinates(
              details.localFocalPoint, canvasPainter.artboardRect);

          selectedTool.onTouchDown(point);
          _updateCanvasOutput();
          ref.read(drawingStateProvider.notifier).invalidateActiveLayer();
        },
        onScaleUpdate: (details) {
          final selectedTool = ref.read(drawingStateProvider).selectedTool;
          final point = _convertLocalToBitmapCoordinates(
              details.localFocalPoint, canvasPainter.artboardRect);

          selectedTool.onTouchMove(point);
          _updateCanvasOutput();
          ref.read(drawingStateProvider.notifier).invalidateActiveLayer();
        },
        child: CustomPaint(
          painter: canvasPainter,
          size: Size.infinite,
        ),
      ),
    );
  }
}
