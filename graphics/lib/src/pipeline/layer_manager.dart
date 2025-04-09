import 'package:collection/collection.dart';
import 'package:graphics/graphics.dart';

import 'graph_traversal.dart';
import 'node.dart';
import 'rendering_engine.dart';
import 'overlay_node.dart';

class Layer {
  final String name;
  final Node rootNode;
  final OverlayNode? overNode;

  const Layer(this.name, this.rootNode, this.overNode);

  @override
  String toString() {
    return 'Layer(name: "$name", rootNodeId: ${rootNode.id})';
  }
}

class LayerManager {
  final RenderingEngine renderingEngine;
  var layers = <Layer>[];
  int _activeLayerIndex = -1;

  LayerManager(this.renderingEngine) {
    populateLayers();
  }

  int get activeLayerIndex => _activeLayerIndex;

  set activeLayerIndex(int layerIndex) {
    if (layerIndex == _activeLayerIndex) return;

    _activeLayerIndex = layerIndex;
    _optimizeGraphForActiveLayer();
  }

  void _optimizeGraphForActiveLayer() {
    for (final layer in layers) {
      layer.overNode!.isPassthrough = false;
      layer.overNode!.cache.clear();
    }

    GBitmap? compositedAbove;
    final targetLayer = layers[_activeLayerIndex];
    final targetLayerNode = targetLayer.overNode!;

    if (targetLayerNode.parentNode != null) {
      final isInputFromBottommostLayer =
          (targetLayerNode.inputNode is! OverlayNode &&
              targetLayerNode.inputNode == targetLayer.rootNode);

      for (final layer in layers.reversed) {
        if (layer == targetLayer) {
          break;
        }

        if (isInputFromBottommostLayer && targetLayerNode != layer.overNode) {
          layer.overNode!.isPassthrough = true;
        }

        if (!isInputFromBottommostLayer &&
            layer.overNode != targetLayerNode.parentNode) {
          layer.overNode!.isPassthrough = true;
        }

        if (compositedAbove == null) {
          compositedAbove ??= layer.rootNode.process(null);
          continue;
        }

        compositedAbove =
            GBitmap.overlay(layer.rootNode.process(null), compositedAbove);
      }

      final target = isInputFromBottommostLayer
          ? targetLayerNode
          : targetLayerNode.parentNode;
      (target as OverlayNode)
          .cache
          .store(kOverlayNodeCacheKeyOverlay, compositedAbove!);

      if (targetLayerNode.inputNode is! OverlayNode &&
          targetLayerNode.auxNode == targetLayer.rootNode) {
        targetLayerNode.cache.store(kOverlayNodeCacheKeyBackground,
            targetLayerNode.inputNode!.process(null));
      }
    } else if (targetLayerNode.inputNode is OverlayNode) {
      final compositedBelow =
          targetLayerNode.inputNode!.process(renderingEngine.outputRoi);
      (targetLayerNode.inputNode as OverlayNode)
          .cache
          .store(kOverlayNodeCacheKeyResult, compositedBelow);
    } else if (targetLayerNode.inputNode == targetLayer.rootNode) {
      targetLayerNode
          .cache
          .store(kOverlayNodeCacheKeyOverlay, targetLayerNode.auxNode!.process(null));
    } else if (targetLayerNode.auxNode == targetLayer.rootNode) {
      targetLayerNode
          .cache
          .store(kOverlayNodeCacheKeyBackground, targetLayerNode.inputNode!.process(null));
    }
  }

  void populateLayers() {
    layers.clear();

    final layerNodes = <Node>[];

    traverseGraphBFS(renderingEngine.rootNode, (node) {
      if (node is OverlayNode) {
        if (node.auxNode != null && node.auxNode is! OverlayNode) {
          layerNodes.add(node.auxNode!);
        }

        if (node.inputNode != null && node.inputNode is! OverlayNode) {
          layerNodes.add(node.inputNode!);
        }
      }
    });

    if (layerNodes.isEmpty) {
      final layer = Layer("Layer 0", renderingEngine.rootNode, null);
      layers.add(layer);

      return;
    }

    for (final (indx, node) in layerNodes.indexed) {
      final layer = Layer("Layer ${layerNodes.length - indx}", node,
          node.parentNode as OverlayNode);
      layers.insert(0, layer);
    }
  }

  void addLayer(Node newLayer, {int? position}) {
    final insertIndex = position ?? layers.length;

    if (insertIndex == layers.length) {
      final overlayNode =
          OverlayNode(inputNode: renderingEngine.rootNode, auxNode: newLayer);
      renderingEngine.rootNode = overlayNode;
    } else {
      final existingLayer = layers[insertIndex];
      final node = existingLayer.rootNode;

      // we create copy to avoid circular reference
      final parent = node.parentNode;
      final overlayNode =
          OverlayNode(inputNode: parent?.inputNode, auxNode: newLayer);
      parent?.inputNode = overlayNode;
    }

    renderingEngine.populateNodeCache();
    populateLayers();
  }

  void removeLayer(int layerIndex) {
    final layerNode = layers[layerIndex].rootNode;
    final parent = layerNode.parentNode;

    if (parent?.inputNode?.id == layerNode.id) {
      if (parent?.parentNode == null) {
        renderingEngine.rootNode = parent!.auxNode!;
        renderingEngine.rootNode.parentNode = null;
      } else {
        parent?.parentNode?.inputNode = parent.auxNode;
      }
    } else if (parent?.auxNode?.id == layerNode.id) {
      if (parent?.parentNode == null) {
        renderingEngine.rootNode = parent!.inputNode!;
        renderingEngine.rootNode.parentNode = null;
      } else {
        parent?.parentNode?.inputNode = parent.inputNode;
      }
    }

    renderingEngine.populateNodeCache();
    populateLayers();
  }
}
