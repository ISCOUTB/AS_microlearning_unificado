import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';

/// Provider de autenticación
class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  Usuario? _usuario;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  // Getters
  Usuario? get usuario => _usuario;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Constructor - Verifica si hay sesión guardada
  AuthProvider() {
    _checkAuthStatus();
  }

  /// Verificar si hay sesión guardada
  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      final userName = prefs.getString('user_name');
      final userEmail = prefs.getString('user_email');

      if (userId != null && userName != null && userEmail != null) {
        _usuario = Usuario(
          idUsuario: userId,
          nombre: userName,
          correo: userEmail,
        );
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error al verificar autenticación: $e');
    }
  }

  /// Login
  Future<bool> login(String correo, String contrasena) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(correo, contrasena);
      
      _usuario = Usuario(
        idUsuario: response.idUsuario,
        nombre: response.nombre,
        correo: correo,
      );
      _isAuthenticated = true;

      // Guardar sesión
      await _saveSession();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Registro
  Future<bool> register(String nombre, String correo, String contrasena) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final usuario = await _apiService.registrar(nombre, correo, contrasena);
      
      _usuario = usuario;
      _isAuthenticated = true;

      // Guardar sesión
      await _saveSession();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Guardar sesión en SharedPreferences
  Future<void> _saveSession() async {
    if (_usuario != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', _usuario!.idUsuario);
      await prefs.setString('user_name', _usuario!.nombre);
      await prefs.setString('user_email', _usuario!.correo);
    }
  }

  /// Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    _usuario = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  /// Limpiar error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
