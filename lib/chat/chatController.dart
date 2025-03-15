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

    // Verificar se a mensagem é uma busca por versículo
    if (message.toLowerCase().contains('versículo') ||
        message.toLowerCase().contains('verso') ||
        message.toLowerCase().contains('passagem')) {
      try {
        // Tentar encontrar versículos com base na consulta
        final verses = await verseService.searchVerses(message);

        if (verses.isNotEmpty) {
          // Formatar a resposta com os versículos encontrados
          String response = 'Encontrei estes versículos para você:\n\n';

          for (var verse in verses.take(3)) {
            // Limitar a 3 resultados
            response += '📖 "${verse.text}" - ${verse.reference}\n\n';
          }

          _messages.add({
            'role': 'ai',
            'text': response.trim(),
          });

          _isLoading = false;
          notifyListeners();
          return;
        }
      } catch (e) {
        debugPrint('Erro ao buscar versículos: $e');
        // Continuar com a resposta normal do AI se a busca falhar
      }
    }

    // Obter o flavor atual
    final flavor =
        themeProvider.getConfig<String>('appType', defaultValue: '');
    debugPrint('sendMessage: $message, $flavor');
    
    // Adicionar uma mensagem vazia do AI que será atualizada com o stream
    final messageIndex = _messages.length;
    _messages.add({
      'role': 'ai',
      'text': '',
      'references': [],
      'suggestions': [],
    });
    notifyListeners();
    
    // Iniciar o stream de resposta
    String fullResponse = '';
    
    try {
      debugPrint('Iniciando stream de resposta...');
      final stream = apiService.sendMessageStream(
        message: message,
        flavor: flavor,
        context: null,
      );

      
      
      await for (final chunk in stream) {
        debugPrint('Chunk recebido: ${chunk.length} caracteres');
        print(chunk);
        // Adicionar o novo chunk à resposta completa
        fullResponse += chunk;
        
        // CRÍTICO: Criar um NOVO objeto Map em vez de modificar o existente
        // Isso garante que o Flutter detecte a mudança e reconstrua o widget
        _messages[messageIndex] = {
          'role': 'ai',
          'text': fullResponse,
          'references': _messages[messageIndex]['references'] ?? [],
          'suggestions': _messages[messageIndex]['suggestions'] ?? [],
        };
        
        // Notificar IMEDIATAMENTE após cada chunk para atualização da UI
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro no stream: $e');
      // Em caso de erro no stream, tenta o método não-streaming como fallback
      try {
        final response = await apiService.sendMessage(
          message: message,
          flavor: flavor,
          context: null,
        );
        
        _messages[messageIndex] = {
          'role': 'ai',
          'text': response.response,
          'references': response.references,
          'suggestions': response.suggestions,
        };
      } catch (fallbackError) {
        debugPrint('Erro no fallback: $fallbackError');
        _messages[messageIndex] = {
          'role': 'ai',
          'text': 'Desculpe, houve um erro ao processar sua mensagem. Por favor, tente novamente.',
          'references': [],
          'suggestions': [],
        };
      }
    }
  } catch (e) {
    // Fallback para serviço legado ou tratamento de erro
    if (apiService is MockAiService) {
      final legacyResponse =
          await (apiService as MockAiService).sendMessageLegacy(message);
      _messages.add({'role': 'ai', 'text': legacyResponse});
    } else {
      _messages.add({
        'role': 'ai',
        'text':
            'Desculpe, houve um erro ao processar sua mensagem. Por favor, tente novamente.'
      });
    }
  } finally {
    _isLoading = false;
    notifyListeners();
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
