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

  OverlayNode({super.inputNode, super.auxNode});

  @override
  GBitmap operation(GRect? roi) {
    if (_cache.has(kOverlayNodeCacheKeyResult)) {
      print('overlay node with id $id is returning cached result');
      return _cache.retrieve(kOverlayNodeCacheKeyResult)!;
    }

    GBitmap? backgroundBitmap;
    GBitmap? overlayBitmap;

    print('$id is being visited');

    if (_cache.has(kOverlayNodeCacheKeyBackground)) {
      print('overlay node with id $id is using cached background bitmap');
      backgroundBitmap = _cache.retrieve(kOverlayNodeCacheKeyBackground)!;
    } else {
      backgroundBitmap = inputNode!.process(roi);
    }

    if (_cache.has(kOverlayNodeCacheKeyOverlay)) {
      print('overlay node with id $id is using cached overlay bitmap');
      overlayBitmap = _cache.retrieve(kOverlayNodeCacheKeyOverlay)!;
    } else {
      overlayBitmap = auxNode!.process(null);
    }

    final mergedBitmap = GBitmap.overlay(backgroundBitmap, overlayBitmap);

    return mergedBitmap;
  }

  @override
  GRect get boundingBox =>
      GRect.union(inputNode!.boundingBox, auxNode!.boundingBox);
}
