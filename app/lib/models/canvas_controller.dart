import 'dart:io';

import 'package:graphics/graphics.dart';

class CanvasController {
  final int width;
  final int height;

  int _selectedLayerIndex = 1;

  final RenderingEngine _engine;
  late final LayerManager _layerManager;
  PathNode? _activePathNode;

  CanvasController({required this.width, required this.height})
      : _engine = RenderingEngine(
          _createInitialGraph(width, height),
          outputRoi: GRect.fromLTRB(0, 0, width, height),
        ) {
    _layerManager = LayerManager(_engine);
  }

  int get selectedLayerIndex => _selectedLayerIndex;

  set selectedLayerIndex(int selectedLayerIndex) {
    _selectedLayerIndex = selectedLayerIndex;
    _layerManager.activeLayerIndex = selectedLayerIndex;
  }

  static SourceNode _createInitialGraph(int width, int height) {
    return SourceNode(
      source: GBitmap(width, height, config: GBitmapConfig.rgba),
    );
  }

  void addLayer() {
    _layerManager.addLayer(
      SourceNode(
        source: GBitmap(width, height, config: GBitmapConfig.rgba),
      ),
    );
  }

  void beginPath(GColor color, GPoint startingPoint) {
    final currentLayer = _layerManager.layers[_selectedLayerIndex];

    final newPathNode = PathNode(
      color: color,
      path: [startingPoint],
    );

    currentLayer.overNode!.wrapInput(newPathNode);
    _activePathNode = newPathNode;
  }

  void addPointToPath(GPoint point) {
    if (_activePathNode == null) beginPath(GColors.black, point);

    _activePathNode!.addPoint(point);
  }

  void endPath() {
    _activePathNode = null;
  }

  GBitmap draw() {
    return _engine.render();
  }
}
