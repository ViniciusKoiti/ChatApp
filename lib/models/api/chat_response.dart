import 'package:jesusapp/models/api/bible_reference.dart';

/// Classe que representa a resposta de uma mensagem de chat
class ChatResponse {
  /// Texto da resposta
  final String response;

  /// Referências bíblicas relacionadas à resposta
  final List<BibleReference>? references;

  /// Sugestões de tópicos ou mensagens de acompanhamento
  final List<String>? suggestions;

  /// Construtor
  ChatResponse({
    required this.response,
    this.references,
    this.suggestions,
  });

  /// Converte o objeto para JSON
  Map<String, dynamic> toJson() => {
        'response': response,
        'references': references?.map((e) => e.toJson()).toList(),
        'suggestions': suggestions,
      };

  /// Cria um objeto a partir de JSON
  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      response: json['response'] as String,
      references: (json['references'] as List<dynamic>?)
          ?.map((e) => BibleReference.fromJson(e as Map<String, dynamic>))
          .toList(),
      suggestions: (json['suggestions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }
}
