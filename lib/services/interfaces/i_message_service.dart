/// Interface para serviços de mensagens
abstract class IMessageService {
  Future<String> processMessage(String message);

  Future<List<String>> getSuggestedTopics();

  Future<bool> isMessageAppropriate(String message);

  String formatMessage(String message);
}
