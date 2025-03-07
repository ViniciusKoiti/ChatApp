import 'package:jesusapp/services/christian/christian_api_service.dart';
import 'package:jesusapp/services/christian/christian_message_service.dart';
import 'package:jesusapp/services/default/default_api_service.dart';
import 'package:jesusapp/services/default/default_message_service.dart';
import 'package:jesusapp/services/interfaces/i_api_service.dart';
import 'package:jesusapp/services/interfaces/i_message_service.dart';
import 'package:jesusapp/theme/app_flavor.dart';

/// Factory para criar e gerenciar instâncias de serviços
class ServiceFactory {
  static final ServiceFactory _instance = ServiceFactory._internal();

  factory ServiceFactory() {
    return _instance;
  }

  ServiceFactory._internal();

  // Cache de serviços
  final Map<String, dynamic> _services = {};

  /// Obtém uma instância de serviço para o flavor especificado
  T getService<T>(String flavor) {
    // Chave única para cada tipo de serviço e flavor
    final String serviceKey = '${T.toString()}_$flavor';

    if (!_services.containsKey(serviceKey)) {
      _services[serviceKey] = _createService<T>(flavor);
    }

    return _services[serviceKey] as T;
  }

  /// Cria uma nova instância do serviço
  T _createService<T>(String flavor) {
    if (flavor == AppFlavor.christian) {
      return _createChristianService<T>(flavor);
    } else {
      return _createDefaultService<T>(flavor);
    }
  }

  /// Cria serviços específicos para o flavor cristão
  T _createChristianService<T>(String flavor) {
    switch (T) {
      case IMessageService:
        return ChristianMessageService(flavor) as T;
      case IApiService:
        return ChristianApiService(flavor) as T;
      default:
        throw Exception('Tipo de serviço não suportado: $T');
    }
  }

  /// Cria serviços específicos para o flavor padrão
  T _createDefaultService<T>(String flavor) {
    switch (T) {
      case IMessageService:
        return DefaultMessageService(flavor) as T;
      case IApiService:
        return DefaultApiService(flavor) as T;
      default:
        throw Exception('Tipo de serviço não suportado: $T');
    }
  }

  /// Limpa o cache de serviços
  void clearCache() {
    _services.clear();
  }

  /// Remove um serviço específico do cache
  void removeFromCache<T>(String flavor) {
    final String serviceKey = '${T.toString()}_$flavor';
    _services.remove(serviceKey);
  }
}
