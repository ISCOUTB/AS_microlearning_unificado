import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/flashcard_provider.dart';

/// Pantalla de visualización de flashcards
class FlashcardScreen extends StatefulWidget {
  final int conjuntoId;

  const FlashcardScreen({
    super.key,
    required this.conjuntoId,
  });

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  static const Color azulUTP = Color(0xFF0A45C2);
  static const Color azulClaro = Color(0xFFBFD0FF);

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    _loadFlashcards();
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _loadFlashcards() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final flashcardProvider =
          Provider.of<FlashcardProvider>(context, listen: false);
      flashcardProvider.loadConjunto(widget.conjuntoId);
    });
  }

  void _voltearFlashcard() {
    final flashcardProvider =
        Provider.of<FlashcardProvider>(context, listen: false);
    
    if (flashcardProvider.mostrandoReverso) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    
    flashcardProvider.voltearFlashcard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // AppBar personalizada
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                Consumer<FlashcardProvider>(
                  builder: (context, provider, child) {
                    return Text(
                      provider.conjuntoActual?.titulo ?? 'Flashcards',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.black),
                  onPressed: () {
                    // TODO: Compartir flashcard
                  },
                ),
              ],
            ),
          ),

          // Contenido principal
          Expanded(
            child: Consumer<FlashcardProvider>(
              builder: (context, flashcardProvider, child) {
                if (flashcardProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (flashcardProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(flashcardProvider.error ?? 'Error desconocido'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadFlashcards,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (flashcardProvider.flashcardsActuales.isEmpty) {
                  return const Center(
                    child: Text('No hay flashcards en este conjunto'),
                  );
                }

                final flashcard = flashcardProvider.flashcardActual!;

                return Column(
                  children: [
                    // Indicador de progreso
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Text(
                            '${flashcardProvider.flashcardIndex + 1}/${flashcardProvider.flashcardsActuales.length}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            flashcardProvider.mostrandoReverso
                                ? 'Respuesta'
                                : 'Pregunta',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Flashcard con animación de volteo
                    Expanded(
                      child: GestureDetector(
                        onTap: _voltearFlashcard,
                        child: AnimatedBuilder(
                          animation: _flipAnimation,
                          builder: (context, child) {
                            final angle = _flipAnimation.value * math.pi;
                            final transform = Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(angle);

                            return Transform(
                              transform: transform,
                              alignment: Alignment.center,
                              child: angle >= math.pi / 2
                                  ? Transform(
                                      transform: Matrix4.identity()..rotateY(math.pi),
                                      alignment: Alignment.center,
                                      child: _buildFlashcardBack(flashcard),
                                    )
                                  : _buildFlashcardFront(flashcard),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Controles de acciones
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Botón agregar
                          IconButton(
                            onPressed: () {
                              // TODO: Agregar a favoritos
                            },
                            icon: const Icon(Icons.add_circle_outline, color: Colors.green, size: 32),
                          ),
                          // Botón actualizar
                          IconButton(
                            onPressed: _voltearFlashcard,
                            icon: const Icon(Icons.refresh, color: azulUTP, size: 32),
                          ),
                          // Botón eliminar
                          IconButton(
                            onPressed: () {
                              // TODO: Eliminar o desmarcar
                            },
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 32),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Controles de navegación
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Botón anterior
                          IconButton(
                            onPressed: flashcardProvider.hayAnterior
                                ? () {
                                    _flipController.reset();
                                    flashcardProvider.anteriorFlashcard();
                                  }
                                : null,
                            icon: const Icon(Icons.arrow_back),
                            iconSize: 28,
                          ),

                          // Botón voltear
                          ElevatedButton(
                            onPressed: _voltearFlashcard,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: azulUTP,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'Voltear',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                          // Botón siguiente
                          IconButton(
                            onPressed: flashcardProvider.haySiguiente
                                ? () {
                                    _flipController.reset();
                                    flashcardProvider.siguienteFlashcard();
                                  }
                                : null,
                            icon: const Icon(Icons.arrow_forward),
                            iconSize: 28,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Barra inferior de navegación
          Container(
            height: 60,
            color: azulUTP,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    // TODO: Navegar a inicio
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.lock, color: Colors.white),
                  onPressed: () {
                    // TODO: Navegar a seguridad
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    // TODO: Navegar a configuración
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.play_circle_fill, color: Colors.white),
                  onPressed: () {
                    // TODO: Navegar a videos
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    // TODO: Navegar a perfil
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardFront(flashcard) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: azulClaro,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pregunta
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  flashcard.contenidoFrontal,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Indicador
          const Text(
            'Toca para ver la respuesta',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardBack(flashcard) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: azulClaro,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Respuesta
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  flashcard.contenidoTrasero,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Indicador
          const Text(
            'Toca para volver a la pregunta',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
