/// Exceção base para erros relacionados à API
class ApiException implements Exception {
  /// Mensagem de erro
  final String message;

  /// Código HTTP de status, se disponível
  final int? statusCode;

  /// Dados adicionais do erro
  final dynamic data;

  /// Endpoint que gerou o erro
  final String? endpoint;

  ApiException(
    this.message, {
    this.statusCode,
    this.data,
    this.endpoint,
  });

  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
  }
}

/// Exceção para erros de conexão
class ConnectionException extends ApiException {
  ConnectionException({
    String message = 'Não foi possível conectar ao servidor',
    String? endpoint,
  }) : super(message, endpoint: endpoint);
}

/// Exceção para timeout de conexão
class TimeoutException extends ApiException {
  TimeoutException({
    String message = 'A conexão expirou. Tente novamente mais tarde',
    String? endpoint,
  }) : super(message, endpoint: endpoint);
}

/// Exceção para erros de servidor (5xx)
class ServerException extends ApiException {
  ServerException({
    String message = 'Erro no servidor. Tente novamente mais tarde',
    int? statusCode,
    dynamic data,
    String? endpoint,
  }) : super(message, statusCode: statusCode, data: data, endpoint: endpoint);
}

/// Exceção para erros de cliente (4xx)
class ClientException extends ApiException {
  ClientException({
    String message = 'Erro na requisição',
    int? statusCode,
    dynamic data,
    String? endpoint,
  }) : super(message, statusCode: statusCode, data: data, endpoint: endpoint);
}

/// Exceção para erros de autenticação
class AuthException extends ClientException {
  AuthException({
    String message = 'Erro de autenticação',
    int? statusCode = 401,
    dynamic data,
    String? endpoint,
  }) : super(
          message: message,
          statusCode: statusCode,
          data: data,
          endpoint: endpoint,
        );
}

/// Exceção para erros quando offline
class OfflineException extends ApiException {
  OfflineException({
    String message = 'Você está offline. Verifique sua conexão',
    String? endpoint,
  }) : super(message, endpoint: endpoint);
}

/// Exceção para erros de formato de resposta
class ResponseFormatException extends ApiException {
  ResponseFormatException({
    String message = 'Formato de resposta inválido',
    dynamic data,
    String? endpoint,
  }) : super(message, data: data, endpoint: endpoint);
}

/// Helper para converter códigos HTTP em exceções
class ApiExceptionHandler {
  /// Converte um código HTTP e dados em uma exceção apropriada
  static ApiException fromStatusCode(
    int statusCode, {
    String? message,
    dynamic data,
    String? endpoint,
  }) {
    if (statusCode >= 500) {
      return ServerException(
        message: message ?? 'Erro no servidor. Tente novamente mais tarde',
        statusCode: statusCode,
        data: data,
        endpoint: endpoint,
      );
    } else if (statusCode == 401 || statusCode == 403) {
      return AuthException(
        message: message ?? 'Erro de autenticação',
        statusCode: statusCode,
        data: data,
        endpoint: endpoint,
      );
    } else if (statusCode >= 400 && statusCode < 500) {
      return ClientException(
        message: message ?? 'Erro na requisição',
        statusCode: statusCode,
        data: data,
        endpoint: endpoint,
      );
    } else {
      return ApiException(
        message ?? 'Erro desconhecido',
        statusCode: statusCode,
        data: data,
        endpoint: endpoint,
      );
    }
  }
}
