import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatScreen.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:jesusapp/screens/christian_home_screen.dart';
import 'package:jesusapp/service/authMockService.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, AuthMockService>(
      builder: (context, themeProvider, authService, _) {
        final appType = themeProvider.getConfig<String>('appType', defaultValue: '');
        final isChristian = appType == 'christian';
        
        // Configurações personalizadas baseadas no flavor
        final appName = themeProvider.getConfig<String>(
          'appName', 
          defaultValue: isChristian ? 'Assistente Cristão' : 'JesusApp'
        );
        
        final logoutConfirmMessage = themeProvider.getConfig<String>(
          'logoutConfirmMessage', 
          defaultValue: isChristian 
              ? 'Tem certeza que deseja encerrar sua sessão?' 
              : 'Tem certeza que deseja sair?'
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
                      'Modo: $appType',
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
                tooltip: 'Sair',
                onPressed: () {
                  // Mostrar diálogo de confirmação
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(isChristian ? 'Encerrar Sessão' : 'Confirmar logout'),
                      content: Text(logoutConfirmMessage),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Fazer logout
                            Provider.of<AuthMockService>(context, listen: false).logout();
                          },
                          child: Text(isChristian ? 'Encerrar' : 'Sair'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: isChristian ? const ChristianHomeScreen() : const ChatScreen(),
        );
      },
    );
  }
}
