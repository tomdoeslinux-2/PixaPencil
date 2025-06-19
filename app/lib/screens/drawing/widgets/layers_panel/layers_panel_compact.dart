import 'dart:ui' as ui;

import 'package:app/models/bitmap_extensions.dart';
import 'package:app/providers/drawing_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_layer_button.dart';
import 'layer_cover_image.dart';

class LayersPanelCompact extends ConsumerWidget {
  const LayersPanelCompact({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layers =
        ref.watch(drawingStateProvider.select((state) => state.layers));
    final selectedIndex = ref.watch(drawingStateProvider.select((state) => state.selectedLayerIndex));

    print(selectedIndex);

    return SizedBox(
      height: 81,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index < layers.length) {
            return FutureBuilder<ui.Image>(
              future: layers[index].data.toFlutterImage(),
              builder: (context, snapshot) {
                final img = snapshot.data;

                return Material(
                  key: ValueKey(layers[index].data),
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      ref
                          .read(drawingStateProvider.notifier)
                          .changeLayerIndex(index);
                    },
                    child: LayerCoverImage(
                      layerImage: img,
                      isSelected: index ==
                          ref.watch(drawingStateProvider
                              .select((state) => state.selectedLayerIndex)),
                      size: 61,
                    ),
                  ),
                );
              },
            );
          }

          return Center(
            child: AddLayerButton(
              onTap: () {
                ref.read(drawingStateProvider.notifier).addLayer();
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
