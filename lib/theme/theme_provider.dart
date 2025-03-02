import 'package:flutter/material.dart';
import 'package:jesusapp/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeIdKey = 'theme_id';
  
  AppTheme _currentTheme;
  
  ThemeProvider({String? initialThemeId}) 
      : _currentTheme = AppTheme.predefinedThemes[initialThemeId ?? 'religious']! {
    _loadSavedTheme();
  }
  
  /// Tema atual
  AppTheme get currentTheme => _currentTheme;
  
  ThemeData get themeData => _currentTheme.toThemeData();
  
  List<AppTheme> get availableThemes => AppTheme.predefinedThemes.values.toList();
  
  T getConfig<T>(String key, {T? defaultValue}) {
    return _currentTheme.extraConfigs[key] as T? ?? defaultValue as T;
  }
  
  /// Define uma configuração específica no tema atual
  void setConfig(String key, dynamic value) {
    _currentTheme.extraConfigs[key] = value;
    notifyListeners();
    
    // Salvar a preferência em SharedPreferences quando for appType
    if (key == 'appType') {
      _saveConfigToPrefs(key, value);
    }
  }
  
  /// Salva uma configuração específica nas preferências
  Future<void> _saveConfigToPrefs(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      }
    } catch (e) {
      debugPrint('Erro ao salvar configuração: $e');
    }
  }
  
  /// Altera o tema atual
  Future<void> setTheme(String themeId) async {
    if (!AppTheme.predefinedThemes.containsKey(themeId)) {
      return;
    }
    
    _currentTheme = AppTheme.predefinedThemes[themeId]!;
    notifyListeners();
    
    // Salvar a preferência
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeIdKey, themeId);
  }
  
  /// Carrega o tema salvo nas preferências
  Future<void> _loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeId = prefs.getString(_themeIdKey);
      
      if (savedThemeId != null && AppTheme.predefinedThemes.containsKey(savedThemeId)) {
        _currentTheme = AppTheme.predefinedThemes[savedThemeId]!;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao carregar tema: $e');
    }
  }

  // Método para alternar entre os flavors (christian e padrão)
  void toggleAppType() {
    final currentAppType = getConfig<String>('appType', defaultValue: '');
    final newAppType = currentAppType == 'christian' ? '' : 'christian';
    setConfig('appType', newAppType);
    
    // Atualizar também as configurações específicas de cada flavor
    if (newAppType == 'christian') {
      setConfig('appName', 'Assistente Cristão');
    } else {
      setConfig('appName', 'JesusApp');
    }
    
    notifyListeners();
  }
} 