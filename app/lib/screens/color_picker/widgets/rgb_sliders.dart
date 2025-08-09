import 'package:app/providers/color_picker_color_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../color_picker_screen.dart';

class RGBSliders extends ConsumerStatefulWidget {
  const RGBSliders({super.key});

  @override
  ConsumerState<RGBSliders> createState() => _RGBSlidersState();
}

class _RGBSlidersState extends ConsumerState<RGBSliders> {
  late final TextEditingController _redController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final selectedColor = ref.watch(colorPickerColorProvider).toColor();

    final redGradient = LinearGradient(colors: [
      Color.fromARGB(255, 0, selectedColor.g.toInt(), selectedColor.b.toInt()),
      Color.fromARGB(
          255, 255, selectedColor.g.toInt(), selectedColor.b.toInt()),
    ]);
    final greenGradient = LinearGradient(colors: [
      Color.fromARGB(255, selectedColor.r.toInt(), 0, selectedColor.b.toInt()),
      Color.fromARGB(
          255, selectedColor.r.toInt(), 255, selectedColor.b.toInt()),
    ]);
    final blueGradient = LinearGradient(colors: [
      Color.fromARGB(255, selectedColor.r.toInt(), selectedColor.g.toInt(), 0),
      Color.fromARGB(
          255, selectedColor.r.toInt(), selectedColor.g.toInt(), 255),
    ]);

    return Column(
      children: [
        ColorChannelSliderInput(
          label: 'R',
          gradient: redGradient,
          thumbColor: selectedColor,
          sliderValue: 0,
          onSliderValueChanged: (value) {},
          controller: _redController,
          min: 0,
          max: 255,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _redController.dispose();
    super.dispose();
  }
}
