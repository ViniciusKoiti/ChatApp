import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatScreen.dart';
import 'package:jesusapp/screens/prayers_screen.dart';
import 'package:jesusapp/screens/verses_screen.dart';
import 'package:jesusapp/services/verse_service.dart';
import 'package:jesusapp/services/prayer_service.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ChristianHomeScreen extends StatelessWidget {
  const ChristianHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final appName = themeProvider.getConfig<String>('appName', defaultValue: 'Assistente Cristão');
    
    // Obter um versículo aleatório
    final verse = VerseService.getRandomVerse();
    // Obter uma oração aleatória
    final prayer = PrayerService.getRandomPrayer();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wb_sunny_outlined,
              size: 20,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Text(appName),
          ],
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Sobre o aplicativo',
            onPressed: () {
              _showAboutDialog(context, themeProvider);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho com saudação
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: theme.colorScheme.primary.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bem-vindo(a)!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Que a paz de Cristo esteja com você hoje.',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '"${verse.text}"',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          verse.reference,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Menu de opções
              Text(
                'O que você gostaria de fazer hoje?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Opção: Conversar com o assistente
              _buildMenuOption(
                context,
                icon: Icons.chat_bubble_outline,
                title: 'Conversar com o Assistente',
                description: 'Tire suas dúvidas sobre fé, espiritualidade e vida cristã',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 12),
              
              // Opção: Versículos bíblicos
              _buildMenuOption(
                context,
                icon: Icons.menu_book_outlined,
                title: 'Versículos Bíblicos',
                description: 'Explore versículos inspiradores da Palavra de Deus',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VersesScreen(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 12),
              
              // Opção: Orações diárias
              _buildMenuOption(
                context,
                icon: Icons.favorite_outline,
                title: 'Orações Diárias',
                description: 'Encontre orações para diferentes momentos e necessidades',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrayersScreen(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // Oração do dia
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Oração do Dia',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        prayer.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        prayer.text.length > 150 
                            ? '${prayer.text.substring(0, 150)}...' 
                            : prayer.text,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrayersScreen(),
                              ),
                            );
                          },
                          child: const Text('Ver mais orações'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAboutDialog(BuildContext context, ThemeProvider themeProvider) {
    final appName = themeProvider.getConfig<String>('appName', defaultValue: 'Assistente Cristão');
    final appDescription = themeProvider.getConfig<String>(
      'appDescription', 
      defaultValue: 'Um assistente virtual para conversas sobre fé e espiritualidade'
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.wb_sunny_outlined,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(appName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appDescription),
            const SizedBox(height: 16),
            const Text(
              '"Pois onde dois ou três estiverem reunidos em meu nome, aí estou eu no meio deles." - Mateus 18:20',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 13,
              ),
            ),
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