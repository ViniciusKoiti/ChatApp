import 'package:jesusapp/services/base/base_service.dart';
import 'package:jesusapp/services/interfaces/i_message_service.dart';

class DefaultMessageService extends BaseService implements IMessageService {
  DefaultMessageService(String flavor) : super(flavor);

  @override
  Future<String> processMessage(String message) async {
    logDebug('Processando mensagem: $message');
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simula processamento

    final formattedMessage = formatMessage(message);
    return 'Resposta: $formattedMessage';
  }

  @override
  Future<List<String>> getSuggestedTopics() async {
    return [
      'Geral',
      'Trabalho',
      'Saúde',
      'Educação',
      'Tecnologia',
      'Lazer',
      'Produtividade',
      'Bem-estar',
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
    // Formatação básica da mensagem
    if (!message.endsWith('.')) {
      message += '.';
    }

    // Adiciona emojis relevantes baseados no conteúdo
    if (message.toLowerCase().contains('trabalho')) {
      message += ' 💼';
    } else if (message.toLowerCase().contains('saúde')) {
      message += ' 🏥';
    } else if (message.toLowerCase().contains('educação')) {
      message += ' 📚';
    }

    return message;
  }
}
