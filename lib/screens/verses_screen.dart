import 'package:flutter/material.dart';
import 'package:jesusapp/components/verse_card.dart';
import 'package:jesusapp/services/verse_service.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class VersesScreen extends StatelessWidget {
  const VersesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final verses = VerseService.getAllVerses();
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book,
              size: 20,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            const Text('Versículos Bíblicos'),
          ],
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: verses.length,
        itemBuilder: (context, index) {
          final verse = verses[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: VerseCard(
              verse: verse.text,
              reference: verse.reference,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Mostrar um versículo aleatório
          final randomVerse = VerseService.getRandomVerse();
          _showVerseDialog(context, randomVerse);
        },
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.auto_awesome),
        tooltip: 'Versículo Aleatório',
      ),
    );
  }
  
  void _showVerseDialog(BuildContext context, Verse verse) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.menu_book,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('Versículo do Dia'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              verse.text,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
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
                  color: Theme.of(context).colorScheme.primary,
                ),
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