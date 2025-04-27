import 'package:app/models/tool.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:graphics/graphics.dart';

import 'layer.dart';

part 'drawing_state.freezed.dart';

@freezed
abstract class DrawingState with _$DrawingState {
  const factory DrawingState({
    required GColor selectedColor,
    required int selectedColorIndex,
    required Tool selectedTool,
    required List<Layer> layers,
    required int selectedLayerIndex,
  }) = _DrawingState;
}
