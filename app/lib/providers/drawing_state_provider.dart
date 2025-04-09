import 'package:app/models/canvas_controller.dart';
import 'package:app/models/color_picker_tool.dart';
import 'package:app/models/eraser_tool.dart';
import 'package:app/models/pencil_tool.dart';
import 'package:app/models/tool_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphics/graphics.dart';

import '../models/tool.dart';

class _DrawingState {
  final GColor selectedColor;
  final int selectedColorIndex;
  final Tool selectedTool;
  final List<Layer> layers;
  final int selectedLayerIndex;

  const _DrawingState({
    required this.selectedColor,
    required this.selectedColorIndex,
    required this.selectedTool,
    required this.layers,
    required this.selectedLayerIndex,
  });

  _DrawingState copyWith({
    GColor? selectedColor,
    int? selectedColorIndex,
    Tool? selectedTool,
    List<Layer>? layers,
    int? selectedLayerIndex,
  }) {
    return _DrawingState(
      selectedColor: selectedColor ?? this.selectedColor,
      selectedColorIndex: selectedColorIndex ?? this.selectedColorIndex,
      selectedTool: selectedTool ?? this.selectedTool,
      layers: layers ?? this.layers,
      selectedLayerIndex: selectedLayerIndex ?? this.selectedLayerIndex,
    );
  }
}

class _DrawingStateNotifier extends Notifier<_DrawingState> {
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
  _DrawingState build() {
    final canvasController = ref.read(canvasControllerProvider);

    return _DrawingState(
      selectedColor: GColors.black,
      selectedColorIndex: 0,
      selectedTool: _createToolFromType(ToolType.pencil),
      layers: canvasController.layers,
      selectedLayerIndex: canvasController.selectedLayerIndex,
    );
  }

  void notifyLayersUpdated() {
    _canvasController.layerManager.populateLayers();

    state = state.copyWith(
      layers: _canvasController.layers,
    );
  }

  void createLayer() {
    _canvasController.addLayer();
    notifyLayersUpdated();
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
    _canvasController.selectedLayerIndex = newLayerIndex;
    state = state.copyWith(selectedLayerIndex: newLayerIndex);
  }
}

final drawingStateProvider =
    NotifierProvider<_DrawingStateNotifier, _DrawingState>(() {
  return _DrawingStateNotifier();
});

final canvasControllerProvider = Provider<CanvasController>((ref) {
  return CanvasController(width: 50, height: 50);
});
