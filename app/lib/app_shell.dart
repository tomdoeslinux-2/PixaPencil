import 'package:app/screens/collections/collections_screen.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

import 'screens/home/widgets/pxp_navigation_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _pageIndex,
        children: const [
          HomeScreen(),
          CollectionsScreen(),
        ],
      ),
      bottomNavigationBar: PxpNavigationBar(
        selectedIndex: _pageIndex,
        onDestinationChanged: (int index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
}
