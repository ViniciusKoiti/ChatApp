import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatScreen.dart';
import 'package:jesusapp/screens/base/flavor_home_screen.dart';
import 'package:jesusapp/theme/app_flavor.dart';

class DefaultHomeScreen extends FlavorHomeScreen {
  const DefaultHomeScreen({super.key});

  @override
  String getWelcomeMessage(BuildContext context) {
    return 'Bem-vindo ao seu assistente pessoal!';
  }

  @override
  String getMenuTitle(BuildContext context) {
    return 'O que você gostaria de fazer?';
  }

  @override
  List<MenuOption> getMenuOptions(BuildContext context) {
    return [
      const MenuOption(
        icon: Icons.chat_bubble_outline,
        title: 'Conversar com o Assistente',
        description: 'Tire suas dúvidas e receba ajuda personalizada',
        screen: ChatScreen(),
      ),
    ];
  }

  @override
  DailyInspiration getDailyInspiration(BuildContext context) {
    return const DailyInspiration(
      title: 'Dica do Dia',
      content: 'Use o assistente para obter ajuda com suas tarefas diárias.',
      icon: Icons.lightbulb_outline,
    );
  }

  @override
  Widget? buildCustomBackground(BuildContext context) {
    return null; // Sem fundo personalizado para o flavor padrão
  }
}
