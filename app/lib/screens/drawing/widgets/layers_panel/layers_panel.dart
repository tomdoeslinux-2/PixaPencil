import 'package:app/screens/drawing/widgets/layers_panel/layers_panel_compact.dart';
import 'package:app/screens/drawing/widgets/layers_panel/layers_panel_expanded.dart';
import 'package:flutter/material.dart';

class LayersPanel extends StatefulWidget {
  const LayersPanel({super.key});

  @override
  State<LayersPanel> createState() => _LayersPanelState();
}

class _LayersPanelState extends State<LayersPanel> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final currentSize = _controller.isAttached ? _controller.size : 0.1;

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: currentSize < 0.35
                  ? ListView(controller: scrollController, children: [LayersPanelCompact()])
                  : LayersPanelExpanded(
                      scrollController: scrollController,
                    ),
            );
          },
        );
      },
    );
  }
}
