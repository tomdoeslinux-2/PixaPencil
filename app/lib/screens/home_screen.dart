import 'package:app/widgets/marquee.dart';
import 'package:flutter/material.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
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
          ),
          SizedBox(
            height: 66,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // prevent column from overflowing row, and pushing the other row item outta bounds
                  Expanded(
                    child: Column(
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
                    ),
                  ),
                  const FavoriteButton(),
                ],
              ),
            ),
          ),
        ],
      ),
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
  final double size;

  const SvgIcon(
    this.name, {
    super.key,
    this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      name,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).iconTheme.color!,
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      // update to new icons
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.white,
        destinations: const [
          NavigationDestination(
            icon: SvgIcon(
              'assets/icons/home_outlined_m3.svg',
              size: 32,
            ),
            selectedIcon: SvgIcon(
              'assets/icons/home_m3.svg',
              size: 32,
              color: Color(0xFF6495ED),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.folder_outlined,
              size: 32,
            ),
            selectedIcon: Icon(
              Icons.folder,
              size: 32,
              color: Color(0xFF6495ED),
            ),
            label: 'Collections',
          ),
          NavigationDestination(
            icon: SvgIcon(
              'assets/icons/explore_outlined_m3.svg',
              size: 32,
            ),
            selectedIcon: SvgIcon(
              'assets/icons/explore_m3.svg',
              size: 32,
              color: Color(0xFF6495ED),
            ),
            label: 'Explore',
          ),
        ],
      ),
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
