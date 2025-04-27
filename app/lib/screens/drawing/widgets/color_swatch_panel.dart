import 'package:app/models/color_extensions.dart';
import 'package:app/providers/drawing_state_provider.dart';
import 'package:app/screens/color_picker/color_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphics/graphics.dart';

class ColorSwatchItem extends StatelessWidget {
  final Color color;
  final void Function(Color) onTap;
  final bool isActive;

  const ColorSwatchItem({
    super.key,
    required this.color,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(color);
      },
      child: Stack(
        children: [
          Container(
            width: 45,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: color,
            ),
          ),
          if (isActive)
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFd0d0d0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ColorSwatchPanel extends ConsumerWidget {
  const ColorSwatchPanel({super.key});

  void _onColorTap(Color color, int index, WidgetRef ref) {
    final notifier = ref.read(drawingStateProvider.notifier);
    notifier.changeColor(color.toGColor());
    notifier.changeColorIndex(index);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor =
        ref.watch(drawingStateProvider.select((state) => state.selectedColor));
    final selectedColorIndex = ref.watch(
        drawingStateProvider.select((state) => state.selectedColorIndex));

    return IntrinsicHeight(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFE8E8E8),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                spacing: 4,
                children: [
                  ColorSwatchItem(
                    isActive: selectedColorIndex == 0,
                    color: Colors.red,
                    onTap: (color) => _onColorTap(color, 0, ref),
                  ),
                  ColorSwatchItem(
                    isActive: selectedColorIndex == 1,
                    color: Colors.green,
                    onTap: (color) => _onColorTap(color, 1, ref),
                  ),
                  ColorSwatchItem(
                    isActive: selectedColorIndex == 2,
                    color: Colors.blue,
                    onTap: (color) => _onColorTap(color, 2, ref),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ColorPickerScreen(),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  width: 29,
                  height: 29,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Container(
                    width: 26.8,
                    height: 26.8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selectedColor.toFlutterColor(),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
