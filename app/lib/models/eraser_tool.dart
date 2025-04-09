import 'package:app/models/tool.dart';
import 'package:graphics/graphics.dart';

class EraserTool extends Tool {
  EraserTool({required super.canvasController});

  @override
  void onTouchDown(GPoint point) {
    canvasController.beginPath(GColors.transparent, point);
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