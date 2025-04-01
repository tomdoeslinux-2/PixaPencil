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
}

const kOverlayNodeCacheKeyResult = 'result';
const kOverlayNodeCacheKeyOverlay = 'overlay';

class OverlayNode extends Node {
  final _cache = Cache();
  Cache get cache => _cache;

  OverlayNode({super.inputNode, super.auxNode});

  @override
  GBitmap operation(GRect? roi) {
    print('overlay node with id $id has been visited');

    if (_cache.has(kOverlayNodeCacheKeyResult)) {
      print('overlay node with id $id is returning cached result');
      return _cache.retrieve(kOverlayNodeCacheKeyResult)!;
    }

    final baseBitmap = inputNode!.process(roi);
    var overlayBitmap = auxNode!.process(null);

    if (_cache.has(kOverlayNodeCacheKeyOverlay)) {
      print('overlay node with id $id is using cached overlay bitmap');
      overlayBitmap = _cache.retrieve(kOverlayNodeCacheKeyOverlay)!;
    } else {
      overlayBitmap = auxNode!.process(null);
    }

    final overlayedBitmap = GBitmap.overlay(baseBitmap, overlayBitmap);

    return overlayedBitmap;
  }

  @override
  GRect get boundingBox =>
      GRect.union(inputNode!.boundingBox, auxNode!.boundingBox);
}
