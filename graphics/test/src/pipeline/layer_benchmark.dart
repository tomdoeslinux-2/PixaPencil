import 'package:graphics/graphics.dart';
import 'package:graphics/src/utils.dart';
import 'package:test/test.dart';
import '../../utils.dart';

void main() {
  group("Layer benchmark tests", () {
    late final SourceNode layerBg;
    late final SourceNode layerA;

    setUpAll(() async {
      layerBg = SourceNode(
          source: await loadBitmapFromImage(
              "$testAssetPath/layer_benchmark_bg.png"));
      layerA = SourceNode(
          source: await loadBitmapFromImage(
              "$testAssetPath/layer_benchmark_a.png"));
    });

    test(
      "layer benchmark - add and process single layer",
      () async {
        final layerGraph = RenderingEngine(
          layerBg,
          outputRoi: GRect(
            x: 0,
            y: 0,
            width: layerBg.source.width,
            height: layerBg.source.height,
          ),
        );
        final layerManager = LayerManager(layerGraph,
            enableDynamicLayerSwitchingOptimization: false);
        layerManager.addLayer(layerA);

        benchmark(() {
          layerGraph.render();
        }, iterations: 800);

        expect(true, isTrue);
      },
    );

    test(
      "layer benchmark - add and process single layer, active index 0",
      () async {
        final layerGraph = RenderingEngine(
          layerBg,
          outputRoi: GRect(
            x: 0,
            y: 0,
            width: layerBg.source.width,
            height: layerBg.source.height,
          ),
        );
        final layerManager = LayerManager(layerGraph,
            enableDynamicLayerSwitchingOptimization: true);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);
        layerManager.addLayer(layerA);

        layerManager.activeLayerIndex = 0;

        benchmark(() {
          layerGraph.render();
        }, iterations: 800);

        expect(true, isTrue);
      },
    );
  });
}
