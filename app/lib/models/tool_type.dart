import 'package:app/models/canvas_controller.dart';

import 'pencil_tool.dart';
import 'tool.dart';

enum ToolType {
  pencil,
  eraser;

  Tool getToolInstance(CanvasController canvasController) {
    switch (this) {
      case ToolType.pencil:
        return PencilTool(canvasController: canvasController);
      case ToolType.eraser:
        return PencilTool(isEraser: true, canvasController: canvasController);
    }
  }
}
