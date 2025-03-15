import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatScreen.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:jesusapp/screens/christian_home_screen.dart';
import 'package:jesusapp/services/mock/authMockService.dart';
import 'package:jesusapp/theme/app_flavor.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, AuthMockService>(
      builder: (context, themeProvider, authService, _) {
        final appType = themeProvider.getConfig<String>('appType', defaultValue: AppFlavor.defaultFlavor);
        final isChristian = appType == AppFlavor.christian;
        
        // Configurações personalizadas baseadas no flavor
        final appName = themeProvider.getConfig<String>(
          'appName', 
          defaultValue: isChristian ? AppFlavor.christianAppName : AppFlavor.defaultAppName
        );
        
        final logoutConfirmMessage = themeProvider.getConfig<String>(
          'logoutConfirmMessage', 
          defaultValue: isChristian ? AppFlavor.christianLogoutMessage : AppFlavor.defaultLogoutMessage
        );
        
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isChristian) ...[
                  Icon(
                    Icons.wb_sunny_outlined,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(appName),
              ],
            ),
            centerTitle: true,
            actions: [
              // Exibe o tipo de app atual (apenas em desenvolvimento)
              if (appType.isNotEmpty) ...[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      isChristian ? AppFlavor.christianModeLabel : AppFlavor.defaultModeLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ],
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: isChristian ? AppFlavor.christianLogoutButton : AppFlavor.defaultLogoutButton,
                onPressed: () => _showLogoutDialog(context, isChristian, authService),
              ),
            ],
          ),
          body: isChristian ? const ChristianHomeScreen() : const ChatScreen(),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, bool isChristian, AuthMockService authService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isChristian ? AppFlavor.christianLogoutTitle : AppFlavor.defaultLogoutTitle),
        content: Text(isChristian ? AppFlavor.christianLogoutMessage : AppFlavor.defaultLogoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              authService.logout();
            },
            child: Text(isChristian ? AppFlavor.christianLogoutButton : AppFlavor.defaultLogoutButton),
          ),
        ],
      ),
    );
  }
}
