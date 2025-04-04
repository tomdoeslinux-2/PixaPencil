import 'package:app/models/color_extensions.dart';
import 'package:app/providers/drawing_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphics/graphics.dart';

class ColorSwatchItem extends StatelessWidget {
  final Color color;
  final void Function(Color) onTap;

  const ColorSwatchItem({
    super.key,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(color);
      },
      child: Container(
        width: 45,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: color,
        ),
      ),
    );
  }
}

class ColorSwatchPanel extends ConsumerWidget {
  const ColorSwatchPanel({super.key});

  void _onColorTap(Color color, WidgetRef ref) {
    final notifier = ref.read(drawingStateProvider.notifier);
    notifier.changeColor(color.toGColor());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor = ref.watch(drawingStateProvider).selectedColor;

    return IntrinsicHeight(
      child: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                spacing: 4,
                children: [
                  ColorSwatchItem(
                    color: Colors.red,
                    onTap: (color) => _onColorTap(color, ref),
                  ),
                  ColorSwatchItem(
                    color: Colors.green,
                    onTap: (color) => _onColorTap(color, ref),
                  ),
                  ColorSwatchItem(
                    color: Colors.blue,
                    onTap: (color) => _onColorTap(color, ref),
                  ),
                ],
              ),
            ),
            AspectRatio(
              aspectRatio: 1,
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
