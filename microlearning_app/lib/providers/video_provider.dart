import 'package:flutter/foundation.dart';
import '../models/video.dart';
import '../services/api_service.dart';

/// Provider de videos
class VideoProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Video> _videos = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _error;

  // Getters
  List<Video> get videos => _videos;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  /// Cargar videos
  Future<void> loadVideos({bool refresh = false}) async {
    if (_isLoading) return;
    
    if (refresh) {
      _currentPage = 1;
      _videos = [];
      _hasMore = true;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getVideos(page: _currentPage);
      
      if (refresh) {
        _videos = response.videos;
      } else {
        _videos.addAll(response.videos);
      }
      
      _hasMore = response.hasMore;
      _currentPage++;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle like en video
  Future<void> toggleLike(String idVideo, int idUsuario) async {
    try {
      final result = await _apiService.toggleLike(idVideo, idUsuario);
      
      // Actualizar el video en la lista
      final index = _videos.indexWhere((v) => v.idVideo == idVideo);
      if (index != -1) {
        _videos[index] = _videos[index].copyWith(
          likes: result['likes'] as int,
          liked: result['liked'] as bool,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
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
    _videos = [];
    _currentPage = 1;
    _hasMore = true;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
