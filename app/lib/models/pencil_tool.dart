import 'package:app/models/canvas_controller.dart';
import 'package:app/models/color_extensions.dart';
import 'package:app/models/tool.dart';
import 'package:app/models/tool_type.dart';
import 'package:graphics/graphics.dart';

class PencilTool extends Tool {
  final GColor Function() getColor;

  PencilTool({
    required this.getColor,
    required super.canvasController,
  });

  @override
  void onTouchDown(GPoint point) {
    canvasController.beginPath(getColor(), point);
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
