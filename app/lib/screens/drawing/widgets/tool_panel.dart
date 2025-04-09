import 'package:app/models/tool_type.dart';
import 'package:app/providers/drawing_state_provider.dart';
import 'package:app/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tool_button.dart';

class ToolPanel extends ConsumerWidget {
  const ToolPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTool = ref.watch(drawingStateProvider).selectedTool;

    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFE8E8E8),
            width: 1,
          ),
        ),
      ),
      child: Row(
        spacing: 10,
        children: [
          ToolButton(
            icon: const SvgIcon('assets/icons/edit_m3.svg'),
            isSelected: selectedTool.toolType == ToolType.pencil,
            onTap: () => ref.read(drawingStateProvider.notifier).changeToolType(ToolType.pencil),
          ),
          ToolButton(
            icon: const SvgIcon('assets/icons/eraser_m3.svg'),
            isSelected: selectedTool.toolType == ToolType.eraser,
            onTap: () => ref.read(drawingStateProvider.notifier).changeToolType(ToolType.eraser),
          ),
          ToolButton(
            icon: const SvgIcon('assets/icons/colorize_m3.svg'),
            isSelected: selectedTool.toolType == ToolType.colorPicker,
            onTap: () => ref.read(drawingStateProvider.notifier).changeToolType(ToolType.colorPicker),
          ),
        ],
      ),
    );
  }
}