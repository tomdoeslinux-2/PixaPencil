import 'package:graphics/graphics.dart';
import 'package:graphics/src/core/bitmap.dart';
import 'package:graphics/src/core/rect.dart';
import 'package:graphics/src/pipeline/node.dart';

class Cache {
  final Map<String, GBitmap> _cache = {};

  void store(String key, GBitmap bitmap) {
    _cache[key] = bitmap;
  }

  GBitmap? retrieve(String key) {
    return _cache[key];
  }

  bool has(String key) {
    return _cache.containsKey(key);
  }

  int size() {
    return _cache.length;
  }

  void clear() {
    return _cache.clear();
  }
}

const kOverlayNodeCacheKeyResult = 'result';
const kOverlayNodeCacheKeyOverlay = 'overlay';
const kOverlayNodeCacheKeyBackground = 'background';

class OverlayNode extends Node {
  final _cache = Cache();
  Cache get cache => _cache;

  var isInputNodePassthrough = false;
  var isAuxNodePassthrough = false;

  OverlayNode({super.inputNode, super.auxNode});

  @override
  GBitmap operation(GRect? roi) {
    if (_cache.has(kOverlayNodeCacheKeyResult)) {
      return _cache.retrieve(kOverlayNodeCacheKeyResult)!;
    }

    GBitmap? backgroundBitmap;
    GBitmap? overlayBitmap;

    if (!isInputNodePassthrough && inputNode != null) {
      backgroundBitmap = _cache.has(kOverlayNodeCacheKeyBackground)
          ? _cache.retrieve(kOverlayNodeCacheKeyBackground)!
          : inputNode!.process(roi);
    }

    if (!isAuxNodePassthrough && auxNode != null) {
      overlayBitmap = _cache.has(kOverlayNodeCacheKeyOverlay)
          ? _cache.retrieve(kOverlayNodeCacheKeyOverlay)!
          : auxNode!.process(null);
    }

    if (backgroundBitmap != null && overlayBitmap != null) {
      return GBitmap.overlay(backgroundBitmap, overlayBitmap);
    } else if (overlayBitmap != null) {
      return overlayBitmap;
    } else if (backgroundBitmap != null) {
      return backgroundBitmap;
    }

    return GBitmap(1, 1, config: GBitmapConfig.rgba);
  }

  @override
  GRect get boundingBox =>
      GRect.union(inputNode!.boundingBox, auxNode!.boundingBox);
}
