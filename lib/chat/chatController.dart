import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:jesusapp/services/mock/mockAiService.dart';
import 'package:jesusapp/services/api/interfaces/i_api_service.dart';
import 'package:jesusapp/services/api/interfaces/i_verse_service.dart';
import 'package:provider/provider.dart';

class ChatController extends ChangeNotifier {
  final IApiService apiService;
  final ThemeProvider themeProvider;
  final IVerseService verseService;

  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  ChatController({
    required this.apiService,
    required this.themeProvider,
    required this.verseService,
  }) {
    _initializeMessages();
  }

  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> _initializeMessages() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      final appType =
          themeProvider.getConfig<String>('appType', defaultValue: '') ?? '';
      final isChristian = appType == 'christian';

      if (isChristian) {
        _messages.add({
          'role': 'ai',
          'text':
              'Bem-vindo ao Assistente Cristão! Estou aqui para ajudar em sua jornada de fé. Você pode me perguntar sobre temas bíblicos, reflexões espirituais ou buscar palavras de encorajamento. Como posso auxiliar em sua caminhada cristã hoje?'
        });

        try {
          final verse = await verseService.getRandomVerse();
          _messages.add({
            'role': 'ai',
            'text':
                '📖 *Versículo do dia:* "${verse.text}" - ${verse.reference}'
          });
        } catch (e) {
          debugPrint('Erro ao obter versículo aleatório: $e');
          final fallbackVerse = _getFallbackVerse();
          _messages.add(
              {'role': 'ai', 'text': '📖 *Versículo do dia:* $fallbackVerse'});
        }
      }
    } catch (e) {
      debugPrint('Erro ao inicializar mensagens: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _getFallbackVerse() {
    final verses = [
      '"Porque Deus amou o mundo de tal maneira que deu o seu Filho unigênito, para que todo aquele que nele crê não pereça, mas tenha a vida eterna." - João 3:16',
      '"O Senhor é o meu pastor, nada me faltará." - Salmos 23:1',
      '"Tudo posso naquele que me fortalece." - Filipenses 4:13',
      '"E conhecereis a verdade, e a verdade vos libertará." - João 8:32',
    ];

    verses.shuffle();
    return verses.first;
  }

  void sendMessage(String message) {
    if (message.trim().isEmpty) return;

    _messages.add({'role': 'user', 'text': message});
    notifyListeners();

    _fetchAiResponse(message);
  }

Future<void> _fetchAiResponse(String message) async {
  try {
    _isLoading = true;
    notifyListeners();

    final flavor = themeProvider.getConfig<String>('appType', defaultValue: '');
    debugPrint('sendMessage: $message, $flavor');

    final messageIndex = _initializeMessage();

    final stream = apiService.sendMessageStream(
      message: message,
      flavor: flavor,
      context: null,
    );

    await _processResponseStream(stream, messageIndex);

  } catch (e) {
    debugPrint('Erro inesperado: $e');
    await _fetchAiResponseFallback(message);
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


int _initializeMessage() {
  final messageIndex = _messages.length;
  _messages.add({
    'role': 'ai',
    'text': 'Digitando...',
    'references': [],
    'suggestions': [],
  });
  notifyListeners();
  return messageIndex;
}

Future<void> _processResponseStream(
  Stream<String> stream, 
  int messageIndex
) async {
  String fullResponse = '';

  try {
    await for (final chunk in stream) {
      debugPrint('Chunk recebido: ${chunk.length} caracteres');

      fullResponse += chunk;

      _updateMessage(
        index: messageIndex,
        text: fullResponse.endsWith('.') ? fullResponse : '$fullResponse...',
      );

      await Future.delayed(const Duration(milliseconds: 20));
    }

    _updateMessage(
      index: messageIndex,
      text: fullResponse.trimRight().replaceAll(RegExp(r'\.{3}$'), ''),
    );

  } catch (e) {
    debugPrint('Erro no processamento do stream: $e');
    await _fetchAiResponseFallback(_messages[messageIndex]['text']);
  }
}

void _updateMessage({
  required int index,
  required String text,
  List<dynamic>? references,
  List<dynamic>? suggestions,
}) {
  _messages[index] = {
    'role': 'ai',
    'text': text,
    'references': references ?? _messages[index]['references'] ?? [],
    'suggestions': suggestions ?? _messages[index]['suggestions'] ?? [],
  };
  notifyListeners();
}

Future<void> _fetchAiResponseFallback(String message) async {
  try {
    final response = await apiService.sendMessage(
      message: message,
      flavor: themeProvider.getConfig<String>('appType', defaultValue: ''),
      context: null,
    );

    _updateMessage(
      index: _messages.length - 1,
      text: response.response,
      references: response.references,
      suggestions: response.suggestions,
    );

  } catch (fallbackError, stackTrace) {
    debugPrint('Erro no fallback: $fallbackError');
    debugPrint(stackTrace.toString());

    _updateMessage(
      index: _messages.length - 1,
      text: 'Erro ao processar resposta. Tente novamente mais tarde.',
    );
  }
}

  Future<void> shareResponse(Map<String, dynamic> message) async {
    if (message['text'] == null || message['text'].toString().isEmpty) return;

    try {
      String textToShare = message['text'].toString();

      // Adicionar referências se disponíveis
      if (message['references'] != null) {
        textToShare += '\n\nReferências:';
        for (final reference in message['references']) {
          textToShare += '\n${reference.verse}: ${reference.text}';
        }
      }

      await Share.share(textToShare);
    } catch (e) {
      debugPrint('Erro ao compartilhar mensagem: $e');
    }
  }

  Future<void> copyResponseToClipboard(Map<String, dynamic> message) async {
    if (message['text'] == null || message['text'].toString().isEmpty) return;

    try {
      String textToCopy = message['text'].toString();

      // Adicionar referências se disponíveis
      if (message['references'] != null) {
        textToCopy += '\n\nReferências:';
        for (final reference in message['references']) {
          textToCopy += '\n${reference.verse}: ${reference.text}';
        }
      }

      await Clipboard.setData(ClipboardData(text: textToCopy));
    } catch (e) {
      debugPrint('Erro ao copiar mensagem: $e');
    }
  }

  /// Gera um arquivo de áudio a partir do texto da mensagem
  Future<String> generateAudioFromText(String text) async {
    try {
      // Se for MockAiService, usar o método específico dele
      if (apiService is MockAiService) {
        return await (apiService as MockAiService).generateAudioFromText(text);
      }

      // Para outras implementações, lançar exceção (implementação futura)
      throw UnimplementedError(
          'Geração de áudio não implementada para este serviço de API');
    } catch (e) {
      debugPrint('Erro ao gerar áudio: $e');
      rethrow;
    }
  }
}
