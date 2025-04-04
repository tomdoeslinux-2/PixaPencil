import 'package:app/models/canvas_controller.dart';
import 'package:graphics/graphics.dart';

import 'pencil_tool.dart';
import 'tool.dart';

enum ToolType {
  pencil,
  eraser;

  Tool getToolInstance(CanvasController canvasController) {
    switch (this) {
      case ToolType.pencil:
        return PencilTool(canvasController: canvasController, getColor: () => GColors.black);
      case ToolType.eraser:
        return PencilTool(isEraser: true, canvasController: canvasController, getColor: () => GColors.black);
    }
  }
}
