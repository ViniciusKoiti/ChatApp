import 'package:flutter/material.dart';
import 'package:jesusapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MessageInput extends StatefulWidget {
  final Function(String) onSendMessage;

  const MessageInput({
    super.key,
    required this.onSendMessage,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final placeholder = themeProvider.getConfig<String>(
      'chatPlaceholder', 
      defaultValue: 'Digite sua mensagem...'
    );
    final appType = themeProvider.getConfig<String>('appType', defaultValue: '');
    final isChristian = appType == 'christian';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isChristian) _buildSuggestions(context),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration(
                      hintText: placeholder,
                      hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: InputBorder.none,
                      prefixIcon: isChristian ? Icon(
                        Icons.question_answer_outlined,
                        color: theme.colorScheme.primary.withOpacity(0.5),
                        size: 20,
                      ) : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => _sendMessage(_controller.text),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      isChristian ? Icons.send : Icons.send_rounded,
                      color: theme.colorScheme.onPrimary,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSuggestions(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final biblicalThemes = themeProvider.getConfig<List<dynamic>>(
      'biblicalThemes', 
      defaultValue: <String>[]
    ).cast<String>();
    
    if (biblicalThemes.isEmpty) return const SizedBox.shrink();
    
    // Mostrar apenas alguns temas aleatórios
    biblicalThemes.shuffle();
    final displayThemes = biblicalThemes.take(3).toList();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 4),
            ...displayThemes.map((theme) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
                label: Text(
                  theme,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
                onPressed: () {
                  _controller.text = 'Me fale sobre $theme no contexto cristão';
                  _focusNode.requestFocus();
                },
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
  
  void _sendMessage(String text) {
    if (text.trim().isNotEmpty) {
      widget.onSendMessage(text);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }
} 