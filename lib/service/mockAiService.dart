import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:jesusapp/models/api/chat_response.dart';
import 'package:jesusapp/models/api/verse_response.dart';
import 'package:jesusapp/models/api/prayer_response.dart';
import 'package:jesusapp/models/api/message_context.dart';
import 'package:jesusapp/models/api/bible_reference.dart';
import 'package:jesusapp/services/api/api_service.dart';
import 'package:jesusapp/services/api/api_exceptions.dart';
import 'package:jesusapp/services/api/interfaces/i_api_service.dart';
import 'package:jesusapp/theme/app_flavor.dart';

/// Serviço que simula a interação com uma API de IA
class MockAiService implements IApiService {
  /// Lista de mensagens armazenadas
  final List<Map<String, dynamic>> _messages = [];

  /// Serviço de API real
  late final ApiService _apiService;

  /// Flavor atual do aplicativo
  String _currentFlavor = AppFlavor.defaultFlavor;

  /// Flag para usar a API real (caso contrário usar dados mockados)
  final bool _useRealApi;

  /// Flag para modo offline
  bool _offlineMode = false;

  /// Construtor
  MockAiService({bool useRealApi = true, String? initialFlavor})
      : _useRealApi = useRealApi {
    _currentFlavor = initialFlavor ?? AppFlavor.defaultFlavor;
    if (_useRealApi) {
      _apiService = ApiService(_currentFlavor);
      _checkApiHealth();
    }
  }

  /// Verifica a saúde da API
  Future<void> _checkApiHealth() async {
    try {
      if (_useRealApi) {
        await checkApiHealth();
        _offlineMode = false;
      }
    } catch (e) {
      _offlineMode = true;
      debugPrint('API está offline: $e');
    }
  }

  /// Define o flavor atual
  void setFlavor(String flavor) {
    if (_currentFlavor != flavor) {
      _currentFlavor = flavor;
      if (_useRealApi) {
        _apiService = ApiService(flavor);
        _checkApiHealth();
      }
    }
  }

