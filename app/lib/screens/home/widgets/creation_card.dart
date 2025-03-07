import 'package:app/widgets/marquee.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils.dart';
import 'creation_card_bottom_sheet.dart';
import 'favorite_button.dart';

class CreationCard extends StatelessWidget {
  final Creation creation;

  const CreationCard({
    super.key,
    required this.creation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFe8e8e8),
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImage(),
              _buildDetails(context),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onLongPress: () {
                  HapticFeedback.lightImpact();
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    context: context,
                    builder: (ctx) =>
                        CreationCardBottomSheet(creation: creation),
                  );
                },
                onTap: () {},
                splashColor: const Color(0xFF6495ED).withValues(alpha: 0.1),
                highlightColor: const Color(0xFF6495ED).withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const Positioned(bottom: 9, right: 3, child: FavoriteButton()),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.asset(
          creation.imageName,
          width: double.infinity,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.none,
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return SizedBox(
      height: 66,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _buildTitle(context)),
            IconButton(onPressed: () {}, icon: const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 4,
      children: [
        Marquee(
          text: creation.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          getRelativeTime(creation.lastEdited),
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}