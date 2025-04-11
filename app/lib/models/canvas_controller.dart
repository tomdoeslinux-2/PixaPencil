import 'dart:io';
import 'dart:ui';

import 'package:graphics/graphics.dart';

class CanvasController {
  final int width;
  final int height;

  int _selectedLayerIndex = 0;

  final RenderingEngine _engine;
  late final LayerManager _layerManager;
  PathNode? _activePathNode;

  final List<VoidCallback> _listeners = [];

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  CanvasController({required this.width, required this.height})
      : _engine = RenderingEngine(
          _createInitialGraph(width, height),
          outputRoi: GRect.fromLTRB(0, 0, width, height),
        ) {
    _layerManager = LayerManager(_engine);
  }

  Layer get selectedLayer => layers[_selectedLayerIndex];

  Node get rootNode => _engine.rootNode;

  List<Layer> get layers => _layerManager.layers;

  int get selectedLayerIndex => _selectedLayerIndex;

  set selectedLayerIndex(int selectedLayerIndex) {
    _selectedLayerIndex = selectedLayerIndex;
    _layerManager.activeLayerIndex = selectedLayerIndex;
  }

  LayerManager get layerManager => _layerManager;

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

    currentLayer.rootNode.insertAbove(newPathNode);
    _activePathNode = newPathNode;
  }

  void addPointToPath(GPoint point) {
    if (_activePathNode == null) beginPath(GColors.black, point);

    _activePathNode!.addPoint(point);
  }

  void toggleLayerVisibility(int layerIndex) {
    final overNode = selectedLayer.overNode;

    if (overNode!.inputNode == selectedLayer.rootNode) {
      overNode.isInputNodePassthrough = !overNode.isInputNodePassthrough;
    } else {
      overNode.isAuxNodePassthrough = !overNode.isAuxNodePassthrough;
    }

    notifyListeners();
  }

  void endPath() {
    _activePathNode = null;
  }

  GBitmap draw() {
    return _engine.render();
  }
}
