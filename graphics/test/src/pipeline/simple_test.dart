import 'package:graphics/graphics.dart';
import 'package:graphics/src/core/color.dart';
import 'package:graphics/src/core/rect.dart';
import 'package:graphics/src/pipeline/ellipse_node.dart';
import 'package:graphics/src/pipeline/rendering_engine.dart';
import 'package:graphics/src/pipeline/source_node.dart';
import 'package:graphics/src/utils.dart';

import '../../utils.dart';

void main() async {
  final layer1Image = await loadBitmapFromImage('$testAssetPath/sky.png');
  final layer2Image = await loadBitmapFromImage('$testAssetPath/grass.png');
  final layer3Image =
      await loadBitmapFromImage('$testAssetPath/stick_figure.png');
  final layer4Image = await loadBitmapFromImage('$testAssetPath/sun.png');
  final layer5Image = await loadBitmapFromImage('$testAssetPath/clouds.png');

  final engine = RenderingEngine(SourceNode(source: layer1Image), outputRoi: layer1Image.toRect());

  final layerManager = LayerManager(engine);
  layerManager.addLayer(SourceNode(source: layer2Image));
  layerManager.addLayer(SourceNode(source: layer3Image));
  layerManager.addLayer(SourceNode(source: layer4Image));
  layerManager.addLayer(SourceNode(source: layer5Image));

  layerManager.activeLayerIndex = 0;

  await exportGraphToPNG(engine.rootNode, 'test');
  saveBitmapToLocalDir(engine.render(), 'test_out.png');
  print("xxx");
    saveBitmapToLocalDir(engine.render(), 'test_out2.png');
}
