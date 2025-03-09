import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jesusapp/models/api/chat_response.dart';
import 'package:jesusapp/models/api/prayer_response.dart';
import 'package:jesusapp/models/api/verse_response.dart';
import 'package:jesusapp/models/api/message_context.dart';
import 'package:jesusapp/services/api/api_config.dart';
import 'package:jesusapp/services/api/api_exceptions.dart';
import 'package:jesusapp/services/api/interfaces/i_api_service.dart';
import 'package:jesusapp/services/base/base_service.dart';

class ApiService extends BaseService implements IApiService {
  late final Dio _dio;
  String? _cacheKey;

  ApiService(String flavor) : super(flavor) {
    _dio = _createDioInstance();
    _cacheKey = 'api_cache_$flavor';
  }

  Dio _createDioInstance() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: Duration(milliseconds: ApiConfig.connectTimeout),
        receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeout),
        headers: {
          ...ApiConfig.defaultHeaders,
          'X-App-Flavor': flavor,
        },
      ),
    );

    // Adicionar interceptors para log e tratamento de erros
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logDebug('Requisição: ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          logDebug('Resposta: ${response.statusCode}');
          handler.next(response);
        },
        onError: (error, handler) {
          logError('Erro: ${error.message}', error);
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  @override
  Future<ChatResponse> sendMessage({
    required String message,
    required String flavor,
    MessageContext? context,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.endpoints['chat']!,
        data: {
          'message': message,
          'flavor': flavor,
          'context': context?.toJson(),
        },
      );

      return ChatResponse.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e, 'chat');
    } catch (e) {
      throw ApiException('Erro ao enviar mensagem: $e', endpoint: 'chat');
    }
  }

  @override
  Future<VerseResponse> getRandomVerses({
    String? theme,
    String version = 'NVI',
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.endpoints['verses']!,
        queryParameters: {
          if (theme != null) 'theme': theme,
          'version': version,
        },
      );

      return VerseResponse.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e, 'verses');
    } catch (e) {
      throw ApiException('Erro ao obter versículos: $e', endpoint: 'verses');
    }
  }

  @override
  Future<PrayerResponse> getDailyPrayer({
    String? category,
    bool personalized = false,
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.endpoints['prayers']!,
        queryParameters: {
          if (category != null) 'category': category,
          'personalized': personalized,
        },
      );

      return PrayerResponse.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e, 'prayers');
    } catch (e) {
      throw ApiException('Erro ao obter oração: $e', endpoint: 'prayers');
    }
  }

  @override
  Future<List<String>> getAvailableFlavors() async {
    try {
      final response = await _dio.get(ApiConfig.endpoints['flavors']!);
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => e as String).toList();
    } on DioException catch (e) {
      throw _handleDioError(e, 'flavors');
    } catch (e) {
      throw ApiException('Erro ao obter flavors: $e', endpoint: 'flavors');
    }
  }

  @override
  Future<Map<String, dynamic>> checkApiHealth() async {
    try {
      final response = await _dio.get(ApiConfig.endpoints['health']!);
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e, 'health');
    } catch (e) {
      throw ApiException('Erro ao verificar saúde da API: $e',
          endpoint: 'health');
    }
  }

  ApiException _handleDioError(DioException e, String endpoint) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(endpoint: endpoint);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final data = e.response?.data;
        String? message;

        if (data is Map && data.containsKey('message')) {
          message = data['message'] as String?;
        }

        return ApiExceptionHandler.fromStatusCode(
          statusCode,
          message: message,
          data: data,
          endpoint: endpoint,
        );
      case DioExceptionType.connectionError:
        return ConnectionException(endpoint: endpoint);
      default:
        return ApiException(
          'Erro desconhecido: ${e.message}',
          endpoint: endpoint,
        );
    }
  }
}
