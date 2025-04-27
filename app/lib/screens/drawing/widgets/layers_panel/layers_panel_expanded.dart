import 'dart:ui' as ui;

import 'package:app/models/bitmap_extensions.dart';
import 'package:app/providers/drawing_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_layer_button.dart';
import 'layer_list_item.dart';

class LayersPanelExpanded extends ConsumerWidget {
  final ScrollController scrollController;

  const LayersPanelExpanded({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLayerIndex = ref.watch(
        drawingStateProvider.select((state) => state.selectedLayerIndex));
    final layers =
        ref.watch(drawingStateProvider.select((state) => state.layers));

    return SizedBox(
      height: 282,
      child: ListView.builder(
        controller: scrollController,
        itemBuilder: (context, index) {
          if (index < layers.length) {
            return FutureBuilder<ui.Image>(
              future: layers[index].data.toFlutterImage(),
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
                      ref
                          .read(drawingStateProvider.notifier)
                          .deleteLayer(index);
                    },
                  ),
                );
              },
            );
          }

          return AddLayerButton(onTap: () {
            ref.read(drawingStateProvider.notifier).addLayer();
          });
        },
        itemCount: layers.length + 1,
      ),
    );
  }
}
