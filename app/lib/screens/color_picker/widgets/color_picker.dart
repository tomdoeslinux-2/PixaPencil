import 'package:app/screens/color_picker/widgets/hue_square_color_picker.dart';
import 'package:app/screens/color_picker/widgets/spectrum_circle_color_picker.dart';
import 'package:flutter/material.dart';

import 'hue_triangle_color_picker.dart';

enum _ColorPickerType {
  hueTriangle,
  hueSquare,
  spectrumCircle,
}

class ColorPicker extends StatefulWidget {
  const ColorPicker({super.key});

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  _ColorPickerType _selectedView = _ColorPickerType.spectrumCircle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Picker'),
      ),
      body: Column(
        children: [
          SegmentedButton(
            segments: const [
              ButtonSegment(
                value: _ColorPickerType.hueTriangle,
                label: Text('Hue Triangle Picker'),
              ),
              ButtonSegment(
                value: _ColorPickerType.hueSquare,
                label: Text('Hue Square Picker'),
              ),
              ButtonSegment(
                value: _ColorPickerType.spectrumCircle,
                label: Text('Spectrum Circle Picker'),
              ),
            ],
            selected: {_selectedView},
            onSelectionChanged: (selection) {
              setState(() {
                _selectedView = selection.first;
              });
            },
          ),
          Expanded(child: _buildSelectedPicker()),
        ],
      ),
    );
  }

  Widget _buildSelectedPicker() {
    switch (_selectedView) {
      case _ColorPickerType.hueTriangle:
        return const HueTriangleColorPicker();
      case _ColorPickerType.hueSquare:
        return const HueSquareColorPicker();
      case _ColorPickerType.spectrumCircle:
        return const SpectrumCircleColorPicker();
    }
  }
}
