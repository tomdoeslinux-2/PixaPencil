import 'dart:math';
import 'dart:ui' as ui;

import 'package:app/models/bitmap_extensions.dart';
import 'package:app/models/canvas_controller.dart';
import 'package:app/models/pencil_tool.dart';
import 'package:app/models/tool_type.dart';
import 'package:app/providers/drawing_state_provider.dart';
import 'package:app/screens/drawing/widgets/drawing_app_bar.dart';
import 'package:app/screens/drawing/widgets/drawing_canvas_area.dart';
import 'package:app/screens/drawing/widgets/layers_panel.dart';
import 'package:app/screens/drawing/widgets/layers_panel/layers_panel.dart';
import 'package:app/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphics/graphics.dart';

import 'widgets/color_swatch_panel.dart';
import 'widgets/tool_panel.dart';

class DrawingScreen extends ConsumerStatefulWidget {
  const DrawingScreen({super.key});

  @override
  ConsumerState<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends ConsumerState<DrawingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DrawingAppBar(),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: const Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        ColorSwatchPanel(),
                        Expanded(
                          child: DrawingCanvasArea(),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: LayersPanel(),
                    ),
                  ],
                ),
              ),
              // Expanded(child: LayersPanel()),
              ToolPanel(),
            ],
          ),
        ),
      ),
    );
  }
}
