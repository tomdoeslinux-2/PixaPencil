import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphics/graphics.dart';

class _DrawingState {
  final GColor selectedColor;

  const _DrawingState({required this.selectedColor});

  _DrawingState copyWith({GColor? selectedColor}) {
    return _DrawingState(selectedColor: selectedColor ?? this.selectedColor);
  }
}

class _DrawingStateNotifier extends Notifier<_DrawingState> {
  @override
  _DrawingState build() {
    return _DrawingState(selectedColor: GColors.black);
  }

  void changeColor(GColor newColor) {
    state = state.copyWith(selectedColor: newColor);
  }
}

final drawingStateProvider =
    NotifierProvider<_DrawingStateNotifier, _DrawingState>(() {
  return _DrawingStateNotifier();
});
