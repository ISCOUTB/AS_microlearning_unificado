/// Constantes de configuración de la API
class ApiConstants {
  // URL base de la API
  // IMPORTANTE: Cambiar esta URL según tu configuración
  // Para desarrollo local: 'http://10.0.2.2:8000' (Android Emulator)
  // Para desarrollo local en Web: 'http://localhost:8000'
  // Usamos localhost para desarrollo en la misma máquina (web)
  // Producción: https://as-microlearning-unificado-master.fly.dev
  static const String baseUrl = 'https://as-microlearning-unificado-master.fly.dev';
  
  // Endpoints de Usuarios
  static const String login = '/login';
  static const String register = '/usuarios';
  static const String usuarios = '/usuarios';
  
  // Endpoints de Videos
  static const String videos = '/videos';
  static const String uploadVideo = '/upload_video';
  static const String videosNuevos = '/videos/nuevos';
  
  // Endpoints de Likes
  static String videoLike(String idVideo) => '/videos/$idVideo/like';
  
  // Endpoints de Etiquetas
  static const String etiquetas = '/etiquetas';
  
  // Endpoints de Flashcards
  static const String conjuntos = '/conjuntos';
  static const String flashcards = '/flashcards';
  static String conjuntoById(int id) => '/conjuntos/$id';
  static String flashcardById(String id) => '/flashcards/$id';
  static String flashcardsByConjunto(int idConjunto) => '/conjuntos/$idConjunto/flashcards';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
