/// Modelo de Video
class Video {
  final String idVideo;
  final String titulo;
  final String? descripcion;
  final String ruta;
  final String? usuario;
  final String? etiqueta;
  final int likes;
  final bool liked;

  Video({
    required this.idVideo,
    required this.titulo,
    this.descripcion,
    required this.ruta,
    this.usuario,
    this.etiqueta,
    this.likes = 0,
    this.liked = false,
  });

  /// Crear Video desde JSON
  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      idVideo: json['id_video'] as String,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String?,
      ruta: json['ruta'] as String,
      usuario: json['usuario'] as String?,
      etiqueta: json['etiqueta'] as String?,
      likes: json['likes'] as int? ?? 0,
      liked: json['liked'] as bool? ?? false,
    );
  }

  /// Convertir Video a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_video': idVideo,
      'titulo': titulo,
      'descripcion': descripcion,
      'ruta': ruta,
      'usuario': usuario,
      'etiqueta': etiqueta,
      'likes': likes,
      'liked': liked,
    };
  }

  /// Copiar con modificaciones
  Video copyWith({
    String? idVideo,
    String? titulo,
    String? descripcion,
    String? ruta,
    String? usuario,
    String? etiqueta,
    int? likes,
    bool? liked,
  }) {
    return Video(
      idVideo: idVideo ?? this.idVideo,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      ruta: ruta ?? this.ruta,
      usuario: usuario ?? this.usuario,
      etiqueta: etiqueta ?? this.etiqueta,
      likes: likes ?? this.likes,
      liked: liked ?? this.liked,
    );
  }

  /// Obtener URL completa del video
  String getFullUrl(String baseUrl) {
    if (ruta.startsWith('http')) {
      return ruta;
    }
    return '$baseUrl/$ruta';
  }
}

/// Response de lista de videos
class VideosResponse {
  final int page;
  final List<Video> videos;
  final bool hasMore;

  VideosResponse({
    required this.page,
    required this.videos,
    required this.hasMore,
  });

  factory VideosResponse.fromJson(Map<String, dynamic> json) {
    return VideosResponse(
      page: json['page'] as int,
      videos: (json['videos'] as List)
          .map((v) => Video.fromJson(v as Map<String, dynamic>))
          .toList(),
      hasMore: json['has_more'] as bool,
    );
  }
}
