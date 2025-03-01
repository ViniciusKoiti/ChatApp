import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:jesusapp/theme/theme_provider.dart';

abstract class IApiService {
  Future<String> getResponse(String message);
}

class ChatController extends ChangeNotifier {
  final IApiService apiService;
  final ThemeProvider? themeProvider;
  final List<Map<String, String>> _messages = [];
  bool _initialized = false;

  ChatController({required this.apiService, this.themeProvider}) {
    _initializeMessages();
  }

  List<Map<String, String>> get messages => List.unmodifiable(_messages);

  Future<void> _initializeMessages() async {
    if (_initialized) return;
    _initialized = true;
    
    // Verificar se estamos no tema cristão
    final appType = themeProvider?.getConfig<String>('appType', defaultValue: '') ?? '';
    final isChristian = appType == 'christian';
    
    if (isChristian) {
      // Adicionar mensagem de boas-vindas para o tema cristão
      _messages.add({
        'role': 'ai', 
        'text': 'Bem-vindo ao Assistente Cristão! Estou aqui para ajudar em sua jornada de fé. Você pode me perguntar sobre temas bíblicos, reflexões espirituais ou buscar palavras de encorajamento. Como posso auxiliar em sua caminhada cristã hoje?'
      });
      
      // Adicionar sugestão de versículo do dia
      final verseOfDay = _getRandomVerse();
      await Future.delayed(const Duration(milliseconds: 500));
      _messages.add({
        'role': 'ai',
        'text': '📖 *Versículo do dia:* $verseOfDay'
      });
      
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
