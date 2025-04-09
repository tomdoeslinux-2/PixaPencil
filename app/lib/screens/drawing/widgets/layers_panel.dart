import 'dart:ui' as ui;

import 'package:app/models/bitmap_extensions.dart';
import 'package:app/providers/drawing_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LayersPanel extends ConsumerWidget {
  const LayersPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLayerIndex = ref.watch(drawingStateProvider).selectedLayerIndex;
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
                        ref.read(drawingStateProvider.notifier).changeLayerIndex(index);
                      },
                      child: Container(
                        width: 61,
                        height: 61,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: index == selectedLayerIndex ? const Color(0xFF6495ED) : Colors.transparent,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: RawImage(
                          image: snapshot.data,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.none,
                          isAntiAlias: false,
                          colorBlendMode: BlendMode.src,
                        ),
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