  // Método legado (mantido para compatibilidade com código atual)
  /// Envia uma mensagem e retorna a resposta como string
  Future<String> sendMessageLegacy(String message) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (_useRealApi && !_offlineMode) {
      try {
        // Criar o contexto com mensagens anteriores
        final context = MessageContext(
          previousMessages: _messages
              .map((m) => {
                    'role': m['isUser'] ? 'user' : 'assistant',
                    'content': m['text'] as String,
                  })
              .toList(),
          userPreferences: UserPreferences(),
        );

        // Enviar mensagem para a API
        final response = await sendMessage(
          message: message,
          flavor: _currentFlavor,
          context: context,
        );

        // Armazenar mensagens
        _storeMessage(message, true);
        _storeMessage(response.response, false);

        return response.response;
      } catch (e) {
        // Se ocorrer erro, tentar novamente ou cair no fallback
        if (e is ConnectionException || e is TimeoutException) {
          _offlineMode = true;
          return _getMockResponse(message);
        }
        return 'Erro ao processar mensagem: ${e.toString()}';
      }
    } else {
      // Usar resposta mockada em modo offline
      final mockResponse = _getMockResponse(message);

      // Armazenar mensagens
      _storeMessage(message, true);
      _storeMessage(mockResponse, false);

      return mockResponse;
    }
  }

  /// Armazena uma mensagem no histórico
  void _storeMessage(String text, bool isUser) {
    _messages.add({
      'text': text,
      'isUser': isUser,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Obtém todas as mensagens armazenadas
  List<Map<String, dynamic>> getMessages() {
    return List.from(_messages);
  }

  /// Limpa todas as mensagens armazenadas
  void clearMessages() {
    _messages.clear();
  }

  /// Obtém uma resposta mockada
  String _getMockResponse(String message) {
    final isChristian = _currentFlavor == AppFlavor.christian;
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('olá') ||
        lowerMessage.contains('oi') ||
        lowerMessage.contains('bom dia')) {
      return isChristian
          ? 'Olá! Que a paz do Senhor esteja com você hoje. Como posso ajudá-lo em sua jornada espiritual?'
          : 'Olá! Como posso ajudar você hoje?';
    } else if (lowerMessage.contains('bíblia') ||
        lowerMessage.contains('jesus') ||
        lowerMessage.contains('deus')) {
      return isChristian
          ? 'A Bíblia nos ensina que Deus amou o mundo de tal maneira que deu o seu Filho unigênito, para que todo aquele que nele crê não pereça, mas tenha a vida eterna. (João 3:16)'
          : 'A Bíblia é um importante livro religioso para o cristianismo e outras religiões. Posso ajudar com informações sobre ela.';
    } else if (lowerMessage.contains('oração') ||
        lowerMessage.contains('rezar')) {
      return isChristian
          ? 'A oração é nossa forma de comunicação com Deus. Jesus nos ensinou a orar no Pai Nosso, um exemplo perfeito de como devemos nos dirigir a Deus em oração.'
          : 'A oração é uma prática comum em muitas religiões. É uma forma de comunicação espiritual.';
    } else {
      return isChristian
          ? 'Obrigado por sua mensagem. Estou aqui para ajudar em sua jornada de fé. Há algo específico sobre espiritualidade cristã que gostaria de saber?'
          : 'Obrigado por sua mensagem. Como posso ajudar você hoje?';
    }
  }

  /// Gera um arquivo de áudio a partir de texto
  Future<String> generateAudioFromText(String text) async {
    // Simula a geração de áudio
    await Future.delayed(const Duration(milliseconds: 500));

    // Cria um nome de arquivo baseado no texto
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'audio_$timestamp.mp3';

    try {
      // Em um caso real, aqui chamaríamos uma API de TTS
      // Para mock, vamos apenas criar um arquivo vazio
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsString('Mock audio content for: $text');

      return filePath;
    } catch (e) {
      debugPrint('Erro ao gerar áudio: $e');
      return '';
    }
  }

  // Implementações da interface IApiService
  @override
  Future<ChatResponse> sendMessage({
    required String message,
    required String flavor,
    MessageContext? context,
  }) async {
    if (_useRealApi && !_offlineMode) {
      try {
        return await _apiService.sendMessage(
          message: message,
          flavor: flavor,
          context: context,
        );
      } catch (e) {
        // Se ocorrer erro, tenta modo offline
        if (e is ConnectionException || e is TimeoutException) {
          _offlineMode = true;
        } else {
          rethrow;
        }
      }
    }

    // Fallback para modo offline ou erro
    final mockResponse = _getMockResponse(message);

    // Cria um objeto ChatResponse com a resposta mockada
    return ChatResponse(
      response: mockResponse,
      suggestions: _getSuggestionsByFlavor(flavor),
      references: _getReferencesByFlavor(flavor, message),
    );
  }

  /// Obtém sugestões baseadas no flavor
  List<String>? _getSuggestionsByFlavor(String flavor) {
    if (flavor == AppFlavor.christian) {
      return [
        'Como posso orar melhor?',
        'Qual o significado da fé?',
        'Versículos sobre esperança',
      ];
    } else {
      return [
        'Como você pode me ajudar?',
        'O que é possível fazer neste app?',
        'Dicas para produtividade',
      ];
    }
  }

  /// Obtém referências bíblicas baseadas no flavor e mensagem
  List<BibleReference>? _getReferencesByFlavor(String flavor, String message) {
    if (flavor == AppFlavor.christian) {
      final lowerMessage = message.toLowerCase();

      if (lowerMessage.contains('amor')) {
        return [
          BibleReference(
              verse: '1 Coríntios 13:4-7',
              text: 'O amor é paciente, o amor é bondoso...'),
          BibleReference(
              verse: 'João 3:16',
              text: 'Porque Deus amou o mundo de tal maneira...'),
        ];
      } else if (lowerMessage.contains('fé')) {
        return [
          BibleReference(
              verse: 'Hebreus 11:1',
              text: 'Ora, a fé é a certeza daquilo que esperamos...'),
        ];
      }
    }

    return null;
  }

  @override
  Future<VerseResponse> getRandomVerses({
    String? theme,
    String version = 'NVI',
  }) async {
    if (_useRealApi && !_offlineMode) {
      try {
        return await _apiService.getRandomVerses(
          theme: theme,
          version: version,
        );
      } catch (e) {
        // Entra em modo offline em caso de erro de conexão
        if (e is ConnectionException || e is TimeoutException) {
          _offlineMode = true;
        } else {
          rethrow;
        }
      }
    }

    // Fallback para modo offline ou erro
    return _getMockVerses(theme);
  }

  /// Obtém versículos mockados
  VerseResponse _getMockVerses(String? theme) {
    final verses = <BibleReference>[];

    if (theme?.toLowerCase() == 'amor') {
      verses.add(BibleReference(
          verse: '1 Coríntios 13:4-7',
          text:
              'O amor é paciente, o amor é bondoso. Não inveja, não se vangloria, não se orgulha. Não maltrata, não procura seus interesses, não se ira facilmente, não guarda rancor. O amor não se alegra com a injustiça, mas se alegra com a verdade. Tudo sofre, tudo crê, tudo espera, tudo suporta.'));
      verses.add(BibleReference(
          verse: 'João 3:16',
          text:
              'Porque Deus amou o mundo de tal maneira que deu o seu Filho unigênito, para que todo aquele que nele crê não pereça, mas tenha a vida eterna.'));
    } else if (theme?.toLowerCase() == 'fé') {
      verses.add(BibleReference(
          verse: 'Hebreus 11:1',
          text:
              'Ora, a fé é a certeza daquilo que esperamos e a prova das coisas que não vemos.'));
      verses.add(BibleReference(
          verse: 'Mateus 17:20',
          text:
              'Se tiverdes fé do tamanho de um grão de mostarda, direis a este monte: Passa daqui para acolá, e ele passará. Nada vos será impossível.'));
    } else {
      verses.add(BibleReference(
          verse: 'Salmos 23:1-3',
          text:
              'O Senhor é o meu pastor, nada me faltará. Deitar-me faz em verdes pastos, guia-me mansamente a águas tranquilas. Refrigera a minha alma; guia-me pelas veredas da justiça, por amor do seu nome.'));
      verses.add(BibleReference(
          verse: 'Filipenses 4:13',
          text: 'Posso todas as coisas naquele que me fortalece.'));
    }

    return VerseResponse(verses: verses, theme: theme);
  }

  @override
  Future<PrayerResponse> getDailyPrayer({
    String? category,
    bool personalized = false,
  }) async {
    if (_useRealApi && !_offlineMode) {
      try {
        return await _apiService.getDailyPrayer(
          category: category,
          personalized: personalized,
        );
      } catch (e) {
        if (e is ConnectionException || e is TimeoutException) {
          _offlineMode = true;
        } else {
          rethrow;
        }
      }
    }

    // Fallback para modo offline ou erro
    return _getMockPrayer(category);
  }

  /// Obtém uma oração mockada
  PrayerResponse _getMockPrayer(String? category) {
    String prayer;
    String actualCategory;

    if (category?.toLowerCase() == 'manhã') {
      prayer =
          'Senhor, agradeço pelo novo dia que se inicia. Abençoe meus passos e minhas decisões. Que eu possa levar Tua luz para todos que encontrar hoje.';
      actualCategory = 'manhã';
    } else if (category?.toLowerCase() == 'noite') {
      prayer =
          'Pai Celestial, ao fim deste dia, agradeço por Tua proteção e cuidado. Perdoa minhas falhas e concede-me um descanso tranquilo para renovar minhas forças.';
      actualCategory = 'noite';
    } else if (category?.toLowerCase() == 'gratidão') {
      prayer =
          'Meu Deus, meu coração transborda de gratidão por todas as bênçãos que tens derramado em minha vida. Obrigado pelo Teu amor incondicional e fidelidade.';
      actualCategory = 'gratidão';
    } else {
      prayer =
          'Senhor, em Tuas mãos entrego minha vida, meus sonhos, minhas preocupações. Guia-me pelo caminho da sabedoria e da verdade, para que em tudo eu possa honrar Teu nome.';
      actualCategory = 'geral';
    }

    return PrayerResponse(
      prayer: prayer,
      category: actualCategory,
      references: [
        BibleReference(
            verse: 'Filipenses 4:6-7',
            text:
                'Não andeis ansiosos por coisa alguma; antes em tudo sejam os vossos pedidos conhecidos diante de Deus pela oração e súplica com ações de graças; e a paz de Deus, que excede todo entendimento, guardará os vossos corações e os vossos pensamentos em Cristo Jesus.'),
      ],
    );
  }

  @override
  Future<List<String>> getAvailableFlavors() async {
    if (_useRealApi && !_offlineMode) {
      try {
        return await _apiService.getAvailableFlavors();
      } catch (e) {
        if (e is ConnectionException || e is TimeoutException) {
          _offlineMode = true;
        } else {
          rethrow;
        }
      }
    }

    // Fallback para modo offline ou erro
    return [AppFlavor.christian, AppFlavor.defaultFlavor];
  }

  @override
  Future<Map<String, dynamic>> checkApiHealth() async {
    if (_useRealApi) {
      try {
        final result = await _apiService.checkApiHealth();
        _offlineMode = false;
        return result;
      } catch (e) {
        _offlineMode = true;
        throw ApiException('API indisponível: $e');
      }
    }

    // Fallback para modo offline ou quando API não é usada
    return {
      'status': 'mock',
      'version': '1.0.0',
      'message': 'Usando modo offline/mock',
    };
  }
}
