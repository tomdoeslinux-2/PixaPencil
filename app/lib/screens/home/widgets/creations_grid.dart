import 'package:app/database/database.dart';
import 'package:app/providers/drawing_state_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'creation_card.dart';

class CreationsGrid extends ConsumerWidget {
  const CreationsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(appDatabaseProvider);

    return StreamBuilder(
      stream: db.select(db.creations).watch(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final creations = snapshot.data!;
        final rowCount = (creations.length / 2).ceil();

        return LayoutGrid(
          columnSizes: [1.fr, 1.fr],
          rowSizes: List.generate(rowCount, (_) => auto),
          columnGap: 14,
          rowGap: 14,
          children: [
            for (final creation in creations) CreationCard(creation: creation),
          ],
        );
      },
    );
  }
}
