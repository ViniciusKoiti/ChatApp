import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatController.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final Map<String, String> message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message['role'] == 'user';
    final chatController = Provider.of<ChatController>(context, listen: false);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['text']!,
              style: TextStyle(color: isUser ? Colors.white : Colors.black),
            ),
            // Adicionar botões de ação apenas para mensagens da IA
            if (!isUser) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botão de compartilhamento
                  InkWell(
                    onTap: () => chatController.shareResponse(message),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.share,
                        size: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Botão de cópia
                  InkWell(
                    onTap: () {
                      chatController.copyResponseToClipboard(message);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Resposta copiada para a área de transferência'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.copy,
                        size: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
} 