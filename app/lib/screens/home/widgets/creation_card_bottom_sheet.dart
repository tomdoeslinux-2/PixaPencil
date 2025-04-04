import 'package:flutter/material.dart';

import '../utils.dart';
import '../../../widgets/svg_icon.dart';

class CreationCardBottomSheet extends StatelessWidget {
  final Creation creation;

  const CreationCardBottomSheet({super.key, required this.creation});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        icon: const SvgIcon('assets/icons/select_check_box_m3.svg'),
        text: 'Select creations'
      ),
      (
        icon: const Icon(Icons.favorite_outline),
        text: 'Add to favorites',
      ),
      (
        icon: const Icon(Icons.create_new_folder_outlined),
        text: 'Add to collection'
      ),
      (
        icon: const SvgIcon('assets/icons/content_copy_m3.svg'),
        text: 'Make a copy',
      ),
      (
        icon: const Icon(Icons.info_outline),
        text: 'View info',
      ),
      (
        icon: const SvgIcon('assets/icons/delete_m3.svg'),
        text: 'Delete',
      ),
    ];

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildListHeader(context),
            for (var item in items)
              _buildListTile(context, item.icon, item.text),
          ],
        ),
      ),
    );
  }

  Widget _buildListHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 64,
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Color(0xFFE8E8E8),
        ),
      )),
      child: Row(
        spacing: 18,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              creation.imageName,
              width: 24,
              height: 24,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none,
            ),
          ),
          Text(
            creation.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, Widget icon, String text) {
    return SizedBox(
      height: 56,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              spacing: 18,
              children: [
                icon,
                Text(
                  text,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
