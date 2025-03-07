import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatController.dart';
import 'package:provider/provider.dart';
import 'package:jesusapp/components/message_list.dart';
import 'package:jesusapp/components/message_input.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:jesusapp/theme/theme_selector_screen.dart';
import 'package:jesusapp/components/verse_card.dart';
import 'package:jesusapp/services/verse_service.dart';
import 'package:jesusapp/screens/prayers_screen.dart';
import 'package:jesusapp/screens/verses_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ChatController>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final appName = themeProvider.getConfig<String>('appName',
        defaultValue: 'Assistente Virtual');
    final appType =
        themeProvider.getConfig<String>('appType', defaultValue: '');
    final isChristian = appType == 'christian';

    // Obter um versículo aleatório
    final verse = VerseService.getRandomVerse();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isChristian) ...[
              Icon(
                Icons.wb_sunny_outlined,
                size: 20,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
            ],
            Text(appName),
          ],
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        actions: [
          if (isChristian) ...[
            IconButton(
              icon: const Icon(Icons.menu_book_outlined),
              tooltip: 'Versículos Bíblicos',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VersesScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite_outline),
              tooltip: 'Orações Diárias',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrayersScreen(),
                  ),
                );
              },
            ),
          ],
          if (!isChristian) ...[
            IconButton(
              icon: const Icon(Icons.color_lens_outlined),
              tooltip: 'Mudar tema',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ThemeSelectorScreen(),
                  ),
                );
              },
            ),
          ],
          IconButton(
            icon: Icon(isChristian ? Icons.info_outline : Icons.info),
            tooltip: 'Sobre o aplicativo',
            onPressed: () {
              _showAboutDialog(context, themeProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Mostrar o cartão de versículo apenas se for o tema cristão
          if (isChristian) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: VerseCard(
                verse: verse.text,
                reference: verse.reference,
              ),
            ),
          ],
          Expanded(
            child: MessageList(messages: chatController.messages),
          ),
          MessageInput(
            onSendMessage: chatController.sendMessage,
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, ThemeProvider themeProvider) {
    final appName = themeProvider.getConfig<String>('appName',
        defaultValue: 'Assistente Virtual');
    final appDescription = themeProvider.getConfig<String>('appDescription',
        defaultValue: 'Um assistente virtual para conversas');
    final appType =
        themeProvider.getConfig<String>('appType', defaultValue: '');
    final isChristian = appType == 'christian';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            if (isChristian) ...[
              Icon(
                Icons.wb_sunny_outlined,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
            ],
            Text(appName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appDescription),
            const SizedBox(height: 16),
            if (isChristian) ...[
              const Text(
                '"Pois onde dois ou três estiverem reunidos em meu nome, aí estou eu no meio deles." - Mateus 18:20',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
