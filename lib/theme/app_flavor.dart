/// Constantes para os flavors do aplicativo
class AppFlavor {
  // Valores dos flavors
  static const String christian = 'christian';
  static const String defaultFlavor = '';

  // Lista de flavors válidos
  static const List<String> validFlavors = [christian, defaultFlavor];

  // Nomes amigáveis dos flavors
  static const String christianAppName = 'Assistente Cristão';
  static const String defaultAppName = 'JesusApp';

  // Mensagens de logout
  static const String christianLogoutMessage =
      'Tem certeza que deseja encerrar sua sessão?';
  static const String defaultLogoutMessage = 'Tem certeza que deseja sair?';

  // Títulos de logout
  static const String christianLogoutTitle = 'Encerrar Sessão';
  static const String defaultLogoutTitle = 'Confirmar logout';

  // Botões de logout
  static const String christianLogoutButton = 'Encerrar';
  static const String defaultLogoutButton = 'Sair';

  // Labels de modo
  static const String christianModeLabel = 'Modo Cristão';
  static const String defaultModeLabel = 'Modo Padrão';

  // Previne instanciação
  const AppFlavor._();
}
