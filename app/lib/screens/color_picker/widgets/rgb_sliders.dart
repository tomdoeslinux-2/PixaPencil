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
  late final TextEditingController _redController;
  late final TextEditingController _greenController;
  late final TextEditingController _blueController;

  String _formatChannel(double c) => (c * 255.0).toStringAsFixed(1);

  @override
  void initState() {
    super.initState();

    final rgb = ref.read(colorPickerColorProvider).toColor();

    _redController = TextEditingController(text: _formatChannel(rgb.r));
    _greenController = TextEditingController(text: _formatChannel(rgb.g));
    _blueController = TextEditingController(text: _formatChannel(rgb.b));
  }

  @override
  void dispose() {
    _redController.dispose();
    _greenController.dispose();
    _blueController.dispose();
    super.dispose();
  }

  void _syncControllers(Color color) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newR = _formatChannel(color.r);
      final newG = _formatChannel(color.g);
      final newB = _formatChannel(color.b);

      if (_redController.text != newR) {
        _redController.text = newR;
      }
      if (_greenController.text != newG) {
        _greenController.text = newG;
      }
      if (_blueController.text != newB) {
        _blueController.text = newB;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = ref.watch(colorPickerColorProvider).toColor();
    _syncControllers(selectedColor);

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
          thumbColor: Color.fromARGB(255, (selectedColor.r * 255).toInt(), 0, 0),
          sliderValue: selectedColor.r * 255,
          onSliderValueChanged: (value) {
            ref.read(colorPickerColorProvider.notifier).state =
                HSVColor.fromColor(selectedColor.withValues(red: value / 255));
          },
          controller: _redController,
          min: 0,
          max: 255,
        ),
        ColorChannelSliderInput(
          label: 'G',
          gradient: greenGradient,
          thumbColor: Color.fromARGB(255, 0, (selectedColor.g * 255).toInt(), 0),
          sliderValue: selectedColor.g * 255,
          onSliderValueChanged: (value) {
            ref.read(colorPickerColorProvider.notifier).state =
                HSVColor.fromColor(selectedColor.withValues(green: value / 255));
          },
          controller: _greenController,
          min: 0,
          max: 255,
        ),
        ColorChannelSliderInput(
          label: 'B',
          gradient: blueGradient,
          thumbColor: Color.fromARGB(255, 0, 0, (selectedColor.b * 255).toInt()),
          sliderValue: selectedColor.b * 255,
          onSliderValueChanged: (value) {
            ref.read(colorPickerColorProvider.notifier).state =
                HSVColor.fromColor(selectedColor.withValues(blue: value / 255));
          },
          controller: _blueController,
          min: 0,
          max: 255,
        ),
      ],
    );
  }
}
