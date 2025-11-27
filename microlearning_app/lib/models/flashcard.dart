/// Modelo de Flashcard
class Flashcard {
  final String idFlashcard;
  final String titulo;
  final String contenidoFrontal;
  final String contenidoTrasero;
  final String tipoContenido;
  final int orden;
  final int idConjunto;
  final String? fechaCreacion;

  Flashcard({
    required this.idFlashcard,
    required this.titulo,
    required this.contenidoFrontal,
    required this.contenidoTrasero,
    this.tipoContenido = 'texto',
    this.orden = 0,
    required this.idConjunto,
    this.fechaCreacion,
  });

  /// Crear Flashcard desde JSON
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      idFlashcard: json['id_flashcard'] as String,
      titulo: json['titulo'] as String,
      contenidoFrontal: json['contenido_frontal'] as String,
      contenidoTrasero: json['contenido_trasero'] as String,
      tipoContenido: json['tipo_contenido'] as String? ?? 'texto',
      orden: json['orden'] as int? ?? 0,
      idConjunto: json['id_conjunto'] as int,
      fechaCreacion: json['fecha_creacion'] as String?,
    );
  }

  /// Convertir Flashcard a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_flashcard': idFlashcard,
      'titulo': titulo,
      'contenido_frontal': contenidoFrontal,
      'contenido_trasero': contenidoTrasero,
      'tipo_contenido': tipoContenido,
      'orden': orden,
      'id_conjunto': idConjunto,
      'fecha_creacion': fechaCreacion,
    };
  }

  /// Copiar con modificaciones
  Flashcard copyWith({
    String? idFlashcard,
    String? titulo,
    String? contenidoFrontal,
    String? contenidoTrasero,
    String? tipoContenido,
    int? orden,
    int? idConjunto,
    String? fechaCreacion,
  }) {
    return Flashcard(
      idFlashcard: idFlashcard ?? this.idFlashcard,
      titulo: titulo ?? this.titulo,
      contenidoFrontal: contenidoFrontal ?? this.contenidoFrontal,
      contenidoTrasero: contenidoTrasero ?? this.contenidoTrasero,
      tipoContenido: tipoContenido ?? this.tipoContenido,
      orden: orden ?? this.orden,
      idConjunto: idConjunto ?? this.idConjunto,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  /// Verificar si el contenido frontal es una imagen
  bool get esImagen => tipoContenido == 'imagen' || tipoContenido == 'grafico';
}

/// Modelo de Conjunto de Flashcards
class ConjuntoFlashcard {
  final int idConjunto;
  final String titulo;
  final String? descripcion;
  final int idUsuario;
  final String? fechaCreacion;
  final List<Flashcard>? flashcards;

  ConjuntoFlashcard({
    required this.idConjunto,
    required this.titulo,
    this.descripcion,
    required this.idUsuario,
    this.fechaCreacion,
    this.flashcards,
  });

  /// Crear ConjuntoFlashcard desde JSON
  factory ConjuntoFlashcard.fromJson(Map<String, dynamic> json) {
    return ConjuntoFlashcard(
      idConjunto: json['id_conjunto'] as int,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String?,
      idUsuario: json['id_usuario'] as int,
      fechaCreacion: json['fecha_creacion'] as String?,
      flashcards: json['flashcards'] != null
          ? (json['flashcards'] as List)
              .map((f) => Flashcard.fromJson(f as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  /// Convertir ConjuntoFlashcard a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_conjunto': idConjunto,
      'titulo': titulo,
      'descripcion': descripcion,
      'id_usuario': idUsuario,
      'fecha_creacion': fechaCreacion,
      'flashcards': flashcards?.map((f) => f.toJson()).toList(),
    };
  }

  /// Copiar con modificaciones
  ConjuntoFlashcard copyWith({
    int? idConjunto,
    String? titulo,
    String? descripcion,
    int? idUsuario,
    String? fechaCreacion,
    List<Flashcard>? flashcards,
  }) {
    return ConjuntoFlashcard(
      idConjunto: idConjunto ?? this.idConjunto,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      idUsuario: idUsuario ?? this.idUsuario,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      flashcards: flashcards ?? this.flashcards,
    );
  }

  /// Obtener cantidad de flashcards
  int get cantidadFlashcards => flashcards?.length ?? 0;
}

/// Request para crear flashcard
class FlashcardCreateRequest {
  final String titulo;
  final String contenidoFrontal;
  final String contenidoTrasero;
  final String tipoContenido;
  final int orden;
  final int idConjunto;

  FlashcardCreateRequest({
    required this.titulo,
    required this.contenidoFrontal,
    required this.contenidoTrasero,
    this.tipoContenido = 'texto',
    this.orden = 0,
    required this.idConjunto,
  });

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'contenido_frontal': contenidoFrontal,
      'contenido_trasero': contenidoTrasero,
      'tipo_contenido': tipoContenido,
      'orden': orden,
      'id_conjunto': idConjunto,
    };
  }
}
