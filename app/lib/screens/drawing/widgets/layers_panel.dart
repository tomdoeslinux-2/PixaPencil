import 'dart:ui' as ui;

import 'package:app/models/bitmap_extensions.dart';
import 'package:app/providers/drawing_state_provider.dart';
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
  final VoidCallback onTap;
  final VoidCallback onToggleLayerVisibility;

  const LayerListItem({
    super.key,
    required this.layerImage,
    required this.isSelected,
    required this.onTap,
    required this.onToggleLayerVisibility,
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
              IconButton(
                icon: const Icon(Icons.remove_red_eye),
                onPressed: onToggleLayerVisibility,
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
          return FutureBuilder<ui.Image>(
            future: layers[index].rootNode.process(null).toFlutterImage(),
            builder: (context, snapshot) {
              return Center(
                child: LayerListItem(
                  layerImage: snapshot.data,
                  isSelected: index == selectedLayerIndex,
                  onTap: () {
                    ref
                        .read(drawingStateProvider.notifier)
                        .changeLayerIndex(index);
                  },
                  onToggleLayerVisibility: () {
                    ref
                        .read(canvasControllerProvider)
                        .toggleLayerVisibility(index);
                  },
                ),
              );
            },
          );
        },
        itemCount: layers.length,
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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  ref.read(drawingStateProvider.notifier).createLayer();
                },
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
