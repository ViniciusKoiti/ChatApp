import 'package:jesusapp/theme/app_flavor.dart';

/// Classe base abstrata para todos os serviços
abstract class BaseService {
  final String flavor;

  BaseService(this.flavor) {
    validateFlavor();
  }

  /// Verifica se o serviço está no flavor cristão
  bool get isChristian => flavor == AppFlavor.christian;

  /// Verifica se o serviço está no flavor padrão
  bool get isDefault => flavor == AppFlavor.defaultFlavor;

  /// Valida se o flavor é suportado
  void validateFlavor() {
    if (!AppFlavor.validFlavors.contains(flavor)) {
      throw Exception('Flavor não suportado: $flavor');
    }
  }

  /// Retorna o nome do serviço para logging
  String get serviceName => runtimeType.toString();

  /// Log helper para debug
  void logDebug(String message) {
    print('[$serviceName][$flavor] $message');
  }

  /// Log helper para erros
  void logError(String message, [dynamic error]) {
    print('[$serviceName][$flavor] ERROR: $message ${error ?? ''}');
  }
}
