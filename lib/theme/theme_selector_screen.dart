import 'package:flutter/material.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSelectorScreen extends StatelessWidget {
  const ThemeSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentThemeId = themeProvider.currentTheme.id;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Tema'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: themeProvider.availableThemes.length,
        itemBuilder: (context, index) {
          final appTheme = themeProvider.availableThemes[index];
          final isSelected = appTheme.id == currentThemeId;
          
          return Card(
            elevation: isSelected ? 4 : 1,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isSelected 
                ? BorderSide(color: theme.colorScheme.primary, width: 2)
                : BorderSide.none,
            ),
            child: InkWell(
              onTap: () => themeProvider.setTheme(appTheme.id),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: appTheme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          appTheme.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected 
                              ? theme.colorScheme.primary 
                              : theme.colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.primary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'App: ${appTheme.extraConfigs['appName']}',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildColorPalette(appTheme.colorScheme),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildColorPalette(ColorScheme colorScheme) {
    return Row(
      children: [
        _colorCircle(colorScheme.primary),
        const SizedBox(width: 8),
        _colorCircle(colorScheme.secondary),
        const SizedBox(width: 8),
        _colorCircle(colorScheme.tertiary ?? colorScheme.primary.withOpacity(0.7)),
        const SizedBox(width: 8),
        _colorCircle(colorScheme.surface),
      ],
    );
  }
  
  Widget _colorCircle(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
    );
  }
} 