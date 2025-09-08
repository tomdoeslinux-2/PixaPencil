import 'package:app/providers/color_picker_color_provider.dart';
import 'package:app/screens/color_picker/widgets/hsv_sliders.dart';
import 'package:app/screens/color_picker/widgets/rgb_sliders.dart';
import 'package:app/screens/color_picker/widgets/utils.dart';
import 'package:app/widgets/icon_dropdown_menu.dart';
import 'package:app/widgets/svg_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/segmented_button.dart';
import 'widgets/hue_square_color_picker.dart';
import 'widgets/spectrum_circle_color_picker.dart';
import 'widgets/hue_triangle_color_picker.dart';
import 'package:flutter/material.dart';

enum _ColorPickerType {
  hueTriangle,
  hueSquare,
  spectrumCircle,
}

class GradientTrackShape extends SliderTrackShape {
  final Gradient gradient;

  const GradientTrackShape({
    required this.gradient,
  });

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final overlayWidth =
        sliderTheme.overlayShape!.getPreferredSize(isEnabled, isDiscrete).width;

    final trackHeight = sliderTheme.trackHeight!;
    final trackWidth = parentBox.size.width - overlayWidth;

    final trackLeft = offset.dx + (overlayWidth / 2);
    final trackTop = offset.dy + ((parentBox.size.height - trackHeight) / 2);

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final trackRect =
        getPreferredRect(parentBox: parentBox, sliderTheme: sliderTheme);
    final paint = Paint()..shader = gradient.createShader(trackRect);

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, const Radius.circular(4)),
      paint,
    );
  }
}

class BorderedThumbShape extends SliderComponentShape {
  final double thumbRadius = 12.5;
  final Color fillColor;
  final Color borderColor = Colors.white;
  final double borderWidth = 2;

  static final _shadowPaint = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 0.15)
    ..style = PaintingStyle.fill
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.79);

  const BorderedThumbShape({
    this.fillColor = Colors.white,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius + borderWidth);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, thumbRadius, _shadowPaint); // why shadow not visible?
    canvas.drawCircle(center, thumbRadius, fillPaint);
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}

class NumberValueInput extends StatelessWidget {
  final TextEditingController controller;

  const NumberValueInput({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 51,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFFD3D3D3),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class ColorChannelSliderInput extends StatelessWidget {
  final String label;
  final LinearGradient gradient;
  final Color thumbColor;
  final double sliderValue;
  final Function(double) onSliderValueChanged;
  final TextEditingController controller;
  final double min;
  final double max;

  const ColorChannelSliderInput({
    super.key,
    required this.label,
    required this.gradient,
    required this.thumbColor,
    required this.sliderValue,
    required this.onSliderValueChanged,
    required this.controller,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    final sliderTheme = SliderTheme.of(context).copyWith(
      trackHeight: 9,
    );

    return Row(
      children: [
        Text(label),
        Expanded(
          child: SliderTheme(
            data: sliderTheme.copyWith(
              trackShape: GradientTrackShape(gradient: gradient),
              thumbShape: BorderedThumbShape(
                fillColor: thumbColor,
              ),
            ),
            child: Slider(
              min: min,
              max: max,
              value: sliderValue,
              onChanged: onSliderValueChanged,
            ),
          ),
        ),
        NumberValueInput(
          controller: controller,
        ),
      ],
    );
  }
}

class ColorPickerScreen extends ConsumerStatefulWidget {
  final Color initialColor;

  const ColorPickerScreen({
    super.key,
    required this.initialColor,
  });

  @override
  ConsumerState<ColorPickerScreen> createState() => _ColorPickerScreenState();
}

enum _SliderType { hsv, rgb, hex }

class _ColorPickerScreenState extends ConsumerState<ColorPickerScreen> {
  var _selectedColorPickerType = _ColorPickerType.hueSquare;
  var _selectedSliderType = _SliderType.hsv;

  @override
  Widget build(BuildContext context) {
    final selectedColor = ref.watch(colorPickerColorProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 4,
        toolbarHeight: 64,
        title: const Text('Color Picker'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.check),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFFE8E8E8),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Positioned(
                  child: SizedBox(
                    width: double.infinity,
                    child: _buildSelectedPicker(),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconDropdownMenu(
                    items: [
                      IconDropdownItem(
                        key: _ColorPickerType.hueSquare.name,
                        icon: Image.asset(
                          'assets/images/hue_square_color_picker.png',
                          width: 25,
                          height: 25,
                        ),
                      ),
                      IconDropdownItem(
                        key: _ColorPickerType.hueTriangle.name,
                        icon: Image.asset(
                          'assets/images/hue_triangle_color_picker.png',
                          width: 25,
                          height: 25,
                        ),
                      ),
                      IconDropdownItem(
                        key: _ColorPickerType.spectrumCircle.name,
                        icon: Image.asset(
                          'assets/images/spectrum_circle_color_picker.png',
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ],
                    onItemSelected: (key) {
                      setState(() {
                        _selectedColorPickerType = _ColorPickerType.values
                            .firstWhere((type) => type.name == key);
                      });
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFC2C2C2),
                      ),
                    ),
                    onPressed: () {},
                    icon: const SvgIcon('assets/icons/library_add_m3.svg'),
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFC2C2C2),
                      ),
                    ),
                    onPressed: () {
                      ref.read(colorPickerColorProvider.notifier).state =
                          HSVColor.fromColor(widget.initialColor);
                    },
                    icon: const SvgIcon('assets/icons/restart_alt_m3.svg'),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFC2C2C2),
                      ),
                    ),
                    onPressed: () {},
                    icon: const SvgIcon('assets/icons/colorize_m3.svg'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 34,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 48,
                    color: selectedColor.toColor(),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 41,
            ),
            AppSegmentedButton(
              selected: _selectedSliderType,
              segments: [
                Segment(
                  label: 'HSV',
                  value: _SliderType.hsv,
                ),
                Segment(
                  label: 'RGB',
                  value: _SliderType.rgb,
                ),
                Segment(
                  label: 'HEX',
                  value: _SliderType.hex,
                ),
              ],
              onChange: (segment) {
                setState(() {
                  _selectedSliderType = segment.value;
                });
              },
            ),
            const SizedBox(
              height: 21,
            ),
            if (_selectedSliderType == _SliderType.hsv)
              const HSVSliders()
            else if (_selectedSliderType == _SliderType.rgb)
              const RGBSliders(),
            Row(
              spacing: 12,
              children: [
                FilledButton(
                  onPressed: () {},
                  child: const Text('Done'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Cancel'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _handleColorChange(HSVColor color) {
    ref.read(colorPickerColorProvider.notifier).state = color;
  }

  Widget _buildSelectedPicker() {
    switch (_selectedColorPickerType) {
      case _ColorPickerType.hueTriangle:
        return HueTriangleColorPicker(
          onColorSelected: _handleColorChange,
        );
      case _ColorPickerType.hueSquare:
        return HueSquareColorPicker(
          onColorSelected: _handleColorChange,
        );
      case _ColorPickerType.spectrumCircle:
        return SpectrumCircleColorPicker(
          onColorSelected: _handleColorChange,
        );
    }
  }
}
