import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatController.dart';

class ShareButton extends StatefulWidget {
  final Map<String, dynamic> message;
  final ChatController chatController;
  final String shareButtonLabel;
  final bool isChristian;

  const ShareButton({
    super.key,
    required this.message,
    required this.chatController,
    required this.shareButtonLabel,
    required this.isChristian,
  });

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton>
    with SingleTickerProviderStateMixin {
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

    widget.chatController.shareResponse(widget.message);
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
        message: widget.shareButtonLabel,
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
                final hasEnoughSpace =
                    !isSmallScreen && constraints.maxWidth > 80;

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
                              widget.isChristian
                                  ? Icons.share
                                  : Icons.share_rounded,
                              size: isSmallScreen ? 18 : 20,
                              color: _isPressed
                                  ? theme.colorScheme.primary.withOpacity(0.7)
                                  : theme.colorScheme.primary,
                            ),
                            if (widget.isChristian && hasEnoughSpace) ...[
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  widget.shareButtonLabel,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _isPressed
                                        ? theme.colorScheme.primary
                                            .withOpacity(0.7)
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
