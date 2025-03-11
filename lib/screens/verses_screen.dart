import 'package:flutter/material.dart';
import 'package:jesusapp/components/verse_card.dart';
import 'package:jesusapp/services/api/interfaces/i_verse_service.dart';
import 'package:jesusapp/services/api/mock/mock_verse_service.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class VersesScreen extends StatefulWidget {
  const VersesScreen({super.key});

  @override
  State<VersesScreen> createState() => _VersesScreenState();
}

class _VersesScreenState extends State<VersesScreen> {
  List<Verse> verses = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadVerses();
  }

  Future<void> _loadVerses() async {
    try {
      final verseService = Provider.of<IVerseService>(context, listen: false);
      final loadedVerses = await verseService.getAllVerses();

      setState(() {
        verses = loadedVerses;
        isLoading = false;
        errorMessage = '';
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Erro ao carregar versículos: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

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
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRandomVerse(context),
        backgroundColor: theme.colorScheme.primary,
        tooltip: 'Versículo Aleatório',
        child: const Icon(Icons.auto_awesome),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando versículos...'),
          ],
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(errorMessage),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadVerses,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (verses.isEmpty) {
      return const Center(
        child: Text('Nenhum versículo encontrado'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadVerses,
      child: ListView.builder(
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
    );
  }

  Future<void> _showRandomVerse(BuildContext context) async {
    final verseService = Provider.of<IVerseService>(context, listen: false);

    // Mostrar indicador de carregamento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final randomVerse = await verseService.getRandomVerse();

      if (context.mounted) Navigator.of(context).pop();

      if (context.mounted) _showVerseDialog(context, randomVerse);
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao buscar versículo aleatório: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showRandomVerse(context);
            },
            child: const Text('Próximo'),
          ),
        ],
      ),
    );
  }
}
