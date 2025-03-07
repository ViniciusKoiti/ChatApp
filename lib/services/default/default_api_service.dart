import 'package:dio/dio.dart';
import 'package:jesusapp/services/base/base_service.dart';
import 'package:jesusapp/services/interfaces/i_api_service.dart';

class DefaultApiService extends BaseService implements IApiService {
  late final Dio _dio;

  DefaultApiService(String flavor) : super(flavor) {
    _dio = _createDioInstance();
  }

  Dio _createDioInstance() {
    final dio = Dio();
    dio.options.baseUrl = getBaseUrl();
    dio.options.headers = getHeaders();
    return dio;
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      logError('Erro na requisição GET', e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      logError('Erro na requisição POST', e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      logError('Erro na requisição PUT', e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> delete(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    try {
      final response =
          await _dio.delete(endpoint, queryParameters: queryParams);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      logError('Erro na requisição DELETE', e);
      rethrow;
    }
  }

  @override
  Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'X-App-Flavor': flavor,
      'Accept-Language': 'pt-BR',
    };
  }

  @override
  String getBaseUrl() {
    return 'https://api.default.example.com/v1';
  }
}
