import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../providers/auth_provider.dart';
import 'flashcard_screen.dart';

/// Pantalla de lista de conjuntos de flashcards
class FlashcardListScreen extends StatefulWidget {
  const FlashcardListScreen({super.key});

  @override
  State<FlashcardListScreen> createState() => _FlashcardListScreenState();
}

class _FlashcardListScreenState extends State<FlashcardListScreen> {
  static const Color azulUTP = Color(0xFF0A45C2);
  static const Color azulClaro = Color(0xFFBFD0FF);

  @override
  void initState() {
    super.initState();
    _loadConjuntos();
  }

  void _loadConjuntos() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final flashcardProvider =
          Provider.of<FlashcardProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      if (authProvider.usuario != null) {
        flashcardProvider.loadConjuntos(
          idUsuario: authProvider.usuario!.idUsuario,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Crear nuevo conjunto de flashcards - en desarrollo')),
          );
        },
        backgroundColor: azulUTP,
        child: const Icon(Icons.add_card, color: Colors.white),
      ),
      body: Column(
        children: [
          // AppBar personalizada
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Flashcards',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    // TODO: Implementar búsqueda
                  },
                ),
              ],
            ),
          ),

          // Lista de conjuntos
          Expanded(
            child: Consumer<FlashcardProvider>(
              builder: (context, flashcardProvider, child) {
                if (flashcardProvider.isLoading &&
                    flashcardProvider.conjuntos.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (flashcardProvider.error != null &&
                    flashcardProvider.conjuntos.isEmpty) {
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
                        const Text('Error al cargar flashcards'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadConjuntos,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (flashcardProvider.conjuntos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.style_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text('No hay flashcards disponibles'),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    _loadConjuntos();
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: flashcardProvider.conjuntos.length,
                    itemBuilder: (context, index) {
                      final conjunto = flashcardProvider.conjuntos[index];

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FlashcardScreen(
                                  conjuntoId: conjunto.idConjunto,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icono
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: azulClaro,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.style,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Título
                                Text(
                                  conjunto.titulo,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                // Descripción
                                if (conjunto.descripcion != null)
                                  Text(
                                    conjunto.descripcion!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                const Spacer(),
                                // Cantidad de flashcards
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: azulUTP.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${conjunto.cantidadFlashcards} cards',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: azulUTP,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
