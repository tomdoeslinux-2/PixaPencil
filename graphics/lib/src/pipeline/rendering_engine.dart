import 'package:graphics/graphics.dart';
import 'package:graphics/src/utils.dart';
import 'graph_traversal.dart';

class RenderingEngine {
  Node rootNode;
  final Map<int, Node> nodeCache = {};
  GRect outputRoi;

  RenderingEngine(this.rootNode, {required this.outputRoi}) {
    populateNodeCache();
  }

  void populateNodeCache() {
    traverseGraphBFS(rootNode, (node) {
      nodeCache[node.id] = node;
    });
  }

  GBitmap render() {
    final stopwatch = Stopwatch()..start();

    final bmp = rootNode.process(outputRoi);

    stopwatch.stop();
    final elapsedMs = stopwatch.elapsedMilliseconds;
    print('Render completed in ${elapsedMs}ms');

    return bmp;
  }
  
}
