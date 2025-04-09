import 'package:graphics/graphics.dart';
import 'package:test/test.dart';

class TestNode extends Node {
  bool didRunOperation = false;

  TestNode({required super.inputNode});

  @override
  GRect get boundingBox => GRect(x: 0, y: 0, width: 0, height: 0);

  @override
  GBitmap operation(GRect? roi) {
    didRunOperation = true;
    return GBitmap(0, 0, config: GBitmapConfig.rgb);
  }
}

void main() {
  group('Node tests', () {
    test('process calls own operation when isPassthrough is false', () {
      final node = TestNode(inputNode: null);
      node.isPassthrough = false;

      final result = node.process(null);

      expect(result, isA<GBitmap>());
      expect(node.didRunOperation, true);
    });

    test('process calls own operation when isPassthrough is true', () {
      final child = TestNode(inputNode: null);
      final parent = TestNode(inputNode: child);
      parent.isPassthrough = true;

      final result = parent.process(null);

      expect(result, isA<GBitmap>());
      expect(parent.didRunOperation, false);
      expect(child.didRunOperation, true);
    });
  });
}