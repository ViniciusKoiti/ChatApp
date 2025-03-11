import 'package:flutter/material.dart';
import 'package:jesusapp/services/api/mock/mock_prayer_service.dart';
import 'package:jesusapp/services/api/mock/mock_verse_service.dart';
import 'package:provider/provider.dart';
import 'package:jesusapp/chat/chatScreen.dart';
import 'package:jesusapp/screens/prayers_screen.dart';
import 'package:jesusapp/screens/verses_screen.dart';
import 'package:jesusapp/services/api/interfaces/i_verse_service.dart';
import 'package:jesusapp/screens/base/flavor_home_screen.dart';
import 'package:jesusapp/components/cross_pattern_painter.dart';

class ChristianHomeScreen extends StatefulWidget {
  const ChristianHomeScreen({super.key});

  @override
  State<ChristianHomeScreen> createState() => _ChristianHomeScreenState();
}

class _ChristianHomeScreenState extends State<ChristianHomeScreen> {
  Verse? dailyVerse;
  Prayer? dailyPrayer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDailyContent();
  }

  Future<void> _loadDailyContent() async {
    print('Carregando versículo aleatório...');
    final verseService = Provider.of<IVerseService>(context, listen: false);
    final prayerService = MockPrayerService();
    try {
      final verse = await verseService.getRandomVerse();
      print('Versículo carregado: ${verse.text}');
      final prayer = MockPrayerService.getRandomPrayer();

      setState(() {
        dailyVerse = verse;
        dailyPrayer = prayer;
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar conteúdo diário: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlavorHomeScreenImplementation(
      getWelcomeMessage: _getWelcomeMessage,
      getMenuTitle: _getMenuTitle,
      getMenuOptions: _getMenuOptions,
      getDailyInspiration: _getDailyInspiration,
      buildCustomBackground: _buildCustomBackground,
      getAdditionalWidgets: _getAdditionalWidgets,
      isLoading: isLoading,
    );
  }

  String _getWelcomeMessage(BuildContext context) {
    return 'Que a paz de Cristo esteja com você hoje.';
  }

  String _getMenuTitle(BuildContext context) {
    return 'O que você gostaria de fazer hoje?';
  }

  List<MenuOption> _getMenuOptions(BuildContext context) {
    return [
      const MenuOption(
        icon: Icons.chat_bubble_outline,
        title: 'Conversar com o Assistente',
        description:
            'Tire suas dúvidas sobre fé, espiritualidade e vida cristã',
        screen: ChatScreen(),
      ),
      const MenuOption(
        icon: Icons.menu_book_outlined,
        title: 'Versículos Bíblicos',
        description: 'Explore versículos inspiradores da Palavra de Deus',
        screen: VersesScreen(),
      ),
      const MenuOption(
        icon: Icons.favorite_outline,
        title: 'Orações Diárias',
        description: 'Encontre orações para diferentes momentos e necessidades',
        screen: PrayersScreen(),
      ),
    ];
  }

  DailyInspiration _getDailyInspiration(BuildContext context) {
    if (isLoading || dailyPrayer == null) {
      return const DailyInspiration(
        title: 'Carregando...',
        content: 'Aguarde um momento enquanto preparamos o conteúdo para você.',
        reference: '',
        icon: Icons.hourglass_empty,
      );
    }

    return DailyInspiration(
      title: 'Oração do Dia',
      content: dailyPrayer!.text.length > 150
          ? '${dailyPrayer!.text.substring(0, 150)}...'
          : dailyPrayer!.text,
      reference: dailyPrayer!.title,
      icon: Icons.favorite,
    );
  }

  Widget _buildCustomBackground(BuildContext context) {
    return CustomPaint(
      painter: CrossPatternPainter(
        color: Theme.of(context).colorScheme.primary,
        opacity: 0.05,
        density: 25.0,
      ),
      child: Container(),
    );
  }

  List<Widget> _getAdditionalWidgets(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading || dailyVerse == null) {
      return [
        const SizedBox(height: 24),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  Text('Carregando versículo...'),
                  const SizedBox(height: 8),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ];
    }

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
                '"${dailyVerse!.text}"',
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
                  dailyVerse!.reference,
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

class FlavorHomeScreenImplementation extends StatelessWidget {
  final String Function(BuildContext) getWelcomeMessage;
  final String Function(BuildContext) getMenuTitle;
  final List<MenuOption> Function(BuildContext) getMenuOptions;
  final DailyInspiration Function(BuildContext) getDailyInspiration;
  final Widget Function(BuildContext) buildCustomBackground;
  final List<Widget> Function(BuildContext) getAdditionalWidgets;
  final bool isLoading;

  const FlavorHomeScreenImplementation({
    required this.getWelcomeMessage,
    required this.getMenuTitle,
    required this.getMenuOptions,
    required this.getDailyInspiration,
    required this.buildCustomBackground,
    required this.getAdditionalWidgets,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implementação do FlavorHomeScreen utilizando os métodos fornecidos
    // Esta é uma implementação de exemplo, adapte conforme necessário
    return Scaffold(
      body: Stack(
        children: [
          buildCustomBackground(context),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho com mensagem de boas-vindas
                  Text(
                    getWelcomeMessage(context),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),

                  // Inspiração diária
                  _buildDailyInspiration(context),

                  // Título do menu
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
                    child: Text(
                      getMenuTitle(context),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),

                  // Opções de menu
                  ...getMenuOptions(context)
                      .map((option) => _buildMenuOption(context, option)),

                  // Widgets adicionais
                  ...getAdditionalWidgets(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyInspiration(BuildContext context) {
    final inspiration = getDailyInspiration(context);
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  inspiration.icon,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  inspiration.title,
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
              inspiration.content,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            if (inspiration.reference != null &&
                inspiration.reference!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  inspiration.reference ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(BuildContext context, MenuOption option) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(option.icon),
        title: Text(option.title),
        subtitle: Text(option.description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => option.screen),
          );
        },
      ),
    );
  }
}
