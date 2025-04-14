import 'dart:ui' as ui;

import 'package:app/models/bitmap_extensions.dart';
import 'package:app/providers/drawing_state_provider.dart';
import 'package:app/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                    icon: isVisibilityOn ? const SvgIcon('assets/icons/visibility_m3.svg') : const SvgIcon('assets/icons/visibility_off_m3.svg'),
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

class LayersPanelExpanded extends ConsumerWidget {
  const LayersPanelExpanded({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLayerIndex =
        ref.watch(drawingStateProvider).selectedLayerIndex;
    final layers = ref.watch(drawingStateProvider).layers;

    return SizedBox(
      height: 282,
      child: ListView.builder(
        itemBuilder: (context, index) {
          if (index < layers.length) {
            return FutureBuilder<ui.Image>(
              future: layers[index].rootNode.process(null).toFlutterImage(),
              builder: (context, snapshot) {
                return Center(
                  child: LayerListItem(
                    layerImage: snapshot.data,
                    isSelected: index == selectedLayerIndex,
                    isVisibilityOn: layers[index].isVisible,
                    onTap: () {
                      ref
                          .read(drawingStateProvider.notifier)
                          .changeLayerIndex(index);
                    },
                    onToggleLayerVisibility: () {
                      ref
                          .read(drawingStateProvider.notifier)
                          .toggleLayerVisibility(index);
                    },
                    onDeleteLayer: () {
                      ref.read(drawingStateProvider.notifier).deleteLayer(index);
                    },
                  ),
                );
              },
            );
          }

          return AddLayerButton(onTap: () {
            ref.read(drawingStateProvider.notifier).createLayer();
          });
        },
        itemCount: layers.length + 1,
      ),
    );
  }
}

class LayersPanel extends ConsumerWidget {
  const LayersPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLayerIndex =
        ref.watch(drawingStateProvider).selectedLayerIndex;
    final layers = ref.watch(drawingStateProvider).layers;

    return SizedBox(
      height: 81,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index < layers.length) {
            return FutureBuilder<ui.Image>(
              future: layers[index].rootNode.process(null).toFlutterImage(),
              builder: (context, snapshot) {
                return Center(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        ref
                            .read(drawingStateProvider.notifier)
                            .changeLayerIndex(index);
                      },
                      child: LayerCoverImage(
                        layerImage: snapshot.data,
                        isSelected: index == selectedLayerIndex,
                        size: 61,
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return Center(
            child: AddLayerButton(
              onTap: () {
                ref.read(drawingStateProvider.notifier).createLayer();
              },
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(
          width: 9,
        ),
        itemCount: layers.length + 1,
      ),
    );
  }
}

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
