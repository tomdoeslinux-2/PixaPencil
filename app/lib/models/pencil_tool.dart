import 'package:app/models/canvas_controller.dart';
import 'package:app/models/tool.dart';
import 'package:graphics/graphics.dart';

class PencilTool extends Tool {
  final CanvasController drawingController;
  final bool isEraser;

  PencilTool(super.drawingState, {required this.drawingController, this.isEraser = false});

  @override
  void onTouchDown(GPoint point) {
    drawingController.beginPath(GColors.black, point);
  }

  @override
  void onTouchMove(GPoint point) {
    drawingController.addPointToPath(point);
  }

  @override
  void onTouchUp() {
    drawingController.endPath();
  }
}
