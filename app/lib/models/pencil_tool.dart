import 'package:app/models/canvas_controller.dart';
import 'package:app/models/tool.dart';
import 'package:graphics/graphics.dart';

class PencilTool extends Tool {
  final bool isEraser;

  PencilTool({this.isEraser = false, required super.canvasController});

  @override
  void onTouchDown(GPoint point) {
    canvasController.beginPath(GColors.black, point);
  }

  @override
  void onTouchMove(GPoint point) {
    canvasController.addPointToPath(point);
  }

  @override
  void onTouchUp() {
    canvasController.endPath();
  }
}
