import 'dart:ui';

import 'package:app/database/database.dart';
import 'package:app/models/bitmap_extensions.dart';
import 'package:app/providers/drawing_state_provider.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphics/graphics.dart';

class DrawingAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const DrawingAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        PopupMenuButton(
          icon: const Icon(
            Icons.more_vert,
            color: Color(0xFF797979),
          ),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: const Text('Save'),
                onTap: () async {
                  final database = ref.read(appDatabaseProvider);
                  await database
                      .into(database.creations)
                      .insert(CreationsCompanion.insert(title: 'Untitled'));

                  if (!context.mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const HomeScreen(),
                    ),
                  );
                },
              ),
              PopupMenuItem(
                child: const Text('Show output graph'),
                onTap: () async {
                  final rootNode = ref.read(canvasControllerProvider).rootNode;
                  final imageBytes = await generateGraphImage(rootNode);

                  if (!context.mounted) return;

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Output Graph'),
                        content: Image.memory(imageBytes),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ];
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
