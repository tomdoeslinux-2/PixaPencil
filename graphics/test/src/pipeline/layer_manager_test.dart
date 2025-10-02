import 'package:graphics/graphics.dart';
import 'package:graphics/src/utils.dart';
import 'package:test/test.dart';
import '../../utils.dart';

void main() {
  group("Layer rendering tests", () {
    late final SourceNode layerBackground;
    late final SourceNode layerA;
    late final SourceNode layerB;
    late final SourceNode layerC;

    setUpAll(() async {
      layerBackground = SourceNode(
          source:
              await loadBitmapFromImage("$testAssetPath/layer_bg.png", 22, 22));
      layerA = SourceNode(
          source:
              await loadBitmapFromImage("$testAssetPath/layer_a.png", 11, 11));
      layerB = SourceNode(
          source:
              await loadBitmapFromImage("$testAssetPath/layer_b.png", 14, 14));
      layerC = SourceNode(
          source:
              await loadBitmapFromImage("$testAssetPath/layer_c.png", 22, 22));
    });

    test("layers a b added matches expected output", () async {
      final layerGraph = RenderingEngine(
        layerBackground,
        outputRoi: GRect(
          x: 0,
          y: 0,
          width: 22,
          height: 22,
        ),
      );

      final layerManager = LayerManager(layerGraph);
      layerManager.addLayer(layerA);
      layerManager.addLayer(layerB);

      final outputBitmap = layerGraph.render();
      saveBitmapToLocalDir(outputBitmap, "output.png");
      final expectedBitmap =
          await loadBitmapFromImage("$testAssetPath/layers_a_b.png", 22, 22);

      expect(bitmapsAreEqual(outputBitmap, expectedBitmap), isTrue);
      expect(layerManager.layers.length, equals(3));

      expect(layerManager.layers.first.rootNode.id, equals(layerBackground.id));
      expect(layerManager.layers[1].rootNode.id, equals(layerA.id));
      expect(layerManager.layers[2].rootNode.id, equals(layerB.id));
    });

    test("insert layer c at position 1 in layers a b", () async {
      final layerGraph = RenderingEngine(
        layerBackground,
        outputRoi: GRect(
          x: 0,
          y: 0,
          width: 22,
          height: 22,
        ),
      );

      final layerManager = LayerManager(layerGraph);
      layerManager.addLayer(layerA);
      layerManager.addLayer(layerB);
      layerManager.addLayer(layerC, position: 1);

      final outputBitmap = layerGraph.render();
      final expectedBitmap =
          await loadBitmapFromImage("$testAssetPath/layers_c_a_b.png", 22, 22);

      expect(bitmapsAreEqual(outputBitmap, expectedBitmap), isTrue);
      expect(layerManager.layers.length, equals(4));

      expect(layerManager.layers.first.rootNode.id, equals(layerBackground.id));
      expect(layerManager.layers[1].rootNode.id, equals(layerC.id));
      expect(layerManager.layers[2].rootNode.id, equals(layerA.id));
      expect(layerManager.layers[3].rootNode.id, equals(layerB.id));
    });

    test("insert layer c at position 2 in layers a b", () async {
      final layerGraph = RenderingEngine(
        layerBackground,
        outputRoi: GRect(
          x: 0,
          y: 0,
          width: 22,
          height: 22,
        ),
      );

      final layerManager = LayerManager(layerGraph);
      layerManager.addLayer(layerA);
      layerManager.addLayer(layerB);
      layerManager.addLayer(layerC, position: 2);

      final outputBitmap = layerGraph.render();
      final expectedBitmap =
          await loadBitmapFromImage("$testAssetPath/layers_a_c_b.png", 22, 22);

      expect(bitmapsAreEqual(outputBitmap, expectedBitmap), isTrue);
      expect(layerManager.layers.length, equals(4));

      expect(layerManager.layers.first.rootNode.id, equals(layerBackground.id));
      expect(layerManager.layers[1].rootNode.id, equals(layerA.id));
      expect(layerManager.layers[2].rootNode.id, equals(layerC.id));
      expect(layerManager.layers[3].rootNode.id, equals(layerB.id));
    });

    test("remove layer b in layers a b", () async {
      final layerGraph = RenderingEngine(
        layerBackground,
        outputRoi: GRect(
          x: 0,
          y: 0,
          width: 22,
          height: 22,
        ),
      );

      final layerManager = LayerManager(layerGraph);
      layerManager.addLayer(layerA);
      layerManager.addLayer(layerB);

      layerManager.deleteLayer(2);

      final outputBitmap = layerGraph.render();
      final expectedBitmap =
          await loadBitmapFromImage("$testAssetPath/layers_a.png", 22, 22);

      expect(bitmapsAreEqual(outputBitmap, expectedBitmap), isTrue);
      expect(layerManager.layers.length, equals(2));
      expect(layerManager.layers.first.rootNode.id, equals(layerBackground.id));
      expect(layerManager.layers[1].rootNode.id, equals(layerA.id));
    });

    test("remove layer a in layers a b", () async {
      final layerGraph = RenderingEngine(
        layerBackground,
        outputRoi: GRect(
          x: 0,
          y: 0,
          width: 22,
          height: 22,
        ),
      );

      final layerManager = LayerManager(layerGraph);
      layerManager.addLayer(layerA);
      layerManager.addLayer(layerB);

      layerManager.deleteLayer(1);

      final outputBitmap = layerGraph.render();
      final expectedBitmap =
          await loadBitmapFromImage("$testAssetPath/layers_b.png", 22, 22);

      expect(bitmapsAreEqual(outputBitmap, expectedBitmap), isTrue);
      expect(layerManager.layers.length, equals(2));
      expect(layerManager.layers.first.rootNode.id, equals(layerBackground.id));
      expect(layerManager.layers[1].rootNode.id, equals(layerB.id));
    });

    test("remove layer b in layers a b c", () async {
      final layerGraph = RenderingEngine(
        layerBackground,
        outputRoi: GRect(
          x: 0,
          y: 0,
          width: 22,
          height: 22,
        ),
      );

      final layerManager = LayerManager(layerGraph);
      layerManager.addLayer(layerA);
      layerManager.addLayer(layerB);
      layerManager.addLayer(layerC);

      layerManager.deleteLayer(2);

      final outputBitmap = layerGraph.render();
      final expectedBitmap =
          await loadBitmapFromImage("$testAssetPath/layers_a_c.png", 22, 22);

      expect(bitmapsAreEqual(outputBitmap, expectedBitmap), isTrue);
      expect(layerManager.layers.length, equals(3));
      expect(layerManager.layers.first.rootNode.id, equals(layerBackground.id));
      expect(layerManager.layers[1].rootNode.id, equals(layerA.id));
      expect(layerManager.layers[2].rootNode.id, equals(layerC.id));
    });
  });

  group("Layer switching optimization tests", () {
    late final SourceNode sky;
    late final SourceNode grass;
    late final SourceNode stickFigure;
    late final SourceNode sun;
    late final SourceNode clouds;

    late final RenderingEngine renderingEngine;
    late final LayerManager layerManager;

    setUpAll(() async {
      sky = SourceNode(
          source: await loadBitmapFromImage('$testAssetPath/sky.png'));
      grass = SourceNode(
          source: await loadBitmapFromImage('$testAssetPath/grass.png'));
      stickFigure = SourceNode(
          source: await loadBitmapFromImage('$testAssetPath/stick_figure.png'));
      sun = SourceNode(
          source: await loadBitmapFromImage('$testAssetPath/sun.png'));
      clouds = SourceNode(
          source: await loadBitmapFromImage('$testAssetPath/clouds.png'));

      renderingEngine = RenderingEngine(
        sky,
        outputRoi: sky.source.toRect(),
      );

      layerManager = LayerManager(renderingEngine,
          enableDynamicLayerSwitchingOptimization: true);
      layerManager.addLayer(grass);
      layerManager.addLayer(stickFigure);
      layerManager.addLayer(sun);
      layerManager.addLayer(clouds);
    });

    test('cache works properly (for layer index of 2)', () async {
      final expectedOutput =
          await loadBitmapFromImage('$testAssetPath/example_scene.png');
      expect(bitmapsAreEqual(renderingEngine.render(), expectedOutput), isTrue);

      expect(layerManager.activeLayerIndex, equals(0));
      layerManager.activeLayerIndex = 2;
      expect(layerManager.activeLayerIndex, equals(2));

      expect(layerManager.layers[2].overNode!.cache.size(), equals(0));

      final overNodeWithOverlayCache = layerManager.layers[3].overNode!;
      expect(overNodeWithOverlayCache.cache.size(), equals(1));
      expect(overNodeWithOverlayCache.cache.has(kOverlayNodeCacheKeyOverlay),
          isTrue);
      expect(
        bitmapsAreEqual(
          overNodeWithOverlayCache.cache.retrieve(kOverlayNodeCacheKeyOverlay)!,
          GBitmap.overlay(sun.source, clouds.source),
        ),
        isTrue,
      );

      final overNodeWithResultCache = layerManager.layers.first.overNode!;
      expect(overNodeWithResultCache.cache.size(), equals(1));
      expect(overNodeWithResultCache.cache.has(kOverlayNodeCacheKeyResult),
          isTrue);
      expect(
        bitmapsAreEqual(
          overNodeWithResultCache.cache.retrieve(kOverlayNodeCacheKeyResult)!,
          GBitmap.overlay(sky.source, grass.source),
        ),
        isTrue,
      );

      expect(
          layerManager.layers
              .map((layer) => layer.overNode!)
              .toSet()
              .where((node) => node.cache.size() > 0)
              .length,
          equals(2));

      // check result
      expect(bitmapsAreEqual(renderingEngine.render(), expectedOutput), isTrue);
    });

    test('cache works properly (for layer index of 1)', () async {
      layerManager.activeLayerIndex = 1;
      expect(layerManager.activeLayerIndex, equals(1));

      expect(layerManager.layers[0].overNode!.isPassthrough, isFalse);
      expect(layerManager.layers[2].overNode!.isPassthrough, isFalse);
      expect(layerManager.layers[3].overNode!.isPassthrough, isTrue);
      expect(layerManager.layers[4].overNode!.isPassthrough, isTrue);

      final overNodeWithBackgroundCache = layerManager.layers[0].overNode!;
      expect(overNodeWithBackgroundCache.cache.size(), equals(1));
      expect(
          overNodeWithBackgroundCache.cache.has(kOverlayNodeCacheKeyBackground),
          isTrue);
      expect(
          bitmapsAreEqual(
              overNodeWithBackgroundCache.cache
                  .retrieve(kOverlayNodeCacheKeyBackground)!,
              sky.source),
          isTrue);

      final overNodeWithOverlayCache = layerManager.layers[2].overNode!;
      expect(overNodeWithOverlayCache.cache.size(), equals(1));
      expect(overNodeWithOverlayCache.cache.has(kOverlayNodeCacheKeyOverlay),
          isTrue);
      expect(
          bitmapsAreEqual(
              overNodeWithOverlayCache.cache
                  .retrieve(kOverlayNodeCacheKeyOverlay)!,
              GBitmap.overlay(GBitmap.overlay(stickFigure.source, sun.source),
                  clouds.source)),
          isTrue);
    });

    test('cache works properly (for layer index of 0)', () async {
      layerManager.activeLayerIndex = 0;
      expect(layerManager.activeLayerIndex, equals(0));

      expect(layerManager.layers[2].overNode!.isPassthrough, isTrue);
      expect(layerManager.layers[3].overNode!.isPassthrough, isTrue);
      expect(layerManager.layers[4].overNode!.isPassthrough, isTrue);

      final overNodeWithOverlayCache = layerManager.layers[0].overNode!;
      expect(overNodeWithOverlayCache.cache.size(), equals(1));
      expect(overNodeWithOverlayCache.cache.has(kOverlayNodeCacheKeyOverlay),
          isTrue);
      expect(
          bitmapsAreEqual(
            overNodeWithOverlayCache.cache
                .retrieve(kOverlayNodeCacheKeyOverlay)!,
            GBitmap.overlay(
              GBitmap.overlay(
                GBitmap.overlay(grass.source, stickFigure.source),
                sun.source,
              ),
              clouds.source,
            ),
          ),
          isTrue);

      final expectedOutput =
          await loadBitmapFromImage('$testAssetPath/example_scene.png');
      expect(
          layerManager.layers
              .map((layer) => layer.overNode!)
              .toSet()
              .where((node) => node.cache.size() > 0)
              .length,
          equals(1));
      expect(bitmapsAreEqual(renderingEngine.render(), expectedOutput), isTrue);
    });
  });

  group("Layer operation tests", () {
    late final SourceNode sky;
    late final SourceNode grass;
    late final SourceNode stickFigure;
    late final SourceNode sun;
    late final SourceNode clouds;

    late final RenderingEngine renderingEngine;
    late final LayerManager layerManager;

    setUpAll(() async {
      sky = SourceNode(
          source: await loadBitmapFromImage('$testAssetPath/sky.png'));
      grass = SourceNode(
          source: await loadBitmapFromImage('$testAssetPath/grass.png'));
      stickFigure = SourceNode(
          source: await loadBitmapFromImage('$testAssetPath/stick_figure.png'));
      sun = SourceNode(
          source: await loadBitmapFromImage('$testAssetPath/sun.png'));
      clouds = SourceNode(
          source: await loadBitmapFromImage('$testAssetPath/clouds.png'));

      renderingEngine = RenderingEngine(
        sky,
        outputRoi: sky.source.toRect(),
      );

      layerManager = LayerManager(renderingEngine,
          enableDynamicLayerSwitchingOptimization: true);
      layerManager.addLayer(grass);
      layerManager.addLayer(stickFigure);
      layerManager.addLayer(sun);
      layerManager.addLayer(clouds);
    });

    test('hiding bottommost layer works as expected', () async {
      await exportGraphToPNG(layerManager.renderingEngine.rootNode, "before_graph");
      saveBitmapToLocalDir(renderingEngine.render(), "before.png");

      layerManager.activeLayerIndex = 0;
      layerManager.toggleLayerVisibility(2);

      saveBitmapToLocalDir(renderingEngine.render(), "after.png");
      await exportGraphToPNG(layerManager.renderingEngine.rootNode, "after_graph");
    });
  });
}
