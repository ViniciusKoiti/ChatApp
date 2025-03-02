import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jesusapp/service/authMockService.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:jesusapp/components/cross_pattern_painter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final authService = Provider.of<AuthMockService>(context, listen: false);
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      final appType = themeProvider.getConfig<String>('appType', defaultValue: '');
      
      // Chamada de login com informação do flavor
      final success = await authService.login(
        _emailController.text.trim(),
        _passwordController.text,
        appType: appType,
      );
      
      if (!success && mounted) {
        final errorMsg = appType == 'christian' 
            ? 'Falha no login. Por favor, tente novamente.'
            : 'Falha no login.';
        setState(() {
          _errorMessage = errorMsg;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro ao fazer login: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _socialLogin(String provider) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final authService = Provider.of<AuthMockService>(context, listen: false);
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      final appType = themeProvider.getConfig<String>('appType', defaultValue: '');
      
      // Chamada de login social com informação do flavor
      await authService.socialLogin(provider, appType: appType);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro ao fazer login com $provider: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final appName = themeProvider.getConfig<String>('appName', defaultValue: 'JesusApp');
    final appType = themeProvider.getConfig<String>('appType', defaultValue: '');
    final isChristian = appType == 'christian';
    
    // Obter configurações específicas baseadas no flavor
    final loginTitle = themeProvider.getConfig<String>(
        'loginTitle', 
        defaultValue: isChristian ? 'Bem-vindo à sua jornada de fé' : 'Bem-vindo ao $appName'
    );
    
    final loginSubtitle = themeProvider.getConfig<String>(
        'loginSubtitle', 
        defaultValue: isChristian 
            ? 'Entre para iniciar sua jornada espiritual' 
            : 'Entre para continuar'
    );
    
    return Scaffold(
      body: CustomPaint(
        painter: isChristian ? CrossPatternPainter(
          color: theme.colorScheme.primary,
          opacity: 0.05,
          density: 25.0,
        ) : null,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  isChristian
                  ? Icon(
                      Icons.wb_sunny_outlined,
                      size: 80,
                      color: theme.colorScheme.primary,
                    )
                  : Icon(
                      Icons.account_circle,
                      size: 80,
                      color: theme.colorScheme.primary,
                    ),
                  const SizedBox(height: 24),
                  Text(
                    loginTitle,
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loginSubtitle,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (isChristian) ...[
                    const SizedBox(height: 16),
                    Text(
                      '"Eu sou o caminho, a verdade e a vida." - João 14:6',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: const OutlineInputBorder(),
                      hintText: isChristian ? 'seu.email@exemplo.com' : 'email@exemplo.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      hintText: isChristian ? '(senha padrão: 123456)' : '',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua senha';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _login(),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(isChristian ? 'INICIAR JORNADA' : 'ENTRAR'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ou continuar com',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialLoginButton(
                        icon: Icons.g_mobiledata,
                        color: Colors.red,
                        onPressed: _isLoading ? null : () => _socialLogin('google'),
                      ),
                      const SizedBox(width: 16),
                      _SocialLoginButton(
                        icon: Icons.facebook_outlined,
                        color: Colors.blue,
                        onPressed: _isLoading ? null : () => _socialLogin('facebook'),
                      ),
                      const SizedBox(width: 16),
                      _SocialLoginButton(
                        icon: Icons.apple_outlined,
                        color: Colors.black,
                        onPressed: _isLoading ? null : () => _socialLogin('apple'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      // Função para "esqueci minha senha" (não implementado)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isChristian 
                              ? 'Deus nunca esquece de você. A senha padrão é 123456.' 
                              : 'Função não implementada. A senha padrão é 123456.'),
                        ),
                      );
                    },
                    child: const Text('Esqueci minha senha'),
                  ),
                  const SizedBox(height: 8),
                  if (!isChristian) ...[
                    Text(
                      'Senha padrão: 123456',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  
                  // Botão oculto para alternar entre os flavors (apenas para desenvolvimento)
                  const SizedBox(height: 40),
                  GestureDetector(
                    onDoubleTap: () {
                      // Alternar entre os flavors
                      themeProvider.toggleAppType();
                      
                      // Mostrar qual flavor está ativo agora
                      final newAppType = themeProvider.getConfig<String>('appType', defaultValue: '');
                      final flavorName = newAppType.isEmpty ? 'Padrão' : 'Cristão';
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Flavor alterado para: $flavorName'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: const Text(
                        'Dev: Toque 2x para alternar flavor',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _SocialLoginButton({
    required this.icon,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        iconSize: 36,
        splashRadius: 24,
      ),
    );
  }
} 