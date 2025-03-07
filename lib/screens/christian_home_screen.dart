import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatScreen.dart';
import 'package:jesusapp/screens/prayers_screen.dart';
import 'package:jesusapp/screens/verses_screen.dart';
import 'package:jesusapp/services/verse_service.dart';
import 'package:jesusapp/services/prayer_service.dart';
import 'package:jesusapp/screens/base/flavor_home_screen.dart';
import 'package:jesusapp/components/cross_pattern_painter.dart';

class ChristianHomeScreen extends FlavorHomeScreen {
  const ChristianHomeScreen({super.key});

  @override
  String getWelcomeMessage(BuildContext context) {
    return 'Que a paz de Cristo esteja com você hoje.';
  }

  @override
  String getMenuTitle(BuildContext context) {
    return 'O que você gostaria de fazer hoje?';
  }

  @override
  List<MenuOption> getMenuOptions(BuildContext context) {
    return [
      MenuOption(
        icon: Icons.chat_bubble_outline,
        title: 'Conversar com o Assistente',
        description:
            'Tire suas dúvidas sobre fé, espiritualidade e vida cristã',
        screen: const ChatScreen(),
      ),
      MenuOption(
        icon: Icons.menu_book_outlined,
        title: 'Versículos Bíblicos',
        description: 'Explore versículos inspiradores da Palavra de Deus',
        screen: const VersesScreen(),
      ),
      MenuOption(
        icon: Icons.favorite_outline,
        title: 'Orações Diárias',
        description: 'Encontre orações para diferentes momentos e necessidades',
        screen: const PrayersScreen(),
      ),
    ];
  }

  @override
  DailyInspiration getDailyInspiration(BuildContext context) {
    final verse = VerseService.getRandomVerse();
    final prayer = PrayerService.getRandomPrayer();

    return DailyInspiration(
      title: 'Oração do Dia',
      content: prayer.text.length > 150
          ? '${prayer.text.substring(0, 150)}...'
          : prayer.text,
      reference: prayer.title,
      icon: Icons.favorite,
    );
  }

  @override
  Widget buildCustomBackground(BuildContext context) {
    return CustomPaint(
      painter: CrossPatternPainter(
        color: Theme.of(context).colorScheme.primary,
        opacity: 0.05,
        density: 25.0,
      ),
      child: Container(),
    );
  }

  @override
  List<Widget> getAdditionalWidgets(BuildContext context) {
    final verse = VerseService.getRandomVerse();
    final theme = Theme.of(context);

    return [
      const SizedBox(height: 24),
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
                    Icons.menu_book,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Versículo do Dia',
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
    ];
  }
}
