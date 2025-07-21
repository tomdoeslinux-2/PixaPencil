import 'package:flutter/material.dart';

class Segment<T> {
  T value;
  String label;

  Segment({
    required this.value,
    required this.label,
  });
}

class AppSegmentedButton<T> extends StatelessWidget {
  final T selected;
  final List<Segment<T>> segments;
  final void Function(Segment) onChange;

  const AppSegmentedButton({
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
