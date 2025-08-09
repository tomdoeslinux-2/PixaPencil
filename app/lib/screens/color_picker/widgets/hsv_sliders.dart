import 'package:app/providers/color_picker_color_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../color_picker_screen.dart';
import 'utils.dart';

class HSVSliders extends ConsumerStatefulWidget {
  const HSVSliders({super.key});

  @override
  ConsumerState<HSVSliders> createState() => _HSVSlidersState();
}

class _HSVSlidersState extends ConsumerState<HSVSliders> {
  late final TextEditingController _hueController;
  late final TextEditingController _saturationController;
  late final TextEditingController _brightnessController;

  String _formatHue(double h) => h.toStringAsFixed(1);
  String _formatSaturation(double s) => (s * 100.0).toStringAsFixed(1);
  String _formatValue(double v) => (v * 100.0).toStringAsFixed(1);

  void _syncControllers(HSVColor hsv) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newHue = _formatHue(hsv.hue);
      final newSaturation = _formatSaturation(hsv.saturation);
      final newValue = _formatValue(hsv.value);

      if (_hueController.text != newHue) {
        _hueController.text = newHue;
      }
      if (_saturationController.text != newSaturation) {
        _saturationController.text = newSaturation;
      }
      if (_brightnessController.text != newValue) {
        _brightnessController.text = newValue;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    final hsv = ref.read(colorPickerColorProvider);

    _hueController = TextEditingController(text: _formatHue(hsv.hue));
    _saturationController =
        TextEditingController(text: _formatSaturation(hsv.saturation));
    _brightnessController =
        TextEditingController(text: _formatValue(hsv.value));
  }

  @override
  void dispose() {
    _hueController.dispose();
    _saturationController.dispose();
    _brightnessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hsv = ref.watch(colorPickerColorProvider);
    _syncControllers(hsv);

    final selectedHue = hsv.hue;
    final selectedSaturation = hsv.saturation;
    final selectedValue = hsv.value;

    final hueGradient = LinearGradient(
      colors: kHueColors.reversed.toList(),
      stops: kHueStops,
    );
    final saturationGradient = LinearGradient(colors: [
      HSVColor.fromAHSV(1.0, selectedHue, 0, selectedValue).toColor(),
      HSVColor.fromAHSV(1.0, selectedHue, 1.0, selectedValue).toColor(),
    ]);
    final brightnessGradient = LinearGradient(colors: [
      HSVColor.fromAHSV(1.0, selectedHue, selectedSaturation, 0).toColor(),
      HSVColor.fromAHSV(1.0, selectedHue, selectedSaturation, 1.0).toColor(),
    ]);

    return Column(
      children: [
        ColorChannelSliderInput(
          label: 'H',
          gradient: hueGradient,
          thumbColor: HSVColor.fromAHSV(1, hsv.hue, 1, 1).toColor(),
          sliderValue: hsv.hue,
          onSliderValueChanged: (value) {
            ref.read(colorPickerColorProvider.notifier).state =
                hsv.withHue(value);
          },
          controller: _hueController,
          min: 0,
          max: 360,
        ),
        ColorChannelSliderInput(
          label: 'S',
          gradient: saturationGradient,
          thumbColor: HSVColor.fromAHSV(1, hsv.hue, hsv.saturation, hsv.value)
              .toColor(),
          sliderValue: hsv.saturation,
          onSliderValueChanged: (value) {
            ref.read(colorPickerColorProvider.notifier).state =
                hsv.withSaturation(value);
          },
          controller: _saturationController,
          min: 0,
          max: 1,
        ),
        ColorChannelSliderInput(
          label: 'V',
          gradient: brightnessGradient,
          thumbColor: HSVColor.fromAHSV(1, hsv.hue, hsv.saturation, hsv.value)
              .toColor(),
          sliderValue: hsv.value,
          onSliderValueChanged: (value) {
            ref.read(colorPickerColorProvider.notifier).state =
                hsv.withValue(value);
          },
          controller: _brightnessController,
          min: 0,
          max: 1,
        ),
      ],
    );
  }
}