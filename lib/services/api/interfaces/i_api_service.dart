import 'package:jesusapp/models/api/chat_response.dart';
import 'package:jesusapp/models/api/prayer_response.dart';
import 'package:jesusapp/models/api/verse_response.dart';
import 'package:jesusapp/models/api/message_context.dart';

/// Interface para comunicação com a API LLM
///
/// Define os métodos para interação com os endpoints da API,
/// incluindo comunicação para chat, versículos bíblicos e orações.
abstract class IApiService {
  /// Envia uma mensagem para a API e retorna a resposta do modelo LLM
  ///
  /// Parâmetros:
  /// - [message]: O texto da mensagem enviada pelo usuário
  /// - [flavor]: O flavor da aplicação (ex: 'christian', 'default')
  /// - [context]: Contexto opcional da conversa, incluindo histórico e preferências
  ///
  /// Retorna um objeto [ChatResponse] com a resposta do modelo LLM
  Future<ChatResponse> sendMessage({
    required String message,
    required String flavor,
    MessageContext? context,
  });

  /// Obtém versículos bíblicos aleatórios com base em um tema opcional
  ///
  /// Parâmetros:
  /// - [theme]: Tema ou categoria opcional para filtrar os versículos
  /// - [version]: Versão da Bíblia (padrão: 'NVI')
  ///
  /// Retorna um objeto [VerseResponse] contendo os versículos
  Future<VerseResponse> getRandomVerses({
    String? theme,
    String version = 'NVI',
  });

  /// Obtém uma oração diária com base em uma categoria opcional
  ///
  /// Parâmetros:
  /// - [category]: Categoria da oração (ex: 'morning', 'gratitude')
  /// - [personalized]: Indica se a oração deve ser personalizada
  ///
  /// Retorna um objeto [PrayerResponse] contendo a oração
  Future<PrayerResponse> getDailyPrayer({
    String? category,
    bool personalized = false,
  });

  /// Obtém a lista de flavors disponíveis na API
  ///
  /// Retorna uma lista de strings com os flavors suportados
  Future<List<String>> getAvailableFlavors();

  /// Verifica a saúde da API
  ///
  /// Retorna um mapa com informações sobre o estado da API
  Future<Map<String, dynamic>> checkApiHealth();
}
