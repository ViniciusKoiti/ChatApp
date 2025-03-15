import 'package:flutter/foundation.dart';

/// Configurações para conexão com a API LLM
class ApiConfig {
  /// URL base da API para ambiente de produção
  static const String productionBaseUrl = 'https://api.yourdomain.com/api/v1';

  /// URL base da API para ambiente de desenvolvimento
  static const String developmentBaseUrl = 'http://localhost:8000/api/v1';

  /// URL base da API para ambiente de teste
  static const String testBaseUrl = 'http://localhost:8000/api/v1';

  /// Obtém a URL base apropriada com base no ambiente atual
  static String get baseUrl {
    return testBaseUrl;
    if (kReleaseMode) {
      return const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: productionBaseUrl,
      );
    } else if (kProfileMode) {
      return testBaseUrl;
    } else {
      return developmentBaseUrl;
    }
  }

  /// Tempo limite para estabelecer conexão (em milissegundos)
  static const int connectTimeout = 5000;

  /// Tempo limite para receber resposta (em milissegundos)
  static const int receiveTimeout = 15000;

  /// Número máximo de tentativas de reconexão
  static const int maxRetries = 3;

  /// Tempo de espera entre tentativas (em milissegundos)
  static const int retryDelay = 1000;

  /// Headers padrão para as requisições
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-App-Version': '1.0.0',
      };

  static const Map<String, String> endpoints = {
    'chat': '/chat/message',
    'flavors': '/chat/flavors',
    'health': '/health',
    'verses': '/verses/random',
    'prayers': '/prayers/daily',
  };

  static const int cacheExpiration = 60;
}
