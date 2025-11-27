import 'package:flutter/material.dart';
import 'video_list_screen.dart';
import 'flashcard_list_screen.dart';
import 'profile_screen.dart';

/// Shell de la aplicación con navegación inferior
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const Color azulUTP = Color(0xFF0A45C2);
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const VideoListScreen(),
    const FlashcardListScreen(),
    const Center(child: Text('Estadísticas')),
    const Center(child: Text('Notificaciones')),
    const ProfileScreen(),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 60,
        color: azulUTP,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Home
            Expanded(
              child: GestureDetector(
                onTap: () => _onNavItemTapped(0),
                child: Container(
                  color: Colors.transparent,
                  child: Icon(
                    Icons.home,
                    color: _selectedIndex == 0 ? Colors.white : Colors.white70,
                    size: 24,
                  ),
                ),
              ),
            ),
            // Lock
            Expanded(
              child: GestureDetector(
                onTap: () => _onNavItemTapped(1),
                child: Container(
                  color: Colors.transparent,
                  child: Icon(
                    Icons.lock,
                    color: _selectedIndex == 1 ? Colors.white : Colors.white70,
                    size: 24,
                  ),
                ),
              ),
            ),
            // Settings
            Expanded(
              child: GestureDetector(
                onTap: () => _onNavItemTapped(2),
                child: Container(
                  color: Colors.transparent,
                  child: Icon(
                    Icons.settings,
                    color: _selectedIndex == 2 ? Colors.white : Colors.white70,
                    size: 24,
                  ),
                ),
              ),
            ),
            // Play
            Expanded(
              child: GestureDetector(
                onTap: () => _onNavItemTapped(3),
                child: Container(
                  color: Colors.transparent,
                  child: Icon(
                    Icons.play_circle_fill,
                    color: _selectedIndex == 3 ? Colors.white : Colors.white70,
                    size: 24,
                  ),
                ),
              ),
            ),
            // Person
            Expanded(
              child: GestureDetector(
                onTap: () => _onNavItemTapped(4),
                child: Container(
                  color: Colors.transparent,
                  child: Icon(
                    Icons.person,
                    color: _selectedIndex == 4 ? Colors.white : Colors.white70,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
