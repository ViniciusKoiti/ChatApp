import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatController.dart';
import 'package:jesusapp/service/mockAiService.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'chat/chatApp.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProxyProvider<ThemeProvider, ChatController>(
          create: (context) => ChatController(
            apiService: MockAiService(
              themeProvider: Provider.of<ThemeProvider>(context, listen: false),
            ),
            themeProvider: Provider.of<ThemeProvider>(context, listen: false),
          ),
          update: (context, themeProvider, previous) => ChatController(
            apiService: MockAiService(themeProvider: themeProvider),
            themeProvider: themeProvider,
          ),
        ),
      ],
      child: const ChatApp(),
    ),
  );
}
