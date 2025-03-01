import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatController.dart';
import 'package:jesusapp/theme/theme_provider.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final theme = Theme.of(context);
    final copiedMessage = themeProvider.getConfig<String>(
      'copiedMessage',
      defaultValue: 'Resposta copiada para a área de transferência'
    );
    final shareButtonLabel = themeProvider.getConfig<String>(
      'shareButtonLabel',
      defaultValue: 'Compartilhar'
    );
    final copyButtonLabel = themeProvider.getConfig<String>(
      'copyButtonLabel',
      defaultValue: 'Copiar'
    );
    final appType = themeProvider.getConfig<String>('appType', defaultValue: '');
    final isChristian = appType == 'christian';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
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
              _buildChristianHeader(theme),
            ],
            Text(
              message['text']!,
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
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: Tooltip(
                      message: shareButtonLabel,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => chatController.shareResponse(message),
                        child: Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isChristian ? Icons.share : Icons.share_rounded,
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                              if (isChristian) ...[
                                const SizedBox(width: 4),
                                Text(
                                  shareButtonLabel,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: Tooltip(
                      message: 'Copiar para área de transferência',
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          chatController.copyResponseToClipboard(message);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(copiedMessage),
                              duration: const Duration(seconds: 2),
                              backgroundColor: theme.colorScheme.primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isChristian ? Icons.content_copy : Icons.content_copy_rounded,
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                              if (isChristian) ...[
                                const SizedBox(width: 4),
                                Text(
                                  copyButtonLabel,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
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
  
  Widget _buildChristianHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 16,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(width: 4),
            Text(
              'Reflexão',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
} 