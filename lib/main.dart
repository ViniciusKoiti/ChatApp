import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatController.dart';
import 'package:jesusapp/services/mock/mockAiService.dart';
import 'package:jesusapp/services/mock/authMockService.dart';
import 'package:jesusapp/services/api/chat-llm/api_verse_service.dart';
import 'package:jesusapp/services/api/api_service.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:jesusapp/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jesusapp/services/api/interfaces/i_verse_service.dart';
import 'package:jesusapp/services/api/interfaces/i_api_service.dart';
import 'package:jesusapp/services/api/mock/mock_verse_service.dart';
import 'package:jesusapp/services/api/mock/mock_prayer_service.dart';

import 'chat/chatApp.dart';

enum AppFlavor { standard, christian }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final String? savedAppType = prefs.getString('currentAppType');

  final themeProvider = ThemeProvider();
  if (savedAppType != null) {
    themeProvider.setConfig('appType', savedAppType);
  }

  // Determinar se estamos no modo de desenvolvimento ou produção
  const bool useRealApi =
      true; // Altere para true quando estiver pronto para usar a API real
  const String apiBaseUrl = 'http://localhost:8000/api/v1'; // URL da sua API

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: themeProvider,
        ),

        Provider<IVerseService>(
          create: (context) {
            if (useRealApi) {
              return ApiVerseService(baseUrl: apiBaseUrl);
            } else {
              return MockVerseService();
            }
          },
        ),

        Provider<IApiService>(
          create: (context) {
            final flavor =
                themeProvider.getConfig<String>('appType', defaultValue: '');
            if (useRealApi) {
              return ApiService(flavor);
            } else {
              return MockAiService(initialFlavor: flavor);
            }
          },
        ),

        ChangeNotifierProvider(
          create: (_) => AuthMockService(),
        ),

        ChangeNotifierProxyProvider3<ThemeProvider, IVerseService, IApiService,
            ChatController>(
          create: (context) => ChatController(
            apiService: Provider.of<IApiService>(context, listen: false),
            themeProvider: themeProvider,
            verseService: Provider.of<IVerseService>(context, listen: false),
          ),
          update: (context, themeProvider, verseService, apiService, previous) {
            return previous ??
                ChatController(
                  apiService: apiService,
                  themeProvider: themeProvider,
                  verseService: verseService,
                );
          },
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
        final String? authAppType = authService.currentAppType;
        final String currentAppType =
            themeProvider.getConfig<String>('appType', defaultValue: '');

        if (authService.isAuthenticated &&
            authAppType != null &&
            authAppType != currentAppType) {
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
    final authService = Provider.of<AuthMockService>(context);

    if (authService.isAuthenticated) {
      return const ChatApp();
    } else {
      return const LoginScreen();
    }
  }
}

AppFlavor getCurrentFlavor(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final appType = themeProvider.getConfig<String>('appType', defaultValue: '');
  return appType == 'christian' ? AppFlavor.christian : AppFlavor.standard;
}
