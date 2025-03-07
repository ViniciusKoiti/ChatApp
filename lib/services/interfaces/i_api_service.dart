/// Interface para serviços de API
abstract class IApiService {
  /// Realiza uma requisição GET
  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, dynamic>? queryParams});

  /// Realiza uma requisição POST
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParams,
  });

  /// Realiza uma requisição PUT
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParams,
  });

  /// Realiza uma requisição DELETE
  Future<Map<String, dynamic>> delete(String endpoint,
      {Map<String, dynamic>? queryParams});

  /// Obtém os headers específicos do flavor
  Map<String, String> getHeaders();

  /// Obtém a URL base da API
  String getBaseUrl();
}
