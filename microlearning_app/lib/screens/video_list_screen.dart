import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import '../providers/auth_provider.dart';

/// Pantalla de lista de videos
class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  static const Color azulUTP = Color(0xFF0A45C2);

  @override
  void initState() {
    super.initState();
    _loadVideos();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadVideos() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final videoProvider = Provider.of<VideoProvider>(context, listen: false);
      videoProvider.loadVideos(refresh: true);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final videoProvider = Provider.of<VideoProvider>(context, listen: false);
      if (!videoProvider.isLoading && videoProvider.hasMore) {
        videoProvider.loadVideos();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Funcionalidad de upload en desarrollo')),
          );
        },
        backgroundColor: azulUTP,
        child: const Icon(Icons.cloud_upload, color: Colors.white),
      ),
      body: Column(
        children: [
          // Header con buscador
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Barra de búsqueda
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar videos...',
                          prefixIcon: const Icon(Icons.search, color: azulUTP),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (value) {
                          // TODO: Filtrar videos por búsqueda
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Botón de filtro
                    IconButton(
                      icon: const Icon(Icons.tune, color: azulUTP),
                      onPressed: () {
                        // TODO: Mostrar opciones de filtro
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de videos
          Expanded(
            child: Consumer<VideoProvider>(
              builder: (context, videoProvider, child) {
                if (videoProvider.isLoading && videoProvider.videos.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (videoProvider.error != null && videoProvider.videos.isEmpty) {
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
                        const Text('Error al cargar videos'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadVideos,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (videoProvider.videos.isEmpty) {
                  return const Center(
                    child: Text('No hay videos disponibles'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await videoProvider.loadVideos(refresh: true);
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: videoProvider.videos.length +
                        (videoProvider.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= videoProvider.videos.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final video = videoProvider.videos[index];
                      final authProvider = Provider.of<AuthProvider>(context);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Stack(
                          children: [
                            // Contenido del video
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Thumbnail
                                Container(
                                  height: 160,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFBFD0FF),
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.play_circle,
                                      size: 64,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                // Información del video
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        video.titulo,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (video.descripcion != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          video.descripcion!,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                      const SizedBox(height: 8),
                                      // Acciones horizontales
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            // Like
                                            GestureDetector(
                                              onTap: () {
                                                if (authProvider.usuario != null) {
                                                  videoProvider.toggleLike(
                                                    video.idVideo,
                                                    authProvider.usuario!.idUsuario,
                                                  );
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    video.liked
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: video.liked
                                                        ? Colors.red
                                                        : Colors.grey,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${video.likes}',
                                                    style: const TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            // Comentarios
                                            GestureDetector(
                                              onTap: () {
                                                // TODO: Abrir comentarios
                                              },
                                              child: const Row(
                                                children: [
                                                  Icon(Icons.comment_outlined, size: 20, color: Colors.grey),
                                                  SizedBox(width: 4),
                                                  Text('0', style: TextStyle(fontSize: 12)),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            // Compartir
                                            GestureDetector(
                                              onTap: () {
                                                // TODO: Compartir video
                                              },
                                              child: const Row(
                                                children: [
                                                  Icon(Icons.share_outlined, size: 20, color: Colors.grey),
                                                  SizedBox(width: 4),
                                                  Text('Compartir', style: TextStyle(fontSize: 12)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Botón de reproducir en la esquina superior derecha
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  // TODO: Reproducir video
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
