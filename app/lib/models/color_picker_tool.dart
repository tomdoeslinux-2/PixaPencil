import 'package:app/models/tool.dart';
import 'package:graphics/graphics.dart';

class ColorPickerTool extends Tool {
  late final GBitmap _activeLayerBitmap;
  void Function(GColor) onColorSelected;

  // todo just pass active layer obj
  ColorPickerTool({
    required super.canvasController,
    required this.onColorSelected,
  }) {
    _activeLayerBitmap =
        canvasController.selectedLayerRef.rootNode.process(null);
  }

  void _selectColor(GPoint point) {
    final colorAtPos = _activeLayerBitmap.getPixel(point.x, point.y);
    onColorSelected(colorAtPos);
  }

  @override
  void onTouchDown(GPoint point) {
    _selectColor(point);
  }

  @override
  void onTouchMove(GPoint point) {
    _selectColor(point);
  }

  @override
  void onTouchUp() {
    return;
  }
}
