import 'package:jesusapp/services/base/base_service.dart';
import 'package:jesusapp/services/interfaces/i_message_service.dart';

class ChristianMessageService extends BaseService implements IMessageService {
  ChristianMessageService(String flavor) : super(flavor);

  @override
  Future<String> processMessage(String message) async {
    logDebug('Processando mensagem: $message');
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simula processamento

    final formattedMessage = formatMessage(message);
    return 'Resposta cristã: $formattedMessage\nQue a paz de Cristo esteja com você!';
  }

  @override
  Future<List<String>> getSuggestedTopics() async {
    return [
      'Fé',
      'Oração',
      'Estudos Bíblicos',
      'Testemunhos',
      'Vida Cristã',
      'Adoração',
      'Família Cristã',
      'Evangelismo',
    ];
  }

  @override
  Future<bool> isMessageAppropriate(String message) async {
    // Implementação básica - poderia ser mais sofisticada com análise de conteúdo
    final lowercaseMessage = message.toLowerCase();
    final inappropriateWords = [
      'palavrão',
      'xingamento',
      // Adicione outras palavras inadequadas
    ];

    return !inappropriateWords.any((word) => lowercaseMessage.contains(word));
  }

  @override
  String formatMessage(String message) {
    // Adiciona elementos cristãos à mensagem
    if (!message.endsWith('.')) {
      message += '.';
    }

    // Adiciona referências bíblicas comuns se apropriado
    if (message.toLowerCase().contains('paz')) {
      message += ' (João 14:27)';
    } else if (message.toLowerCase().contains('amor')) {
      message += ' (1 Coríntios 13:13)';
    } else if (message.toLowerCase().contains('fé')) {
      message += ' (Hebreus 11:1)';
    }

    return message;
  }
}
