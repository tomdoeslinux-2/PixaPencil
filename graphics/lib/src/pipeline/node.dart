import "../core/bitmap.dart";
import "../core/rect.dart";

abstract class Node {
  static var _idCounter = 0;
  final int id;

  Node? _inputNode;
  Node? _auxNode;
  Node? parentNode;

  Node({required Node? inputNode, Node? auxNode})
      : id = _generateId(),
        _inputNode = inputNode,
        _auxNode = auxNode {
    _inputNode?.parentNode = this;
    _auxNode?.parentNode = this;
  }

  Node? get inputNode => _inputNode;
  set inputNode(Node? node) {
    _inputNode = node;
    node?.parentNode = this;
  }

  Node? get auxNode => _auxNode;
  set auxNode(Node? node) {
    _auxNode = node;
    node?.parentNode = this;
  }

  static int _generateId() {
    return _idCounter++;
  }

  GRect get boundingBox;

  GBitmap operation(GRect? roi);

  GBitmap process(GRect? roi) {
    final bitmap = operation(roi);

    return bitmap;
  }
}
