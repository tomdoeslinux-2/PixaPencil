import 'package:graphics/graphics.dart';
import 'package:graphics/src/utils.dart';
import 'package:test/test.dart';
import '../../utils.dart';

void main() {
  test(
    "layer benchmark - add and process single layer",
    () async {
      final layerBg = SourceNode(
          source: await loadBitmapFromImage(
              "$testAssetPath/layer_benchmark_bg.png"));
      final layerA = SourceNode(
          source: await loadBitmapFromImage(
              "$testAssetPath/layer_benchmark_a.png"));

      benchmark(() {
        final layerGraph = RenderingEngine(
          layerBg,
          outputRoi: GRect(
            x: 0,
            y: 0,
            width: layerBg.source.width,
            height: layerBg.source.height,
          ),
        );
        final layerManager = LayerManager(layerGraph);

        layerManager.addLayer(layerA);
        layerGraph.render();
      }, iterations: 800);

      expect(true, isTrue);
    },
  );
}
