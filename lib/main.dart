import 'package:flutter/material.dart';
import 'package:jesusapp/chat/chatController.dart';
import 'package:jesusapp/service/mockAiService.dart';
import 'package:provider/provider.dart';

import 'chat/chatApp.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatController(apiService: MockAiService()),
        ),
      ],
      child: const ChatApp(),
    ),
  );
}
