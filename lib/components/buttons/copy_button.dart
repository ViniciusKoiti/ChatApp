import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatController.dart';

class CopyButton extends StatefulWidget {
  final Map<String, String> message;
  final ChatController chatController;
  final String copiedMessage;
  final String copyButtonLabel;
  final bool isChristian;

  const CopyButton({
    super.key,
    required this.message,
    required this.chatController,
    required this.copiedMessage,
    required this.copyButtonLabel,
    required this.isChristian,
  });

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isPressed = true;
    });
    
    _animationController.forward().then((_) {
      _animationController.reverse().then((_) {
        setState(() {
          _isPressed = false;
        });
      });
    });
    
    widget.chatController.copyResponseToClipboard(widget.message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.copiedMessage),
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Determina o tamanho mínimo do botão com base no tamanho da tela
    final bool isSmallScreen = screenWidth < 360;
    
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: Tooltip(
        message: 'Copiar para área de transferência',
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _handleTap,
          child: Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Ajusta o limite de espaço com base no tamanho da tela
                final hasEnoughSpace = !isSmallScreen && constraints.maxWidth > 80;
                
                return AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_animationController.value * 0.2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.isChristian ? Icons.content_copy : Icons.content_copy_rounded,
                              size: isSmallScreen ? 18 : 20,
                              color: _isPressed 
                                ? theme.colorScheme.primary.withOpacity(0.7)
                                : theme.colorScheme.primary,
                            ),
                            if (widget.isChristian && hasEnoughSpace) ...[
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  widget.copyButtonLabel,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _isPressed 
                                      ? theme.colorScheme.primary.withOpacity(0.7)
                                      : theme.colorScheme.primary,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
} 