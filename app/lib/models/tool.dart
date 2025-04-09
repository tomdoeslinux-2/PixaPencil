import 'package:app/models/tool_type.dart';
import 'package:graphics/graphics.dart';

import 'canvas_controller.dart';

abstract class Tool {
  final CanvasController canvasController;

  Tool({required this.canvasController});

  void onTouchDown(GPoint point);
  void onTouchMove(GPoint point);
  void onTouchUp();
}
