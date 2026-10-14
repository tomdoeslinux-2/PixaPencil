import 'dart:async';

import 'package:app/screens/collections/collections_screen.dart';
import 'package:app/screens/explore/explore_screen.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/screens/signup/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens/home/widgets/pxp_navigation_bar.dart';
import 'widgets/svg_icon.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _pageIndex = 0;
  late final Stream<User?> _authStream;

  @override
  void initState() {
    super.initState();
    _authStream = FirebaseAuth.instance.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          },
        ),
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
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            StreamBuilder(
              stream: _authStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error fetching user');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading user info...');
                }

                if (snapshot.data != null) {
                  return const Text('Signed in');
                }

                return const Text('Signed out');
              },
            ),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignupScreen(),
                  ),
                );
              },
              child: const Text('Create Account'),
            ),
            FilledButton(onPressed: () {}, child: const Text('Login')),
          ],
        ),
      ),
      body: IndexedStack(
        index: _pageIndex,
        children: const [
          HomeScreen(),
          CollectionsScreen(),
          ExploreScreen(),
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
