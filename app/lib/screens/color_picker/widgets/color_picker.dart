import 'dart:math';

import 'package:app/screens/color_picker/widgets/spectrum_circle_color_picker.dart';
import 'package:flutter/material.dart';

import 'hue_triangle_color_picker.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({super.key});

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  String _selectedView = 'hue_triangle_picker';

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
                value: 'hue_triangle_picker',
                label: Text('Hue Triangle Picker'),
              ),
              ButtonSegment(
                value: 'spectrum_circle_picker',
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
      case 'hue_triangle_picker':
        return const HueTriangleColorPicker();
      case 'spectrum_circle_picker':
        return const SpectrumCircleColorPicker();
      default:
        return const Placeholder();
    }
  }
}
