import 'package:jesusapp/chat/chatController.dart';

class MockAiService implements IApiService {
  @override
  Future<String> getResponse(String message) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Resposta simulada para: $message';
  }
}