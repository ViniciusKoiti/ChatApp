import 'package:flutter/material.dart';

/// Modelo para opções do menu
class MenuOption {
  final IconData icon;
  final String title;
  final String description;
  final Widget screen;

  const MenuOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.screen,
  });
}

/// Modelo para cartão de inspiração diária
class DailyInspiration {
  final String title;
  final String content;
  final String? reference;
  final IconData? icon;

  const DailyInspiration({
    required this.title,
    required this.content,
    this.reference,
    this.icon,
  });
}

/// Classe base abstrata para telas iniciais de diferentes flavors
abstract class FlavorHomeScreen extends StatelessWidget {
  const FlavorHomeScreen({super.key});

  /// Retorna a mensagem de boas-vindas específica do flavor
  String getWelcomeMessage(BuildContext context);

  /// Retorna o título do menu específico do flavor
  String getMenuTitle(BuildContext context);

  /// Retorna as opções de menu específicas do flavor
  List<MenuOption> getMenuOptions(BuildContext context);

  /// Retorna a inspiração diária específica do flavor
  DailyInspiration getDailyInspiration(BuildContext context);

  /// Retorna o widget de fundo personalizado do flavor
  Widget? buildCustomBackground(BuildContext context) => null;

  /// Retorna configurações de tema específicas do flavor
  ThemeData? getThemeOverride(BuildContext context) => null;

  /// Retorna widgets adicionais específicos do flavor
  List<Widget> getAdditionalWidgets(BuildContext context) => [];

  @override
  Widget build(BuildContext context) {
    return HomeScreenTemplate(
      welcomeMessage: getWelcomeMessage(context),
      menuTitle: getMenuTitle(context),
      menuOptions: getMenuOptions(context),
      dailyInspiration: getDailyInspiration(context),
      backgroundBuilder: buildCustomBackground != null
          ? (context) => buildCustomBackground(context)!
          : null,
      themeOverride: getThemeOverride(context),
      additionalWidgets: getAdditionalWidgets(context),
    );
  }
}

/// Template reutilizável para telas iniciais
class HomeScreenTemplate extends StatelessWidget {
  final String welcomeMessage;
  final String menuTitle;
  final List<MenuOption> menuOptions;
  final DailyInspiration dailyInspiration;
  final Widget Function(BuildContext)? backgroundBuilder;
  final ThemeData? themeOverride;
  final List<Widget> additionalWidgets;

  const HomeScreenTemplate({
    required this.welcomeMessage,
    required this.menuTitle,
    required this.menuOptions,
    required this.dailyInspiration,
    this.backgroundBuilder,
    this.themeOverride,
    this.additionalWidgets = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = themeOverride ?? Theme.of(context);

    Widget content = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context, theme),
            const SizedBox(height: 24),
            _buildMenuSection(context, theme),
            const SizedBox(height: 24),
            _buildDailyInspirationCard(context, theme),
            ...additionalWidgets,
          ],
        ),
      ),
    );

    if (backgroundBuilder != null) {
      content = Stack(
        children: [
          backgroundBuilder!(context),
          content,
        ],
      );
    }

    return Theme(
      data: theme,
      child: Scaffold(
        body: content,
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, ThemeData theme) {
    return Card(
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
              welcomeMessage,
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          menuTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        ...menuOptions.map((option) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildMenuOption(context, option, theme),
            )),
      ],
    );
  }

  Widget _buildMenuOption(
      BuildContext context, MenuOption option, ThemeData theme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => option.screen),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                option.icon,
                size: 32,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.description,
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

  Widget _buildDailyInspirationCard(BuildContext context, ThemeData theme) {
    return Card(
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
                if (dailyInspiration.icon != null) ...[
                  Icon(
                    dailyInspiration.icon,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  dailyInspiration.title,
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
              dailyInspiration.content,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (dailyInspiration.reference != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  dailyInspiration.reference!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
