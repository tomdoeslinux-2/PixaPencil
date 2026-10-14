// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'layer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Layer {
  String get name;
  GBitmap get data;
  bool get isVisible;

  /// Create a copy of Layer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LayerCopyWith<Layer> get copyWith =>
      _$LayerCopyWithImpl<Layer>(this as Layer, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Layer &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, data, isVisible);

  @override
  String toString() {
    return 'Layer(name: $name, data: $data, isVisible: $isVisible)';
  }
}

/// @nodoc
abstract mixin class $LayerCopyWith<$Res> {
  factory $LayerCopyWith(Layer value, $Res Function(Layer) _then) =
      _$LayerCopyWithImpl;
  @useResult
  $Res call({String name, GBitmap data, bool isVisible});
}

/// @nodoc
class _$LayerCopyWithImpl<$Res> implements $LayerCopyWith<$Res> {
  _$LayerCopyWithImpl(this._self, this._then);

  final Layer _self;
  final $Res Function(Layer) _then;

  /// Create a copy of Layer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? data = null,
    Object? isVisible = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as GBitmap,
      isVisible: null == isVisible
          ? _self.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _Layer implements Layer {
  const _Layer(
      {required this.name, required this.data, required this.isVisible});

  @override
  final String name;
  @override
  final GBitmap data;
  @override
  final bool isVisible;

  /// Create a copy of Layer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LayerCopyWith<_Layer> get copyWith =>
      __$LayerCopyWithImpl<_Layer>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Layer &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, data, isVisible);

  @override
  String toString() {
    return 'Layer(name: $name, data: $data, isVisible: $isVisible)';
  }
}

/// @nodoc
abstract mixin class _$LayerCopyWith<$Res> implements $LayerCopyWith<$Res> {
  factory _$LayerCopyWith(_Layer value, $Res Function(_Layer) _then) =
      __$LayerCopyWithImpl;
  @override
  @useResult
  $Res call({String name, GBitmap data, bool isVisible});
}

/// @nodoc
class __$LayerCopyWithImpl<$Res> implements _$LayerCopyWith<$Res> {
  __$LayerCopyWithImpl(this._self, this._then);

  final _Layer _self;
  final $Res Function(_Layer) _then;

  /// Create a copy of Layer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? data = null,
    Object? isVisible = null,
  }) {
    return _then(_Layer(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as GBitmap,
      isVisible: null == isVisible
          ? _self.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
