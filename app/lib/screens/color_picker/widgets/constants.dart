import 'package:flutter/material.dart';

final List<Color> kHueColors = List.generate(
  7,
  (i) => HSVColor.fromAHSV(1.0, 360 - (i * 60.0), 1.0, 1.0)
      .toColor(), // why this not work
);

const List<double> kHueStops = [
  0,
  1 / 6,
  2 / 6,
  3 / 6,
  4 / 6,
  5 / 6,
  1,
];

final SweepGradient kHueSweepGradient = SweepGradient(
  colors: kHueColors,
  stops: kHueStops,
);
