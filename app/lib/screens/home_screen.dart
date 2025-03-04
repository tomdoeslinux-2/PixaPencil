import 'package:app/widgets/marquee.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Creation {
  final String title;
  final DateTime lastEdited;
  final String imageName;

  const Creation({
    required this.title,
    required this.lastEdited,
    required this.imageName,
  });
}

String getRelativeTime(DateTime date) {
  final difference = DateTime.now().difference(date);

  if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays > 1 ? 'days' : 'day'} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours > 1 ? 'days' : 'day'} ago';
  }
  if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes > 1 ? 'days' : 'day'} ago';
  } else {
    return 'Just now';
  }
}

final dummyCreations = [
  Creation(
    title: 'Tranquil',
    lastEdited: DateTime(2024, 2, 10),
    imageName: 'assets/images/dummy_img_1.png',
  ),
  Creation(
    title: 'Dinosaur Fossil Sunset',
    lastEdited: DateTime(2024, 1, 15),
    imageName: 'assets/images/dummy_img_2.png',
  ),
  Creation(
    title: 'Autumn Railway Stop',
    lastEdited: DateTime(2023, 12, 5),
    imageName: 'assets/images/dummy_img_3.png',
  ),
  Creation(
    title: 'Mystical Cave Light',
    lastEdited: DateTime(2023, 11, 20),
    imageName: 'assets/images/dummy_img_4.png',
  ),
];

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      },
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_outline,
        color: _isFavorite ? Colors.red : const Color(0xFFB7B4B9),
      ),
    );
  }
}

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

class CreationsGrid extends StatelessWidget {
  const CreationsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr, 1.fr],
      rowSizes: const [auto, auto],
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

class SvgIcon extends StatelessWidget {
  final String name;
  final Color? color;
  final double? size;

  const SvgIcon(
    this.name, {
    super.key,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      name,
      width: size ?? IconTheme.of(context).size,
      height: size ?? IconTheme.of(context).size,
      colorFilter: ColorFilter.mode(
        color ?? IconTheme.of(context).color!,
        BlendMode.srcIn,
      ),
    );
  }
}

class DrawFAB extends StatelessWidget {
  const DrawFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF81C652), Color(0xFF00B09B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(1000),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          )
        ],
      ),
      child: IntrinsicWidth(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            splashColor: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(1000),
            child: const Padding(
              padding: EdgeInsets.only(left: 20, right: 24),
              child: Center(
                child: Row(
                  spacing: 6,
                  children: [
                    SvgIcon(
                      'assets/icons/stylus_note_m3.svg',
                      color: Colors.white,
                    ),
                    Text(
                      'Draw',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const SvgIcon('assets/icons/search_m3.svg'),
          ),
        ],
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('PixaPencil'),
        toolbarHeight: 64,
      ),
      floatingActionButton: const DrawFAB(),
      bottomNavigationBar: const PxpNavigationBar(),
      body: Container(
        color: const Color(0xFFF8F8F8),
        height: double.infinity,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CreationsGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
