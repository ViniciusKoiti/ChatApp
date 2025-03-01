import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatScreen.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:jesusapp/screens/christian_home_screen.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final appType = themeProvider.getConfig<String>('appType', defaultValue: '');
        final isChristian = appType == 'christian';
        
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: themeProvider.getConfig<String>('appName', defaultValue: 'Assistente Virtual'),
          theme: themeProvider.themeData,
          home: isChristian ? const ChristianHomeScreen() : const ChatScreen(),
        );
      },
    );
  }
}
