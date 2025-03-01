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
} 