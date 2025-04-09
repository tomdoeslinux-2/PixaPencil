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
    final bmp = rootNode.process(outputRoi);

    return bmp;
  }
  
}
