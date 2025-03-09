import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:jesusapp/service/mockAiService.dart';
import 'package:jesusapp/services/api/interfaces/i_api_service.dart';

class ChatController extends ChangeNotifier {
  final IApiService apiService;
  final ThemeProvider themeProvider;

  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  ChatController({
    required this.apiService,
    required this.themeProvider,
  }) {
    _initializeMessages();
  }

  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> _initializeMessages() async {
    if (_isLoading) return;
    _isLoading = true;

    // Verificar se estamos no tema cristão
    final appType =
        themeProvider.getConfig<String>('appType', defaultValue: '') ?? '';
    final isChristian = appType == 'christian';

    if (isChristian) {
      // Adicionar mensagem de boas-vindas para o tema cristão
      _messages.add({
        'role': 'ai',
        'text':
            'Bem-vindo ao Assistente Cristão! Estou aqui para ajudar em sua jornada de fé. Você pode me perguntar sobre temas bíblicos, reflexões espirituais ou buscar palavras de encorajamento. Como posso auxiliar em sua caminhada cristã hoje?'
      });

      // Adicionar sugestão de versículo do dia
      final verseOfDay = _getRandomVerse();
      await Future.delayed(const Duration(milliseconds: 500));
      _messages
          .add({'role': 'ai', 'text': '📖 *Versículo do dia:* $verseOfDay'});

      notifyListeners();
    }
  }

  String _getRandomVerse() {
    final verses = [
      '"Porque Deus amou o mundo de tal maneira que deu o seu Filho unigênito, para que todo aquele que nele crê não pereça, mas tenha a vida eterna." - João 3:16',
      '"O Senhor é o meu pastor, nada me faltará." - Salmos 23:1',
      '"Tudo posso naquele que me fortalece." - Filipenses 4:13',
      '"E conhecereis a verdade, e a verdade vos libertará." - João 8:32',
      '"Não temas, porque eu sou contigo; não te assombres, porque eu sou teu Deus; eu te fortaleço, e te ajudo, e te sustento com a destra da minha justiça." - Isaías 41:10',
      '"Confie no Senhor de todo o seu coração e não se apoie em seu próprio entendimento." - Provérbios 3:5',
      '"Busquem, pois, em primeiro lugar o Reino de Deus e a sua justiça, e todas essas coisas lhes serão acrescentadas." - Mateus 6:33',
      '"Eu sou o caminho, a verdade e a vida. Ninguém vem ao Pai, a não ser por mim." - João 14:6',
      '"Porque sou eu que conheço os planos que tenho para vocês, diz o Senhor, planos de fazê-los prosperar e não de causar dano, planos de dar a vocês esperança e um futuro." - Jeremias 29:11',
      '"Alegrem-se sempre no Senhor. Novamente direi: alegrem-se!" - Filipenses 4:4'
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

      // Obter o flavor atual
      final flavor =
          themeProvider.getConfig<String>('appType', defaultValue: '');

      // Usar o método sendMessage da interface IApiService
      final response = await apiService.sendMessage(
        message: message,
        flavor: flavor,
        context: null, // Ou adicionar contexto se necessário
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
