import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:graphics/graphics.dart';

part 'layer.freezed.dart';

@freezed
abstract class Layer with _$Layer {
  const factory Layer({
    required String name,
    required GBitmap data,
    required bool isVisible,
  }) = _Layer;
}