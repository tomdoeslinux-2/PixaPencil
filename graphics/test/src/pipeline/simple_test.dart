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
  
  await exportGraphToPNG(engine.rootNode, 'before_reordering');
  layerManager.reorderLayer(0, 4);
  await exportGraphToPNG(engine.rootNode, 'after_reordering');
  await saveBitmapToLocalDir(engine.render(), 'after_reordering_out.png');
}
