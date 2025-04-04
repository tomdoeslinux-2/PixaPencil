import 'package:flutter/material.dart';

class ToolButton extends StatelessWidget {
  final Widget icon;
  final bool isSelected;
  final VoidCallback onTap;

  const ToolButton({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? const Color(0xFF6495ED) : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Center(
            child: IconTheme(
              data: IconThemeData(color: isSelected ? Colors.white : null),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
