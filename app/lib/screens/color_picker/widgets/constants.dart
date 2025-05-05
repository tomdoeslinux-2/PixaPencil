import 'package:flutter/material.dart';

final SweepGradient hueGradient = SweepGradient(
  colors: List.generate(
    7,
        (i) => HSVColor.fromAHSV(1.0, 360 - (i * 60.0), 1.0, 1.0)
        .toColor(), // why this not work
  ),
  stops: const [
    0,
    1 / 6,
    2 / 6,
    3 / 6,
    4 / 6,
    5 / 6,
    1,
  ],
);