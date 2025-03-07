import '../../../widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class PxpNavigationBar extends StatefulWidget {
  const PxpNavigationBar({super.key});

  @override
  State<PxpNavigationBar> createState() => _PxpNavigationBarState();
}

class _PxpNavigationBarState extends State<PxpNavigationBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        height: 84,
        child: Material(
          color: Colors.transparent,
          child: Row(
            children: [
              _buildNavBarItem(
                index: 0,
                icon: const SvgIcon('assets/icons/home_outlined_m3.svg'),
                selectedIcon: const SvgIcon('assets/icons/home_m3.svg'),
                label: 'Home',
              ),
              _buildNavBarItem(
                index: 1,
                icon: const Icon(Icons.folder_outlined),
                selectedIcon: const Icon(Icons.folder),
                label: 'Collections',
              ),
              _buildNavBarItem(
                index: 2,
                icon: const SvgIcon('assets/icons/explore_outlined_m3.svg'),
                selectedIcon: const SvgIcon('assets/icons/explore_m3.svg'),
                label: 'Explore',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem({
    required int index,
    required Widget icon,
    required Widget selectedIcon,
    required String label,
  }) {
    final isSelected = index == _selectedIndex;
    final color =
    isSelected ? const Color(0xFF6495ED) : const Color(0xFF797979);

    return Expanded(
      child: Tooltip(
        message: label,
        verticalOffset: 37,
        preferBelow: false,
        child: InkResponse(
          splashColor: const Color(0xFF6495ED).withValues(alpha: 0.2),
          highlightColor: const Color(0xFF6495ED).withValues(alpha: 0.03),
          radius: 30,
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          child: Container(
            height: double.infinity,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 4,
              children: [
                IconTheme(
                  data: IconThemeData(color: color, size: 32),
                  child: isSelected ? selectedIcon : icon,
                ),
                Text(
                  label,
                  style: TextStyle(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}