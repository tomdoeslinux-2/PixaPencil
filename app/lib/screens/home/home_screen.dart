import 'dart:ui';

import 'package:app/screens/drawing2/drawing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'widgets/creations_grid.dart';
import 'widgets/draw_fab.dart';
import 'widgets/pxp_navigation_bar.dart';
import '../../widgets/svg_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _showFAB = ValueNotifier(true);
  double _totalScrollDelta = 0.0;
  double _lastScrollOffset = 0.0;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _showFAB.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    const scrollThreshold = 200.0;
    final currentScrollOffset = _scrollController.offset;
    final scrollDelta = (_lastScrollOffset - currentScrollOffset).abs();

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_totalScrollDelta > scrollThreshold) {
        _showFAB.value = false;
        _totalScrollDelta = 0;
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_totalScrollDelta > scrollThreshold) {
        _showFAB.value = true;
        _totalScrollDelta = 0;
      }
    }

    _lastScrollOffset = currentScrollOffset;
    _totalScrollDelta += scrollDelta;
  }

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
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('PixaPencil'),
        toolbarHeight: 64,
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _showFAB,
        builder: (_, isVisible, ___) {
          return DrawFAB(
            isExpanded: isVisible,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => DrawingScreen(),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const PxpNavigationBar(),
      body: Container(
        color: const Color(0xFFF8F8F8),
        height: double.infinity,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: const Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: CreationsGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
