import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final colorPickerColorProvider = StateProvider<HSVColor>(
  (ref) => const HSVColor.fromAHSV(1, 0, 1, 1),
);
