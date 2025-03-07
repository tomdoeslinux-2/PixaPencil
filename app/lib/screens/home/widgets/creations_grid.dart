
import 'package:flutter/cupertino.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../utils.dart';
import 'creation_card.dart';

class CreationsGrid extends StatelessWidget {
  const CreationsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final rowCount = (dummyCreations.length / 2).ceil();

    return LayoutGrid(
      columnSizes: [1.fr, 1.fr],
      rowSizes: List.generate(rowCount, (_) => auto),
      columnGap: 14,
      rowGap: 14,
      children: [
        for (final creation in dummyCreations)
          CreationCard(
            creation: Creation(
              title: creation.title,
              lastEdited: creation.lastEdited,
              imageName: creation.imageName,
            ),
          ),
      ],
    );
  }
}

