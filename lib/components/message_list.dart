import 'package:flutter/material.dart';
import 'package:jesusapp/components/message_bubble.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MessageList extends StatelessWidget {
  final List<Map<String, String>> messages;

  const MessageList({
    super.key,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appType = themeProvider.getConfig<String>('appType', defaultValue: '');
    final isChristian = appType == 'christian';
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isChristian 
              ? [
                  theme.colorScheme.background,
                  theme.colorScheme.background.withOpacity(0.95),
                  theme.colorScheme.background.withOpacity(0.9),
                ]
              : [
                  theme.colorScheme.background,
                  theme.colorScheme.background.withBlue(
                    (theme.colorScheme.background.blue + 10).clamp(0, 255)
                  ),
                ],
        ),
      ),
      child: messages.isEmpty
          ? _buildEmptyState(context, themeProvider)
          : Stack(
              children: [
                if (isChristian) _buildBackgroundPattern(context),
                ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages.reversed.toList()[index];
                    return MessageBubble(message: message);
                  },
                ),
              ],
            ),
    );
  }
  
  Widget _buildBackgroundPattern(BuildContext context) {
    return Opacity(
      opacity: 0.03,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cross_pattern.png'),
            repeat: ImageRepeat.repeat,
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmptyState(BuildContext context, ThemeProvider themeProvider) {
    final theme = Theme.of(context);
    final emptyMessage = themeProvider.getConfig<String>(
      'emptyStateMessage',
      defaultValue: 'Envie uma mensagem para começar'
    );
    final welcomeMessage = themeProvider.getConfig<String>(
      'welcomeMessage',
      defaultValue: ''
    );
    final appType = themeProvider.getConfig<String>('appType', defaultValue: '');
    final isChristian = appType == 'christian';
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isChristian) ...[
            Icon(
              Icons.wb_sunny_outlined,
              size: 64,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
          ] else ...[
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 64,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
          ],
          const SizedBox(height: 16),
          if (welcomeMessage.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                welcomeMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              emptyMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
          ),
          if (isChristian) ...[
            const SizedBox(height: 32),
            _buildBiblicalThemes(context, themeProvider),
          ],
        ],
      ),
    );
  }
  
  Widget _buildBiblicalThemes(BuildContext context, ThemeProvider themeProvider) {
    final theme = Theme.of(context);
    final biblicalThemes = themeProvider.getConfig<List<dynamic>>(
      'biblicalThemes', 
      defaultValue: <String>[]
    ).cast<String>();
    
    if (biblicalThemes.isEmpty) return const SizedBox.shrink();
    
    return Column(
      children: [
        Text(
          'Temas para reflexão:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: biblicalThemes.map((theme) => Chip(
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            label: Text(
              theme,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }
} 