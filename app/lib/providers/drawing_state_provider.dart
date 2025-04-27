import 'dart:ui' as ui;

import 'package:app/database/database.dart';
import 'package:app/models/bitmap_extensions.dart';
import 'package:app/models/canvas_controller.dart';
import 'package:app/models/color_picker_tool.dart';
import 'package:app/models/eraser_tool.dart';
import 'package:app/models/layer.dart';
import 'package:app/models/pencil_tool.dart';
import 'package:app/models/tool_type.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphics/graphics.dart';

import '../models/drawing_state.dart';
import '../models/tool.dart';

class _DrawingStateNotifier extends Notifier<DrawingState> {
  CanvasController get _canvasController => ref.read(canvasControllerProvider);

  Tool _createToolFromType(ToolType type) {
    switch (type) {
      case ToolType.pencil:
        return PencilTool(
          getColor: () => state.selectedColor,
          canvasController: _canvasController,
        );
      case ToolType.eraser:
        return EraserTool(
          canvasController: _canvasController,
        );
      case ToolType.colorPicker:
        return ColorPickerTool(
          canvasController: _canvasController,
          onColorSelected: (color) {
            changeColor(color);
          },
        );
    }
  }

  @override
  DrawingState build() {
    return DrawingState(
      selectedColor: GColors.black,
      selectedColorIndex: 0,
      selectedTool: _createToolFromType(ToolType.pencil),
      layers: _canvasController.layerRefs.mapIndexed((index, layerRef) => Layer(
        data: layerRef.rootNode.process(null),
        isVisible: layerRef.isVisible,
        name: 'Layer $index',
      )).toList(),
      selectedLayerIndex: _canvasController.selectedLayerRefIndex,
    );
  }

  Future<ui.Image> getRenderedImageForLayer(int index) {
    final layerRefs = _canvasController.layerRefs;

    return layerRefs[index].rootNode.process(null).toFlutterImage();
  }

  void addLayer() {
    _canvasController.addLayer();

    final newLayer = Layer(
      name: 'Untitled layer',
      data: GBitmap(
        _canvasController.width,
        _canvasController.height,
        config: GBitmapConfig.rgba,
      ),
      isVisible: true,
    );
    state = state.copyWith(
      layers: [newLayer, ...state.layers],
    );
  }

  void invalidateActiveLayer() {
    _canvasController.invalidateLayers();

    final index = state.selectedLayerIndex;
    final oldLayer = state.layers[index];

    final updatedLayer = oldLayer.copyWith(
      data: _canvasController.selectedLayerRef.rootNode.process(null),
    );

    // no need to invalidate as u can just use relationship

    final updatedLayers = [...state.layers];
    updatedLayers[index] = updatedLayer;
    
    state = state.copyWith(
      layers: updatedLayers,
    );
  }

  void deleteLayer(int layerIndex) {
    _canvasController.deleteLayer(layerIndex);

    final updatedLayers = List.of(state.layers)..removeAt(layerIndex);

    int newSelectedIndex = state.selectedLayerIndex;
    if (layerIndex <= newSelectedIndex) {
      newSelectedIndex =
          (state.selectedLayerIndex - 1).clamp(0, updatedLayers.length - 1);
    }

    state = state.copyWith(
      layers: updatedLayers,
      selectedLayerIndex: newSelectedIndex,
    );
  }

  void toggleLayerVisibility(int layerIndex) {
    _canvasController.toggleLayerVisibility(layerIndex);

    final updatedLayers = List.of(state.layers);
    final layerToModify = updatedLayers[layerIndex];

    updatedLayers[layerIndex] = layerToModify.copyWith(
      isVisible: !layerToModify.isVisible,
    );

    state = state.copyWith(layers: updatedLayers);
  }

  void changeColor(GColor newColor) {
    state = state.copyWith(selectedColor: newColor);
  }

  void changeColorIndex(int newColorIndex) {
    state = state.copyWith(selectedColorIndex: newColorIndex);
  }

  void changeToolType(ToolType newToolType) {
    state = state.copyWith(selectedTool: _createToolFromType(newToolType));
  }

  void changeLayerIndex(int newLayerIndex) {
    _canvasController.selectedLayerRefIndex = newLayerIndex;

    state = state.copyWith(selectedLayerIndex: newLayerIndex);
  }
}

final drawingStateProvider =
    NotifierProvider<_DrawingStateNotifier, DrawingState>(() {
  return _DrawingStateNotifier();
});

final canvasControllerProvider = Provider<CanvasController>((ref) {
  return CanvasController(width: 50, height: 50);
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
