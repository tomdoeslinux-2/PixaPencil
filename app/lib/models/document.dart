import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/models/canvas_controller.dart';

import 'layer.dart';

Uint8List encodePxpDocument({
  required String title,
  required int width,
  required int height,
  required List<Layer> layers,
}) {
  final buffer = BytesBuilder();

  buffer.add(utf8.encode('PXP1'));
  buffer.add(utf8.encode(title));

  for (final l in layers) {
    buffer.add(_uint16(l.name.length));
    buffer.add(utf8.encode(l.name));
    buffer.addByte(l.isVisible ? 1 : 0);

    final compressedData = zlib.encode(l.data.pixels);
    buffer.add(_uint32(compressedData.length));
    buffer.add(compressedData);
  }

  return buffer.toBytes();
}

Uint8List _uint16(int value) {
  return Uint8List(2)..buffer.asByteData().setUint16(0, value, Endian.little);
}

Uint8List _uint32(int value) {
  return Uint8List(4)..buffer.asByteData().setUint32(0, value, Endian.little);
}
