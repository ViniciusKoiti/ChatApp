import 'package:flutter/material.dart';
import 'package:jesusapp/components/prayer_card.dart';
import 'package:jesusapp/services/prayer_service.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class PrayersScreen extends StatelessWidget {
  const PrayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final prayers = PrayerService.getAllPrayers();
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              size: 20,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            const Text('Orações Diárias'),
          ],
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: prayers.length,
        itemBuilder: (context, index) {
          final prayer = prayers[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: PrayerCard(
              title: prayer.title,
              text: prayer.text,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Mostrar uma oração aleatória
          final randomPrayer = PrayerService.getRandomPrayer();
          _showPrayerDialog(context, randomPrayer);
        },
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.auto_awesome),
        tooltip: 'Oração Aleatória',
      ),
    );
  }
  
  void _showPrayerDialog(BuildContext context, Prayer prayer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.favorite,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(prayer.title),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            prayer.text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
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