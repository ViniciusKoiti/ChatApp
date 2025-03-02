import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMockService with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _currentAppType; // Para armazenar o tipo de app com que o usuário fez login
  
  // Senha fixa para autenticação
  static const String _fixedPassword = '123456';
  
  bool get isAuthenticated => _isAuthenticated;
  String? get currentAppType => _currentAppType;
  
  // Construtor que verifica se o usuário já está logado
  AuthMockService() {
    _checkAuthentication();
  }
  
  // Verifica se o usuário já está autenticado pelo SharedPreferences
  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _currentAppType = prefs.getString('currentAppType');
    notifyListeners();
  }
  
  // Método de login com email e senha
  Future<bool> login(String email, String password, {String? appType}) async {
    // Simulação de delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Verifica se a senha corresponde à senha fixa
    if (password == _fixedPassword) {
      _isAuthenticated = true;
      _currentAppType = appType;
      
      // Salva o estado de autenticação e o tipo de app
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      if (appType != null) {
        await prefs.setString('currentAppType', appType);
      }
      
      notifyListeners();
      return true;
    }
    
    return false;
  }
  
  // Método para login com provedor social (mock)
  Future<bool> socialLogin(String provider, {String? appType}) async {
    // Simulação de delay de rede
    await Future.delayed(const Duration(milliseconds: 1200));
    
    // Sempre autenticar com sucesso para provedores sociais (é apenas um mock)
    _isAuthenticated = true;
    _currentAppType = appType;
    
    // Salva o estado de autenticação e o tipo de app
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    if (appType != null) {
      await prefs.setString('currentAppType', appType);
    }
    
    debugPrint('Login social com $provider no flavor: $appType');
    
    notifyListeners();
    return true;
  }
  
  // Método de logout
  Future<void> logout() async {
    _isAuthenticated = false;
    
    // Remove o estado de autenticação, mas mantém o tipo de app para futuras sessões
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    
    notifyListeners();
  }
} 