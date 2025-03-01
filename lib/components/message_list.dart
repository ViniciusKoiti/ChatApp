import 'package:flutter/material.dart';
import 'package:jesusapp/components/message_bubble.dart';

class MessageList extends StatelessWidget {
  final List<Map<String, String>> messages;

  const MessageList({
    super.key,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages.reversed.toList()[index];
        return MessageBubble(message: message);
      },
    );
  }
} 