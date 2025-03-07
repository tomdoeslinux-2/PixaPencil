import 'dart:math';
import 'dart:ui' as ui;

import 'package:app/models/bitmap_extensions.dart';
import 'package:app/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:graphics/graphics.dart';

class ToolButton extends StatelessWidget {
  final Widget icon;
  final bool isSelected;
  final VoidCallback onTap;

  const ToolButton({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? const Color(0xFF6495ED) : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Center(
            child: IconTheme(
              data: IconThemeData(color: isSelected ? Colors.white : null),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}

class ToolPanel extends StatefulWidget {
  const ToolPanel({super.key});

  @override
  State<ToolPanel> createState() => _ToolPanelState();
}

class _ToolPanelState extends State<ToolPanel> {
  int _selectedToolIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        spacing: 10,
        children: [
          ToolButton(
            icon: const SvgIcon('assets/icons/edit_m3.svg'),
            isSelected: _selectedToolIndex == 0,
            onTap: () => setState(() => _selectedToolIndex = 0),
          ),
          ToolButton(
            icon: const SvgIcon('assets/icons/eraser_m3.svg'),
            isSelected: _selectedToolIndex == 1,
            onTap: () => setState(() => _selectedToolIndex = 1),
          ),
          ToolButton(
            icon: const SvgIcon('assets/icons/colorize_m3.svg'),
            isSelected: _selectedToolIndex == 2,
            onTap: () => setState(() => _selectedToolIndex = 2),
          ),
        ],
      ),
    );
  }
}

class CanvasView extends StatelessWidget {
  const CanvasView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CanvasPainter extends CustomPainter {
  final ui.Image image;
  final double zoom;
  final Offset zoomOrigin;
  final Offset panOffset;

  late Rect _artboardRect;
  final _artboardPaint = Paint()..color = Colors.white;

  CanvasPainter({
    required this.image,
    required this.zoom,
    required this.zoomOrigin,
    required this.panOffset,
  });

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
      Paint()..color = const Color(0xFFC0C0C0),
    );
    canvas.drawRect(_artboardRect, _artboardPaint);
    canvas.drawImageRect(image, _getSrcRect(), _artboardRect, Paint());
  }

  // todo not sure what this does
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingScreen extends StatelessWidget {
  const DrawingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Untitled'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const SvgIcon(
              'assets/icons/undo_m3.svg',
              color: Color(0xFF797979),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const SvgIcon(
              'assets/icons/redo_m3.svg',
              color: Color(0xFF797979),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const SvgIcon(
              'assets/icons/zoom_in_m3.svg',
              color: Color(0xFF797979),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const SvgIcon(
              'assets/icons/zoom_out_m3.svg',
              color: Color(0xFF797979),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFF797979),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey,
                  child: CustomPaint(
                    painter: await GBitmap(25, 25, config: GBitmapConfig.rgb,).toFlutterImage(), // why this not working????
                    size: Size.infinite,
                  ),
                ),
              ),
              const ToolPanel(),
            ],
          ),
        ),
      ),
    );
  }
}
