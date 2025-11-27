import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'video_list_screen.dart';
import 'flashcard_list_screen.dart';

/// Pantalla principal con navegación inferior
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Lista de pantallas
  late final List<Widget> _screens = [
    const VideoListScreen(), // Inicio - Videos
    const FlashcardListScreen(), // Flashcards
    const Center(child: Text('Estadísticas')), // Placeholder
    const Center(child: Text('Notificaciones')), // Placeholder
    const ProfileScreen(), // Perfil
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Prevenir navegación atrás desde la pantalla principal
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
    );
  }
}
