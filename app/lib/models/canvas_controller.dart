import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:graphics/graphics.dart';

class CanvasController {
  final int width;
  final int height;

  final RenderingEngine _engine;
  late final LayerManager _layerManager;
  PathNode? _activePathNode;

  int _selectedLayerRefIndex = 0;
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
    _layerManager =
        LayerManager(_engine, enableDynamicLayerSwitchingOptimization: true);
  }

  LayerNodeReference get selectedLayerRef => layerRefs[_selectedLayerRefIndex];

  List<LayerNodeReference> get layerRefs => _layerManager.layers;

  Node get rootNode => _engine.rootNode;

  int get selectedLayerRefIndex => _selectedLayerRefIndex;

  set selectedLayerRefIndex(int selectedLayerRefIndex) {
    _selectedLayerRefIndex = selectedLayerRefIndex;
    _layerManager.activeLayerIndex = selectedLayerRefIndex;
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

  void deleteLayer(int layerIndex) {
    _layerManager.deleteLayer(layerIndex);
    notifyListeners();
  }

  void toggleLayerVisibility(int layerIndex) {
    _layerManager.toggleLayerVisibility(layerIndex);
    notifyListeners();
  }

  void beginPath(GColor color, GPoint startingPoint) {
    final currentLayer = _layerManager.layers[_selectedLayerRefIndex];

    final newPathNode = PathNode(
      color: color,
      path: [startingPoint],
    );

    currentLayer.rootNode.insertAbove(newPathNode, _engine);
    _activePathNode = newPathNode;
  }

  void invalidateLayers() {
    _layerManager.populateLayers();
  }

  void addPointToPath(GPoint point) {
    _activePathNode!.addPoint(point);
  }

  void endPath() {
    _activePathNode = null;
  }

  GBitmap draw() {
    return _engine.render();
  }
}
