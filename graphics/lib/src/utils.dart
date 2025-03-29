import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';
import 'core/bitmap.dart';
import 'pipeline/node.dart';
import 'package:http/http.dart' as http;

Future<GBitmap> loadBitmapFromImage(
  String filename, [
  int? width,
  int? height,
]) async {
  final file = File(filename);
  final fileBytes = await file.readAsBytes();
  final bytes = Uint8List.fromList(fileBytes);

  final image = decodeImage(bytes);
  final pixels = image!.getBytes();

  final GBitmapConfig config;

  if (image.numChannels == 3) {
    config = GBitmapConfig.rgb;
  } else if (image.numChannels == 4) {
    config = GBitmapConfig.rgba;
  } else {
    throw ArgumentError("Unsupported number of channels");
  }

  return GBitmap.fromPixels(
    pixels,
    width ?? image.width,
    height ?? image.height,
    config: config,
  );
}

Future<void> saveBitmapToLocalDir(GBitmap bmp, String name) async {
  final img = Image.fromBytes(
    width: bmp.width,
    height: bmp.height,
    bytes: bmp.buffer,
    order:
        bmp.config == GBitmapConfig.rgba ? ChannelOrder.rgba : ChannelOrder.rgb,
  );

  List<int> pngBytes = encodePng(img);

  await File(name).writeAsBytes(pngBytes);
}

Future<Uint8List> generateGraphImage(Node rootNode) async {
  final dotContentBuffer = StringBuffer();
  dotContentBuffer.writeln('digraph G {');

  void writeNodeToBuffer(Node node) {
    final nodeTitle = 'Node${node.id}';
    final fillColor = node.isPassthrough ? 'red' : 'white';
    dotContentBuffer
        .writeln('\t$nodeTitle [label="id ${node.id}\n${node.runtimeType}", style="filled", fillcolor="$fillColor"]');

    if (node.inputNode != null) {
      dotContentBuffer.writeln(
          '\t$nodeTitle -> Node${node.inputNode!.id} [label="input"];');
      writeNodeToBuffer(node.inputNode!);
    }

    if (node.auxNode != null) {
      dotContentBuffer
          .writeln('\t$nodeTitle -> Node${node.auxNode!.id} [label="aux"];');
      writeNodeToBuffer(node.auxNode!);
    }
  }

  writeNodeToBuffer(rootNode);
  dotContentBuffer.writeln("}");

  final dotContent = dotContentBuffer.toString();
  final url = Uri.https(
    "quickchart.io",
    "/graphviz",
    {'format': 'png', 'graph': dotContent},
  );

  final response = await http.get(url);

  return response.bodyBytes;
}

Future<void> exportGraphToPNG(Node rootNode, String fileName) async {
  final file = File('$fileName.png');
  final bytes = await generateGraphImage(rootNode);

  await file.writeAsBytes(bytes);
}
