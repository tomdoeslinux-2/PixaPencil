import 'package:flutter/material.dart';

import '../../../widgets/svg_icon.dart';

class DrawFAB extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback? onTap;

  const DrawFAB({super.key, required this.isExpanded, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      height: 54,
      width: isExpanded ? 123 : 54, // 123
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF81C652), Color(0xFF00B09B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(1000),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(1000),
          child: ClipRect(
            child: AnimatedPadding(
              padding: isExpanded
                  ? const EdgeInsets.only(left: 20, right: 24)
                  : const EdgeInsets.all(15),
              duration: Duration.zero,
              child: Row(
                spacing: isExpanded ? 6 : 0,
                children: [
                  const SvgIcon(
                    'assets/icons/stylus_note_m3.svg',
                    color: Colors.white,
                    size: 24,
                  ),
                  if (isExpanded)
                    const Text(
                      'Draw',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}