import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:typed_data';
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
        connectTimeout: const Duration(milliseconds: ApiConfig.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
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

  

Stream<String> sendMessageStream({
  required String message,
  required String flavor,
  MessageContext? context,
}) async* {
  try {
    logDebug('Iniciando streaming de resposta para: $message');

    final dio = _dio; // Reutiliza a instância existente

    final response = await dio.post(
      ApiConfig.endpoints['chat']!,
      data: {
        'message': message,
        'flavor': flavor,
        'context': context?.toJson(),
      },
      options: Options(
        responseType: ResponseType.stream, // Configura resposta como stream
        contentType: 'application/json',
        headers: {'Accept': 'text/plain'},
      ),
    );

    // Acessando o Stream da resposta
    final Stream<Uint8List> responseStream = response.data.stream;

    String buffer = ''; // Buffer para armazenar palavras incompletas

    yield '...';

    await for (Uint8List chunk in responseStream) {
      try {
        final String text = utf8.decode(chunk); // Decodifica chunk para texto
        logDebug('Chunk decodificado: $text');

        buffer += text; // Acumula no buffer

        final words = buffer.split(' '); // Divide em palavras
        buffer = words.removeLast(); // Mantém a última palavra (pode estar incompleta)

        for (final word in words) {
          yield word + ' '; // Emite a palavra com um espaço
          await Future.delayed(const Duration(milliseconds: 10)); // Simula o tempo do mock
        }
      } catch (e) {
        logError('Erro ao decodificar chunk: $e', e);
      }
    }

    if (buffer.isNotEmpty) {
      yield buffer; // Emite qualquer parte final restante
    }

  } on DioException catch (e) {
    logError('Erro Dio no streaming: ${e.message}', e);
    throw _handleDioError(e, 'chat');
  } catch (e) {
    logError('Erro geral no streaming: $e', e);
    throw ApiException(
      'Erro ao enviar mensagem: $e', 
      endpoint: 'chat',
    );
  }
}


  @override
  Future<ChatResponse> sendMessage({
    required String message,
    required String flavor,
    MessageContext? context,
  }) async {
    print('sendMessage: $message, $flavor, $context');
    try {
      final response = await _dio.post(
        ApiConfig.endpoints['chat']!,
        data: {
          'message': message,
          'flavor': flavor,
          'context': context?.toJson(),
        },
      );

      return ChatResponse.fromJson(response.data);
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
      print(response.data);

      if (response.data is String) {
        return jsonDecode(response.data) as Map<String, dynamic>;
      } else if (response.data is Map) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException('Formato de resposta inesperado',
            endpoint: 'health');
      }
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
