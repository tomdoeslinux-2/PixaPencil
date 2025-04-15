import 'dart:ui' as ui;

import 'package:app/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'layer_cover_image.dart';

class LayerListItem extends ConsumerWidget {
  final ui.Image? layerImage;
  final bool isSelected;
  final bool isVisibilityOn;
  final VoidCallback onTap;
  final VoidCallback onToggleLayerVisibility;
  final VoidCallback onDeleteLayer;

  const LayerListItem({
    super.key,
    required this.layerImage,
    required this.isSelected,
    required this.isVisibilityOn,
    required this.onTap,
    required this.onToggleLayerVisibility,
    required this.onDeleteLayer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 80,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFECECEC), width: 1),
          ),
          child: Row(
            spacing: 16,
            children: [
              LayerCoverImage(
                layerImage: layerImage,
                isSelected: isSelected,
                size: 49,
              ),
              const Text('Layer 1'),
              const Spacer(),
              Row(
                spacing: 8,
                children: [
                  IconButton(
                    icon: isVisibilityOn
                        ? const SvgIcon('assets/icons/visibility_m3.svg')
                        : const SvgIcon('assets/icons/visibility_off_m3.svg'),
                    onPressed: onToggleLayerVisibility,
                  ),
                  IconButton(
                    onPressed: onDeleteLayer,
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
