import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatController.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:jesusapp/components/buttons/copy_button.dart';
import 'package:jesusapp/components/buttons/share_button.dart';
import 'package:jesusapp/components/christian_header.dart';
import 'package:share_plus/share_plus.dart';

class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message['role'] == 'user';
    final chatController = Provider.of<ChatController>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final theme = Theme.of(context);
    final copiedMessage = themeProvider.getConfig<String>('copiedMessage',
        defaultValue: 'Resposta copiada para a área de transferência');
    final shareButtonLabel = themeProvider.getConfig<String>('shareButtonLabel',
        defaultValue: 'Compartilhar');
    final copyButtonLabel = themeProvider.getConfig<String>('copyButtonLabel',
        defaultValue: 'Copiar');
    final appType =
        themeProvider.getConfig<String>('appType', defaultValue: '');
    final isChristian = appType == 'christian';

    // Extrair o texto da mensagem
    final messageText = message['text'].toString();

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              (MediaQuery.of(context).size.width < 600 ? 0.75 : 0.6),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser && isChristian) ...[
              ChristianHeader(theme: theme),
            ],
            Text(
              messageText,
              style: TextStyle(
                color: isUser ? Colors.white : theme.colorScheme.onSurface,
                fontSize: 15,
              ),
            ),
            if (!isUser) ...[
              const SizedBox(height: 8),
              Divider(
                color: Colors.grey.withOpacity(0.2),
                height: 1,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: ShareButton(
                            message: message,
                            chatController: chatController,
                            shareButtonLabel: shareButtonLabel,
                            isChristian: isChristian,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: CopyButton(
                            message: message,
                            chatController: chatController,
                            copiedMessage: copiedMessage,
                            copyButtonLabel: copyButtonLabel,
                            isChristian: isChristian,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.secondary,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              try {
                                // Mostrar indicador de carregamento
                                final scaffoldMessenger =
                                    ScaffoldMessenger.of(context);
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Gerando áudio...'),
                                    duration: Duration(milliseconds: 500),
                                  ),
                                );

                                final audioUrl = await chatController
                                    .generateAudioFromText(messageText);

                                // Compartilhar áudio usando share_plus
                                await Share.share(
                                    'Ouça esta mensagem: $audioUrl',
                                    subject: 'Mensagem de áudio compartilhada');
                              } catch (e) {
                                // Mostrar erro
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Erro ao gerar áudio: $e')),
                                );
                              }
                            },
                            child: const Icon(Icons.volume_up, size: 18),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
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
