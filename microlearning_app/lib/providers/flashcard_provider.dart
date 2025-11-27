import 'package:flutter/foundation.dart';
import '../models/flashcard.dart';
import '../services/api_service.dart';

/// Provider de flashcards
class FlashcardProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<ConjuntoFlashcard> _conjuntos = [];
  ConjuntoFlashcard? _conjuntoActual;
  List<Flashcard> _flashcardsActuales = [];
  int _flashcardIndex = 0;
  bool _mostrandoReverso = false;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ConjuntoFlashcard> get conjuntos => _conjuntos;
  ConjuntoFlashcard? get conjuntoActual => _conjuntoActual;
  List<Flashcard> get flashcardsActuales => _flashcardsActuales;
  int get flashcardIndex => _flashcardIndex;
  bool get mostrandoReverso => _mostrandoReverso;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Flashcard? get flashcardActual => 
      _flashcardsActuales.isNotEmpty ? _flashcardsActuales[_flashcardIndex] : null;
  
  bool get hayAnterior => _flashcardIndex > 0;
  bool get haySiguiente => _flashcardIndex < _flashcardsActuales.length - 1;

  /// Cargar conjuntos
  Future<void> loadConjuntos({int? idUsuario}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _conjuntos = await _apiService.getConjuntos(idUsuario: idUsuario);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar conjunto específico con flashcards
  Future<void> loadConjunto(int idConjunto) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _conjuntoActual = await _apiService.getConjunto(idConjunto);
      _flashcardsActuales = _conjuntoActual?.flashcards ?? [];
      _flashcardIndex = 0;
      _mostrandoReverso = false;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Voltear flashcard
  void voltearFlashcard() {
    _mostrandoReverso = !_mostrandoReverso;
    notifyListeners();
  }

  /// Ir a la siguiente flashcard
  void siguienteFlashcard() {
    if (haySiguiente) {
      _flashcardIndex++;
      _mostrandoReverso = false;
      notifyListeners();
    }
  }

  /// Ir a la flashcard anterior
  void anteriorFlashcard() {
    if (hayAnterior) {
      _flashcardIndex--;
      _mostrandoReverso = false;
      notifyListeners();
    }
  }

  /// Ir a una flashcard específica
  void irAFlashcard(int index) {
    if (index >= 0 && index < _flashcardsActuales.length) {
      _flashcardIndex = index;
      _mostrandoReverso = false;
      notifyListeners();
    }
  }

  /// Limpiar error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Resetear provider
  void reset() {
    _conjuntos = [];
    _conjuntoActual = null;
    _flashcardsActuales = [];
    _flashcardIndex = 0;
    _mostrandoReverso = false;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
