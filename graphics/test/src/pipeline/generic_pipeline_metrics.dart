import 'package:graphics/graphics.dart';
import 'package:graphics/src/pipeline/ellipse_node.dart';
import 'package:graphics/src/utils.dart';

import '../../utils.dart';

void main() async {
  final nodeGraph = RenderingEngine(
    SourceNode(
      source: GBitmap(500, 500, config: GBitmapConfig.rgba)..fillColor(GColors.green),
    ),
    outputRoi: GRect(x: 0, y: 0, width: 500, height: 500),
  );

  final layerManager = LayerManager(nodeGraph);
  layerManager.addLayer(
    EllipseNode(
      from: (x: 0, y: 0),
      to: (x: 300, y: 499),
      color: GColors.red,
      inputNode: SourceNode(
        source: GBitmap(500, 500, config: GBitmapConfig.rgba),
      ),
    ),
  );
  layerManager.addLayer(
    BlurNode(
      radius: 1,
      inputNode: PathNode(
        color: GColors.red,
        path: [
          (x: 0, y: 0),
          (x: 55, y: 95),
          (x: 399, y: 34),
          (x: 0, y: 499),
          (x: 200, y: 200),
          (x: 499, y: 499),
        ],
        inputNode: SourceNode(
          source: GBitmap(500, 500, config: GBitmapConfig.rgba),
        ),
      ),
    ),
  );

  saveBitmapToLocalDir(nodeGraph.render(), "output.png");
  exportGraphToPNG(nodeGraph.rootNode, "output_graph");

  benchmark(() {
    nodeGraph.render();
  }, iterations: 1);
}
