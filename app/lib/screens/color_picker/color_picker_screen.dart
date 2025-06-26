import 'package:app/widgets/icon_dropdown_menu.dart';

import 'widgets/hue_square_color_picker.dart';
import 'widgets/spectrum_circle_color_picker.dart';
import 'widgets/hue_triangle_color_picker.dart';
import 'package:app/screens/color_picker/widgets/utils.dart';
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
  final double thumbRadius;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;

  const BorderedThumbShape({
    this.thumbRadius = 12.5,
    this.fillColor = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 2,
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

    canvas.drawCircle(center, thumbRadius, fillPaint);
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}

class ValueInput extends StatelessWidget {
  const ValueInput({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 51,
      child: TextField(
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

class HSVSliders extends StatefulWidget {
  final Color selectedColor;

  const HSVSliders({super.key, required this.selectedColor});

  @override
  State<HSVSliders> createState() => _HSVSlidersState();
}

class _HSVSlidersState extends State<HSVSliders> {
  double _hueValue = 0;
  double _saturationValue = 0;
  double _brightnessValue = 0;

  @override
  Widget build(BuildContext context) {
    final sliderTheme = SliderTheme.of(context).copyWith(
      trackHeight: 9,
      thumbShape: const BorderedThumbShape(),
    );

    final selectedHue = HSVColor.fromColor(widget.selectedColor).hue;
    final selectedSaturation =
        HSVColor.fromColor(widget.selectedColor).saturation;
    final selectedValue = HSVColor.fromColor(widget.selectedColor).value;

    final saturationGradient = LinearGradient(colors: [
      HSVColor.fromAHSV(1.0, selectedHue, 0, selectedValue).toColor(),
      HSVColor.fromAHSV(1.0, selectedHue, 1.0, selectedValue).toColor(),
    ]);
    final brightnessGradient = LinearGradient(colors: [
      HSVColor.fromAHSV(1.0, selectedHue, selectedSaturation, 0).toColor(),
      HSVColor.fromAHSV(1.0, selectedHue, selectedSaturation, 1.0).toColor(),
    ]);

    return SliderTheme(
      data: sliderTheme,
      child: Column(
        children: [
          Row(
            children: [
              const Text('H'),
              Expanded(
                child: SliderTheme(
                  data: sliderTheme.copyWith(
                    trackShape:
                        GradientTrackShape(gradient: kHueLinearGradient),
                  ),
                  child: Slider(
                    value: _hueValue,
                    onChanged: (value) {
                      setState(() {
                        _hueValue = value;
                      });
                    },
                  ),
                ),
              ),
              const ValueInput(),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('S'),
              Expanded(
                child: SliderTheme(
                  data: sliderTheme.copyWith(
                    trackShape:
                        GradientTrackShape(gradient: saturationGradient),
                  ),
                  child: Slider(
                    value: _saturationValue,
                    onChanged: (value) {
                      setState(() {
                        _saturationValue = value;
                      });
                    },
                  ),
                ),
              ),
              const ValueInput(),
            ],
          ),
          Row(
            children: [
              const Text('V'),
              Expanded(
                child: SliderTheme(
                  data: sliderTheme.copyWith(
                    trackShape:
                        GradientTrackShape(gradient: brightnessGradient),
                  ),
                  child: Slider(
                    value: _brightnessValue,
                    onChanged: (value) {
                      setState(() {
                        _brightnessValue = value;
                      });
                    },
                  ),
                ),
              ),
              const ValueInput(),
            ],
          ),
        ],
      ),
    );
  }
}

class Segment<T> {
  T value;
  String label;

  Segment({
    required this.value,
    required this.label,
  });
}

class PXSegmentedButton<T> extends StatelessWidget {
  final T selected;
  final List<Segment<T>> segments;
  final void Function(Segment) onChange;

  const PXSegmentedButton({
    super.key,
    required this.selected,
    required this.segments,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFEAEAEA),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var s in segments)
            GestureDetector(
              onTap: () {
                onChange(s);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color:
                      selected == s.value ? Colors.white : Colors.transparent,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    s.label,
                    style: TextStyle(
                      fontWeight: selected == s.value
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ColorPickerScreen extends StatefulWidget {
  const ColorPickerScreen({super.key});

  @override
  State<ColorPickerScreen> createState() => _ColorPickerScreenState();
}

enum _SliderType { hsv, rgb, hex }

class _ColorPickerScreenState extends State<ColorPickerScreen> {
  var _selectedColor = Colors.black;
  var _selectedColorPickerType = _ColorPickerType.hueSquare;
  var _selectedSliders = _SliderType.hsv;

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      child: _buildSelectedPicker(),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 20,
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
                const Positioned(
                  left: 0,
                  top: 0,
                  child: DropdownMenu(dropdownMenuEntries: []),
                ),
              ],
            ),
          ),
          PXSegmentedButton(
            selected: _selectedSliders,
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
                _selectedSliders = segment.value;
              });
            },
          ),
          HSVSliders(
            selectedColor: _selectedColor,
          ),
          Row(
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
    );
  }

  void _handleColorChange(Color color) {
    setState(() {
      _selectedColor = color;
    });
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
