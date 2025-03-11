import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:jesusapp/service/mockAiService.dart';
import 'package:jesusapp/services/api/interfaces/i_api_service.dart';
import 'package:jesusapp/services/api/interfaces/i_verse_service.dart';
import 'package:provider/provider.dart';

class ChatController extends ChangeNotifier {
  final IApiService apiService;
  final ThemeProvider themeProvider;
  late final IVerseService verseService;
  final BuildContext context;

  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  ChatController({
    required this.apiService,
    required this.themeProvider,
    required this.context,
  }) {
    // Obter o verseService do Provider
    verseService = Provider.of<IVerseService>(context, listen: false);
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
          // Usar o verseService para obter um versículo aleatório
          final verse = await verseService.getRandomVerse();
          _messages.add({
            'role': 'ai',
            'text':
                '📖 *Versículo do dia:* "${verse.text}" - ${verse.reference}'
          });
        } catch (e) {
          debugPrint('Erro ao obter versículo aleatório: $e');
          // Fallback para versículo estático em caso de erro
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

  // Método de fallback em caso de falha na API
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

      final response = await apiService.sendMessage(
        message: message,
        flavor: flavor,
        context: null,
      );

      _messages.add({
        'role': 'ai',
        'text': response.response,
        'references': response.references,
        'suggestions': response.suggestions,
      });
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
