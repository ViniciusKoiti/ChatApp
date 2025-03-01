import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Digite sua mensagem...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.blue,
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                widget.onSendMessage(_controller.text);
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
} 