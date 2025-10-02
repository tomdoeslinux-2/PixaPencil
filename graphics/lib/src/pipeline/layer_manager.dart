import 'package:collection/collection.dart';
import 'package:graphics/graphics.dart';

import 'graph_traversal.dart';

class LayerNodeReference {
  final Node rootNode;
  final OverlayNode? overNode;
  bool isVisible = true;

  LayerNodeReference(this.rootNode, this.overNode);
}

class LayerManager {
  final RenderingEngine renderingEngine;
  var layers = <LayerNodeReference>[];

  final bool enableDynamicLayerSwitchingOptimization;
  int _activeLayerIndex = 0;

  LayerManager(this.renderingEngine,
      {this.enableDynamicLayerSwitchingOptimization = false}) {
    populateLayers();
    _optimizeGraphForActiveLayer();
  }

  int get activeLayerIndex {
    if (!enableDynamicLayerSwitchingOptimization) {
      throw StateError(
          'Accessing activeLayerIndex is not allowed when dynamic optimization is disabled');
    }
    return _activeLayerIndex;
  }

  set activeLayerIndex(int layerIndex) {
    if (!enableDynamicLayerSwitchingOptimization) {
      throw StateError(
          'Modifying activeLayerIndex is not allowed when dynamic optimization is disabled');
    }

    if (layerIndex < 0 || layerIndex >= layers.length) {
      throw RangeError.index(
        layerIndex,
        layers,
        'activeLayerIndex',
        'Layer index is out of bounds',
        layers.length,
      );
    }

    if (layerIndex == _activeLayerIndex) return;

    _activeLayerIndex = layerIndex;
    _optimizeGraphForActiveLayer();
  }

  void _optimizeGraphForActiveLayer() {
    if (!enableDynamicLayerSwitchingOptimization || layers.length == 1) {
      return;
    }

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

        if (!layer.isVisible) {
          layer.overNode!.isPassthrough = true;
          continue;
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

      if (layers.length >= 5) {
        saveBitmapToLocalDir(compositedAbove!,
            "composited_act_layer_index_${activeLayerIndex}_${layers[3]
                .isVisible}.png");
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
    }

    if (targetLayerNode.inputNode is OverlayNode) {
      final compositedBelow =
          targetLayerNode.inputNode!.process(renderingEngine.outputRoi);
      (targetLayerNode.inputNode as OverlayNode)
          .cache
          .store(kOverlayNodeCacheKeyResult, compositedBelow);
    }

    if (targetLayerNode.inputNode == targetLayer.rootNode &&
        targetLayerNode.parentNode == null) {
      targetLayerNode.cache.store(
          kOverlayNodeCacheKeyOverlay, targetLayerNode.auxNode!.process(null));
    } else if (targetLayerNode.auxNode == targetLayer.rootNode &&
        targetLayerNode.parentNode == null) {
      targetLayerNode.cache.store(kOverlayNodeCacheKeyBackground,
          targetLayerNode.inputNode!.process(null));
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
      final layer = LayerNodeReference(renderingEngine.rootNode, null);
      layers.add(layer);

      return;
    }

    for (final (_, node) in layerNodes.indexed) {
      final layer = LayerNodeReference(node, node.parentNode as OverlayNode);
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
    _optimizeGraphForActiveLayer();
  }

  void deleteLayer(int layerIndex) {
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
    _optimizeGraphForActiveLayer();
  }

  void reorderLayer(int sourceIndex, int destinationIndex) {
    final layersToShift = layers
        .whereIndexed(
            (index, _) => index >= sourceIndex && index <= destinationIndex)
        .toList();

    LayerNodeReference? prevLayer;

    final firstLayer = layersToShift.first;
    if (firstLayer.overNode!.inputNode == firstLayer.rootNode) {
      final curInput = firstLayer.overNode!.auxNode;
      firstLayer.overNode!.auxNode = firstLayer.overNode!.inputNode;
      firstLayer.overNode!.inputNode = curInput;
      prevLayer = layersToShift[1];
      layersToShift.removeRange(0, 2);
    }

    for (final layer in layersToShift) {
      if (prevLayer == null) {
        prevLayer = layer;
        continue;
      }

      final curAux = layer.overNode!.auxNode;
      final newAux = prevLayer.overNode!.auxNode;
      layer.overNode!.auxNode = newAux;
      prevLayer.overNode!.auxNode = curAux;

      prevLayer = layer;
    }
  }

  void toggleLayerVisibility(int layerIndex) {
    final layerToToggle = layers[layerIndex];
    saveBitmapToLocalDir(layerToToggle.rootNode.process(null), "$layerIndex.png");

    layerToToggle.isVisible = !layerToToggle.isVisible;

    _optimizeGraphForActiveLayer();
  }
}
