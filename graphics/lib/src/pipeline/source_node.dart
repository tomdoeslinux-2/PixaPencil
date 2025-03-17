import '../core/bitmap.dart';
import '../core/rect.dart';
import 'node.dart';

class SourceNode extends Node {
  final GBitmap source;

  SourceNode({required this.source}) : super(inputNode: null);

  @override
  GBitmap operation(GRect? roi) {
    return roi != null ? source.crop(roi) : source;
  }

  @override
  GRect get boundingBox =>
      GRect(x: 0, y: 0, width: source.width, height: source.height);
}
