import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatController.dart';
import 'package:jesusapp/components/message_input.dart';
import 'package:provider/provider.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:jesusapp/services/api/interfaces/i_api_service.dart';
import 'package:jesusapp/services/api/interfaces/i_verse_service.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obter as dependências necessárias
    final themeProvider = Provider.of<ThemeProvider>(context);
    final apiService = Provider.of<IApiService>(context);
    final verseService = Provider.of<IVerseService>(context, listen: false);

    return ChangeNotifierProvider(
      create: (context) => ChatController(
        apiService: apiService,
        themeProvider: themeProvider,
        verseService: verseService,
      ),
      child: _ChatScreenContent(),
    );
  }
}

class _ChatScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Aqui usamos Consumer apenas para ouvir isLoading e messages.length
    return Consumer<ChatController>(
      builder: (context, controller, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Assistente Cristão'),
          ),
          body: Column(
            children: [
              Expanded(
                child: controller.isLoading && controller.messages.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: controller.messages.length,
                        padding: const EdgeInsets.all(16),
                        reverse: true, // Mostra mensagens mais recentes embaixo
                        itemBuilder: (context, index) {
                          final messageIndex = controller.messages.length - 1 - index;
                          // Usamos Consumer para cada mensagem individual
                          return _MessageConsumerWidget(messageIndex: messageIndex);
                        },
                      ),
              ),
              MessageInput(
                onSendMessage: (text) {
                  controller.sendMessage(text);
                },
              ),
            ],
          ),
        );
      }
    );
  }
}

// Widget que usa Consumer especificamente para uma mensagem
class _MessageConsumerWidget extends StatelessWidget {
  final int messageIndex;

  const _MessageConsumerWidget({
    required this.messageIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Consumer que observa APENAS as mudanças na mensagem específica
    return Consumer<ChatController>(
      builder: (context, controller, _) {
        final message = controller.messages[messageIndex];
        
        // Usar uma chave única para garantir reconstrução quando o conteúdo mudar
        return _MessageWidget(
          key: ValueKey('message_${messageIndex}_${message['text'].hashCode}'),
          message: message,
          controller: controller,
        );
      },
    );
  }
}

class _MessageWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final ChatController controller;

  const _MessageWidget({
    Key? key,
    required this.message,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = message['role'] == 'user';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isUser
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message['text'] ?? '',
                style: TextStyle(
                  color: isUser
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (!isUser) ...[
                const SizedBox(height: 8.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.copy,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () =>
                          controller.copyResponseToClipboard(message),
                      tooltip: 'Copiar',
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.share,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => controller.shareResponse(message),
                      tooltip: 'Compartilhar',
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}