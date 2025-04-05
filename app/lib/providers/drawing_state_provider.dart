import 'package:app/models/canvas_controller.dart';
import 'package:app/models/pencil_tool.dart';
import 'package:app/models/tool_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphics/graphics.dart';

import '../models/tool.dart';

class _DrawingState {
  final GColor selectedColor;
  final int selectedColorIndex;
  final Tool selectedTool;

  const _DrawingState({
    required this.selectedColor,
    required this.selectedColorIndex,
    required this.selectedTool,
  });

  _DrawingState copyWith({
    GColor? selectedColor,
    int? selectedColorIndex,
    Tool? selectedTool,
  }) {
    return _DrawingState(
      selectedColor: selectedColor ?? this.selectedColor,
      selectedColorIndex: selectedColorIndex ?? this.selectedColorIndex,
      selectedTool: selectedTool ?? this.selectedTool,
    );
  }
}

class _DrawingStateNotifier extends Notifier<_DrawingState> {
  Tool _createToolFromType(ToolType type) {
    final canvasController = ref.read(canvasControllerProvider);

    if (type == ToolType.pencil) {
      return PencilTool(
        getColor: () => state.selectedColor,
        canvasController: canvasController,
        isEraser: false,
      );
    } else {
      return PencilTool(
        getColor: () => state.selectedColor,
        canvasController: canvasController,
        isEraser: true,
      );
    }
  }

  @override
  _DrawingState build() {
    return _DrawingState(
      selectedColor: GColors.black,
      selectedColorIndex: 0,
      selectedTool: _createToolFromType(ToolType.pencil),
    );
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
}

final drawingStateProvider =
    NotifierProvider<_DrawingStateNotifier, _DrawingState>(() {
  return _DrawingStateNotifier();
});

final canvasControllerProvider = Provider<CanvasController>((ref) {
  return CanvasController(width: 100, height: 100);
});
