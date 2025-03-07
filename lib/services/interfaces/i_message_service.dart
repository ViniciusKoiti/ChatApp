/// Interface para serviços de mensagens
abstract class IMessageService {
  /// Processa uma mensagem e retorna uma resposta
  Future<String> processMessage(String message);

  /// Retorna uma lista de tópicos sugeridos
  Future<List<String>> getSuggestedTopics();

  /// Verifica se uma mensagem é apropriada para o flavor atual
  Future<bool> isMessageAppropriate(String message);

  /// Formata uma mensagem de acordo com o flavor
  String formatMessage(String message);
}
