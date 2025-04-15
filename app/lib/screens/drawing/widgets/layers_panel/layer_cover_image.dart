import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LayerCoverImage extends StatelessWidget {
  final double size;
  final ui.Image? layerImage;
  final bool isSelected;

  const LayerCoverImage({
    super.key,
    required this.size,
    required this.layerImage,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? const Color(0xFF6495ED) : Colors.transparent,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            'assets/images/test_layer_bg.svg',
          ),
          RawImage(
            image: layerImage,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.none,
            isAntiAlias: false,
            colorBlendMode: BlendMode.src,
          ),
        ],
      ),
    );
  }
}