import 'package:graphics/graphics.dart';
import 'graph_traversal.dart';

class NodeGraph {
  Node rootNode;
  final Map<int, Node> nodeLUT = {};

  NodeGraph(this.rootNode) {
    populateNodeLUT();
  }

  void populateNodeLUT() {
    traverseGraphBFS(rootNode, (node) {
      nodeLUT[node.id] = node;
    });
  }

  GBitmap process(GRect outputRoi) {
    return rootNode.process(outputRoi);
  }
}