import 'package:flutter/material.dart';

/// Classe que gerencia os temas do aplicativo
class AppTheme {
  /// Identificador do tema
  final String id;
  
  /// Nome amigável do tema
  final String name;
  
  /// Esquema de cores do tema
  final ColorScheme colorScheme;
  
  /// Configurações de texto do tema
  final TextTheme? textTheme;
  
  /// Configurações adicionais específicas do tema
  final Map<String, dynamic> extraConfigs;

  const AppTheme({
    required this.id,
    required this.name,
    required this.colorScheme,
    this.textTheme,
    this.extraConfigs = const {},
  });

  /// Converte o tema em um ThemeData do Flutter
  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 2,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: colorScheme.primary,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  /// Temas predefinidos
  static final Map<String, AppTheme> predefinedThemes = {
    'default': AppTheme(
      id: 'default',
      name: 'Padrão',
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      extraConfigs: {
        'appName': 'Assistente Virtual',
        'chatPlaceholder': 'Digite sua mensagem...',
        'emptyStateMessage': 'Envie uma mensagem para começar',
        'copiedMessage': 'Resposta copiada para a área de transferência',
      },
    ),
    'religious': AppTheme(
      id: 'religious',
      name: 'Cristão',
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.purple.shade800,
        primary: Colors.purple.shade800,
        secondary: Colors.amber.shade700,
        tertiary: Colors.blue.shade700,
        brightness: Brightness.light,
      ),
      extraConfigs: {
        'appName': 'Assistente Cristão',
        'chatPlaceholder': 'Digite sua pergunta ou reflexão...',
        'emptyStateMessage': 'Faça uma pergunta para receber orientação espiritual',
        'copiedMessage': 'Mensagem copiada para compartilhar',
        'welcomeMessage': 'Bem-vindo ao seu assistente de fé e reflexão cristã',
        'shareButtonLabel': 'Compartilhar esta palavra',
        'copyButtonLabel': 'Copiar esta palavra',
        'biblicalThemes': [
          'Fé', 'Esperança', 'Amor', 'Perdão', 'Gratidão', 
          'Oração', 'Sabedoria', 'Paz', 'Perseverança'
        ],
        'appDescription': 'Um assistente para reflexões cristãs e orientação espiritual',
        'appType': 'christian',
      },
    ),
    'business': AppTheme(
      id: 'business',
      name: 'Empresarial',
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.light,
      ),
      extraConfigs: {
        'appName': 'Assistente Empresarial',
        'chatPlaceholder': 'Digite sua consulta de negócios...',
        'emptyStateMessage': 'Faça uma consulta para obter insights de negócios',
        'copiedMessage': 'Informação copiada para a área de transferência',
      },
    ),
    'education': AppTheme(
      id: 'education',
      name: 'Educacional',
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.light,
      ),
      extraConfigs: {
        'appName': 'Assistente Educacional',
        'chatPlaceholder': 'Digite sua dúvida...',
        'emptyStateMessage': 'Faça uma pergunta para aprender',
        'copiedMessage': 'Explicação copiada para a área de transferência',
      },
    ),
    'health': AppTheme(
      id: 'health',
      name: 'Saúde',
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.light,
      ),
      extraConfigs: {
        'appName': 'Assistente de Saúde',
        'chatPlaceholder': 'Digite sua dúvida sobre saúde...',
        'emptyStateMessage': 'Faça uma pergunta sobre saúde e bem-estar',
        'copiedMessage': 'Informação de saúde copiada',
      },
    ),
  };
} 