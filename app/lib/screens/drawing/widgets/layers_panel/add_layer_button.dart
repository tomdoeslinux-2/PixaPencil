import 'package:flutter/material.dart';

class AddLayerButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddLayerButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          width: 61,
          height: 61,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFCFCFCF),
              width: 1,
            ),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
