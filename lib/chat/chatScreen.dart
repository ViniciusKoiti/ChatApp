import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatController.dart';
import 'package:provider/provider.dart';
import 'package:jesusapp/components/message_list.dart';
import 'package:jesusapp/components/message_input.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ChatController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('ChatGPT Clone')),
      body: Column(
        children: [
          Expanded(
            child: MessageList(messages: chatController.messages),
          ),
          MessageInput(
            onSendMessage: chatController.sendMessage,
          ),
        ],
      ),
    );
  }
}
