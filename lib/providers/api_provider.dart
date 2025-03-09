import 'package:flutter/foundation.dart';
import 'package:jesusapp/models/api/chat_response.dart';
import 'package:jesusapp/models/api/prayer_response.dart';
import 'package:jesusapp/models/api/verse_response.dart';
import 'package:jesusapp/services/api/api_service.dart';
import 'package:jesusapp/services/api/api_exceptions.dart';

class ApiProvider extends ChangeNotifier {
  final ApiService _apiService;
  bool _isLoading = false;
  bool _isOffline = false;
  String? _error;

  ApiProvider(String flavor) : _apiService = ApiService(flavor);

  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  String? get error => _error;

  Future<void> checkApiHealth() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _apiService.checkApiHealth();
      _isOffline = false;
    } catch (e) {
      _isOffline = true;
      _error = 'API indisponível';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
