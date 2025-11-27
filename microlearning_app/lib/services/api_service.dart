import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_constants.dart';
import '../models/usuario.dart';
import '../models/video.dart';
import '../models/flashcard.dart';

/// Servicio principal de API
class ApiService {
  final String baseUrl;

  ApiService({String? baseUrl}) : baseUrl = baseUrl ?? ApiConstants.baseUrl;

  /// Headers por defecto
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // =====================================================
  // AUTENTICACIÓN
  // =====================================================

  /// Login de usuario
  Future<LoginResponse> login(String correo, String contrasena) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConstants.login}'),
        headers: _headers,
        body: jsonEncode({
          'correo': correo,
          'contrasena': contrasena,
        }),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error en login: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Registro de usuario
  Future<Usuario> registrar(String nombre, String correo, String contrasena) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConstants.register}'),
        headers: _headers,
        body: jsonEncode({
          'nombre': nombre,
          'correo': correo,
          'contrasena': contrasena,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Usuario.fromJson(jsonDecode(response.body));
      } else {
        // Incluimos statusCode en el mensaje para facilitar debugging desde la UI
        throw Exception('Error en registro: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // =====================================================
  // VIDEOS
  // =====================================================

  /// Obtener lista de videos
  Future<VideosResponse> getVideos({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.videos}?page=$page'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return VideosResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener videos: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Toggle like en video
  Future<Map<String, dynamic>> toggleLike(String idVideo, int idUsuario) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConstants.videoLike(idVideo)}?id_usuario=$idUsuario'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al dar like: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Obtener estado de like
  Future<Map<String, dynamic>> getLikeStatus(String idVideo, int idUsuario) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.videoLike(idVideo)}?id_usuario=$idUsuario'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener like: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // =====================================================
  // FLASHCARDS
  // =====================================================

  /// Obtener conjuntos de flashcards
  Future<List<ConjuntoFlashcard>> getConjuntos({int? idUsuario}) async {
    try {
      String url = '$baseUrl${ApiConstants.conjuntos}';
      if (idUsuario != null) {
        url += '?id_usuario=$idUsuario';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ConjuntoFlashcard.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener conjuntos: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Obtener conjunto específico con flashcards
  Future<ConjuntoFlashcard> getConjunto(int idConjunto) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.conjuntoById(idConjunto)}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return ConjuntoFlashcard.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener conjunto: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Obtener flashcards de un conjunto
  Future<List<Flashcard>> getFlashcardsByConjunto(int idConjunto) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.flashcardsByConjunto(idConjunto)}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Flashcard.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener flashcards: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Crear conjunto de flashcards
  Future<ConjuntoFlashcard> crearConjunto(
    String titulo,
    String descripcion,
    int idUsuario,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConstants.conjuntos}'),
        headers: _headers,
        body: jsonEncode({
          'titulo': titulo,
          'descripcion': descripcion,
          'id_usuario': idUsuario,
        }),
      );

      if (response.statusCode == 200) {
        return ConjuntoFlashcard.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al crear conjunto: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Crear flashcard
  Future<Flashcard> crearFlashcard(FlashcardCreateRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConstants.flashcards}'),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return Flashcard.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al crear flashcard: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
