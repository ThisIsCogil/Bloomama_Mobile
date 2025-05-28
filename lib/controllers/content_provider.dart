import 'package:flutter/foundation.dart';
import '../models/content_model.dart';
import '../services/api_service.dart';

class ContentProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Content> _contents = [];
  List<Content> _allContents = [];
  List<Content> _oneContents = [];
  bool _isLoading = false;
  String _error = '';

  List<Content> get contents => _contents;
  List<Content> get allContents => _allContents;
  List<Content> get oneContents => _oneContents;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchLatestContent() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _apiService.getLatestContent();
      _contents = data.map((item) => Content.fromJson(item)).toList();
      _error = '';
    } catch (e) {
      _error = e.toString();
      _contents = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOneContent() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _apiService.getOneContent();
      _oneContents = data.map((item) => Content.fromJson(item)).toList();
      _error = '';
    } catch (e) {
      _error = e.toString();
      _contents = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllContent() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _apiService.getAllContent();
      _allContents = data.map((item) => Content.fromJson(item)).toList();
      _error = '';
    } catch (e) {
      _error = e.toString();
      _contents = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchContentByCategory(String category) async {
  try {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    // Gunakan ApiService yang sudah dibuat
    _allContents = await ApiService.getContentByCategory(category);
    
    _isLoading = false;
    notifyListeners();
  } catch (e) {
    _error = e.toString();
    _isLoading = false;
    notifyListeners();
  }
}
}