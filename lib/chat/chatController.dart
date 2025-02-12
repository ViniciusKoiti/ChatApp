import 'package:flutter/material.dart';

abstract class IApiService {
  Future<String> getResponse(String message);
}

class ChatController extends ChangeNotifier {
  final IApiService apiService;
  final List<Map<String, String>> _messages = [];

  ChatController({required this.apiService});

  List<Map<String, String>> get messages => List.unmodifiable(_messages);

  void sendMessage(String message) {
    if (message.trim().isEmpty) return;

    _messages.add({'role': 'user', 'text': message});
    notifyListeners();

    _fetchAiResponse(message);
  }

  Future<void> _fetchAiResponse(String message) async {
    final response = await apiService.getResponse(message);

    _messages.add({'role': 'ai', 'text': response});
    notifyListeners();
  }
}
