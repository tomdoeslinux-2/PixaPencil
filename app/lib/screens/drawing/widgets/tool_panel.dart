import 'package:app/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

import 'tool_button.dart';

class ToolPanel extends StatefulWidget {
  const ToolPanel({super.key});

  @override
  State<ToolPanel> createState() => _ToolPanelState();
}

class _ToolPanelState extends State<ToolPanel> {
  int _selectedToolIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        spacing: 10,
        children: [
          ToolButton(
            icon: const SvgIcon('assets/icons/edit_m3.svg'),
            isSelected: _selectedToolIndex == 0,
            onTap: () => setState(() => _selectedToolIndex = 0),
          ),
          ToolButton(
            icon: const SvgIcon('assets/icons/eraser_m3.svg'),
            isSelected: _selectedToolIndex == 1,
            onTap: () => setState(() => _selectedToolIndex = 1),
          ),
          ToolButton(
            icon: const SvgIcon('assets/icons/colorize_m3.svg'),
            isSelected: _selectedToolIndex == 2,
            onTap: () => setState(() => _selectedToolIndex = 2),
          ),
        ],
      ),
    );
  }
}