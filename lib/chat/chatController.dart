import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

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
  
  // Função para compartilhar uma resposta específica
  Future<void> shareResponse(Map<String, String> message) async {
    if (message['text'] == null || message['text']!.isEmpty) return;
    
    try {
      await Share.share(message['text']!);
    } catch (e) {
      debugPrint('Erro ao compartilhar mensagem: $e');
    }
  }
  
  // Função para copiar a resposta para a área de transferência
  Future<void> copyResponseToClipboard(Map<String, String> message) async {
    if (message['text'] == null || message['text']!.isEmpty) return;
    
    try {
      await Clipboard.setData(ClipboardData(text: message['text']!));
    } catch (e) {
      debugPrint('Erro ao copiar mensagem: $e');
    }
  }
}
