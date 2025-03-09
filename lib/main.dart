import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatController.dart';
import 'package:jesusapp/service/mockAiService.dart';
import 'package:jesusapp/service/authMockService.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:jesusapp/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat/chatApp.dart';

enum AppFlavor { standard, christian }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carregar o flavor salvo ou usar o padrão
  final prefs = await SharedPreferences.getInstance();
  final String? savedAppType = prefs.getString('currentAppType');

  // Inicializar o ThemeProvider com o flavor correto
  final themeProvider = ThemeProvider();
  if (savedAppType != null) {
    themeProvider.setConfig('appType', savedAppType);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: themeProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => AuthMockService(),
        ),
        ChangeNotifierProxyProvider<ThemeProvider, ChatController>(
          create: (context) => ChatController(
            apiService: MockAiService(
              initialFlavor: Provider.of<ThemeProvider>(context, listen: false)
                  .getConfig<String>('appType', defaultValue: ''),
            ),
            themeProvider: Provider.of<ThemeProvider>(context, listen: false),
          ),
          update: (context, themeProvider, previous) => ChatController(
            apiService: MockAiService(
              initialFlavor:
                  themeProvider.getConfig<String>('appType', defaultValue: ''),
            ),
            themeProvider: themeProvider,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, AuthMockService>(
      builder: (context, themeProvider, authService, _) {
        // Verificar se há um flavor salvo do login que precisa ser aplicado
        final String? authAppType = authService.currentAppType;
        final String currentAppType =
            themeProvider.getConfig<String>('appType', defaultValue: '');

        // Se o usuário estiver logado e o flavor salvo for diferente do atual, atualizar
        if (authService.isAuthenticated &&
            authAppType != null &&
            authAppType != currentAppType) {
          // Atualizar o flavor no ThemeProvider
          WidgetsBinding.instance.addPostFrameCallback((_) {
            themeProvider.setConfig('appType', authAppType);
          });
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: themeProvider.getConfig<String>('appName',
              defaultValue: 'Assistente Virtual'),
          theme: themeProvider.themeData,
          home: const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Observa o estado de autenticação
    final authService = Provider.of<AuthMockService>(context);

    // Mostra a tela de login ou o ChatApp dependendo do estado de autenticação
    if (authService.isAuthenticated) {
      return const ChatApp();
    } else {
      return const LoginScreen();
    }
  }
}

// Função helper para obter o flavor atual
AppFlavor getCurrentFlavor(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final appType = themeProvider.getConfig<String>('appType', defaultValue: '');
  return appType == 'christian' ? AppFlavor.christian : AppFlavor.standard;
}
