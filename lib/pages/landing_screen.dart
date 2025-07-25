import 'package:flutter/material.dart';
import 'package:snap_walls/pages/favorites_screen.dart';
import 'package:snap_walls/pages/settings_screen.dart';
import 'package:snap_walls/pages/home_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _currentIndex = 0;
  bool _isVisible = true;

  List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    screens = [
      HomeScreen(
        isScrolling: isScrolling,
      ),
      FavoritesScreen(),
      SettingsScreen()
    ];
  }

  isScrolling(bool visibility) {
    setState(() {
      _isVisible = visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _isVisible ? 80 : 0,
        child: Wrap(
          children: [
            BottomNavigationBar(
                onTap: (value) {
                  setState(() {
                    _currentIndex = value;
                  });
                },
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                currentIndex: _currentIndex,
                iconSize: 25,
                unselectedItemColor: Colors.grey,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.favorite), label: "Favorites"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: "Settings"),
                ])
          ],
        ),
      ),
    );
  }
}
