import 'package:app/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class DrawingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DrawingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      title: const Text('Untitled'),
      toolbarHeight: 64,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const SvgIcon(
            'assets/icons/undo_m3.svg',
            color: Color(0xFF797979),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const SvgIcon(
            'assets/icons/redo_m3.svg',
            color: Color(0xFF797979),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const SvgIcon(
            'assets/icons/zoom_in_m3.svg',
            color: Color(0xFF797979),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const SvgIcon(
            'assets/icons/zoom_out_m3.svg',
            color: Color(0xFF797979),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.more_vert,
            color: Color(0xFF797979),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
