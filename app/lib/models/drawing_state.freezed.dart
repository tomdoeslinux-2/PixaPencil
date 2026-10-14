// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drawing_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DrawingState {
  GColor get selectedColor;
  int get selectedColorIndex;
  Tool get selectedTool;
  List<Layer> get layers;
  int get selectedLayerIndex;

  /// Create a copy of DrawingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DrawingStateCopyWith<DrawingState> get copyWith =>
      _$DrawingStateCopyWithImpl<DrawingState>(
          this as DrawingState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DrawingState &&
            (identical(other.selectedColor, selectedColor) ||
                other.selectedColor == selectedColor) &&
            (identical(other.selectedColorIndex, selectedColorIndex) ||
                other.selectedColorIndex == selectedColorIndex) &&
            (identical(other.selectedTool, selectedTool) ||
                other.selectedTool == selectedTool) &&
            const DeepCollectionEquality().equals(other.layers, layers) &&
            (identical(other.selectedLayerIndex, selectedLayerIndex) ||
                other.selectedLayerIndex == selectedLayerIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedColor,
      selectedColorIndex,
      selectedTool,
      const DeepCollectionEquality().hash(layers),
      selectedLayerIndex);

  @override
  String toString() {
    return 'DrawingState(selectedColor: $selectedColor, selectedColorIndex: $selectedColorIndex, selectedTool: $selectedTool, layers: $layers, selectedLayerIndex: $selectedLayerIndex)';
  }
}

/// @nodoc
abstract mixin class $DrawingStateCopyWith<$Res> {
  factory $DrawingStateCopyWith(
          DrawingState value, $Res Function(DrawingState) _then) =
      _$DrawingStateCopyWithImpl;
  @useResult
  $Res call(
      {GColor selectedColor,
      int selectedColorIndex,
      Tool selectedTool,
      List<Layer> layers,
      int selectedLayerIndex});
}

/// @nodoc
class _$DrawingStateCopyWithImpl<$Res> implements $DrawingStateCopyWith<$Res> {
  _$DrawingStateCopyWithImpl(this._self, this._then);

  final DrawingState _self;
  final $Res Function(DrawingState) _then;

  /// Create a copy of DrawingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedColor = null,
    Object? selectedColorIndex = null,
    Object? selectedTool = null,
    Object? layers = null,
    Object? selectedLayerIndex = null,
  }) {
    return _then(_self.copyWith(
      selectedColor: null == selectedColor
          ? _self.selectedColor
          : selectedColor // ignore: cast_nullable_to_non_nullable
              as GColor,
      selectedColorIndex: null == selectedColorIndex
          ? _self.selectedColorIndex
          : selectedColorIndex // ignore: cast_nullable_to_non_nullable
              as int,
      selectedTool: null == selectedTool
          ? _self.selectedTool
          : selectedTool // ignore: cast_nullable_to_non_nullable
              as Tool,
      layers: null == layers
          ? _self.layers
          : layers // ignore: cast_nullable_to_non_nullable
              as List<Layer>,
      selectedLayerIndex: null == selectedLayerIndex
          ? _self.selectedLayerIndex
          : selectedLayerIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _DrawingState implements DrawingState {
  const _DrawingState(
      {required this.selectedColor,
      required this.selectedColorIndex,
      required this.selectedTool,
      required final List<Layer> layers,
      required this.selectedLayerIndex})
      : _layers = layers;

  @override
  final GColor selectedColor;
  @override
  final int selectedColorIndex;
  @override
  final Tool selectedTool;
  final List<Layer> _layers;
  @override
  List<Layer> get layers {
    if (_layers is EqualUnmodifiableListView) return _layers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_layers);
  }

  @override
  final int selectedLayerIndex;

  /// Create a copy of DrawingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DrawingStateCopyWith<_DrawingState> get copyWith =>
      __$DrawingStateCopyWithImpl<_DrawingState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DrawingState &&
            (identical(other.selectedColor, selectedColor) ||
                other.selectedColor == selectedColor) &&
            (identical(other.selectedColorIndex, selectedColorIndex) ||
                other.selectedColorIndex == selectedColorIndex) &&
            (identical(other.selectedTool, selectedTool) ||
                other.selectedTool == selectedTool) &&
            const DeepCollectionEquality().equals(other._layers, _layers) &&
            (identical(other.selectedLayerIndex, selectedLayerIndex) ||
                other.selectedLayerIndex == selectedLayerIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedColor,
      selectedColorIndex,
      selectedTool,
      const DeepCollectionEquality().hash(_layers),
      selectedLayerIndex);

  @override
  String toString() {
    return 'DrawingState(selectedColor: $selectedColor, selectedColorIndex: $selectedColorIndex, selectedTool: $selectedTool, layers: $layers, selectedLayerIndex: $selectedLayerIndex)';
  }
}

/// @nodoc
abstract mixin class _$DrawingStateCopyWith<$Res>
    implements $DrawingStateCopyWith<$Res> {
  factory _$DrawingStateCopyWith(
          _DrawingState value, $Res Function(_DrawingState) _then) =
      __$DrawingStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {GColor selectedColor,
      int selectedColorIndex,
      Tool selectedTool,
      List<Layer> layers,
      int selectedLayerIndex});
}

/// @nodoc
class __$DrawingStateCopyWithImpl<$Res>
    implements _$DrawingStateCopyWith<$Res> {
  __$DrawingStateCopyWithImpl(this._self, this._then);

  final _DrawingState _self;
  final $Res Function(_DrawingState) _then;

  /// Create a copy of DrawingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? selectedColor = null,
    Object? selectedColorIndex = null,
    Object? selectedTool = null,
    Object? layers = null,
    Object? selectedLayerIndex = null,
  }) {
    return _then(_DrawingState(
      selectedColor: null == selectedColor
          ? _self.selectedColor
          : selectedColor // ignore: cast_nullable_to_non_nullable
              as GColor,
      selectedColorIndex: null == selectedColorIndex
          ? _self.selectedColorIndex
          : selectedColorIndex // ignore: cast_nullable_to_non_nullable
              as int,
      selectedTool: null == selectedTool
          ? _self.selectedTool
          : selectedTool // ignore: cast_nullable_to_non_nullable
              as Tool,
      layers: null == layers
          ? _self._layers
          : layers // ignore: cast_nullable_to_non_nullable
              as List<Layer>,
      selectedLayerIndex: null == selectedLayerIndex
          ? _self.selectedLayerIndex
          : selectedLayerIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
