import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatController.dart';
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
        context: context,
      ),
      child: _ChatScreenContent(),
    );
  }
}

class _ChatScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ChatController>(context);

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
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      return _MessageWidget(
                        message: message,
                        controller: controller,
                      );
                    },
                  ),
          ),
          // Outras partes da interface (entrada de texto, botões, etc.)
        ],
      ),
    );
  }
}

class _MessageWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final ChatController controller;

  const _MessageWidget({
    required this.message,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message['role'] == 'user';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isUser ? Theme.of(context).primaryColor : Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message['text'] ?? '',
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black,
                ),
              ),
              if (!isUser) ...[
                const SizedBox(height: 8.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      onPressed: () =>
                          controller.copyResponseToClipboard(message),
                      tooltip: 'Copiar',
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, size: 18),
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
