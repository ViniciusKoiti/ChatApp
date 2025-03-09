/// Classe que representa as preferências do usuário para personalização das respostas
class UserPreferences {
  /// Versão da Bíblia preferida
  final String bibleVersion;

  /// Idioma preferido
  final String language;

  const UserPreferences({
    this.bibleVersion = 'NVI',
    this.language = 'pt-BR',
  });

  Map<String, dynamic> toJson() => {
        'bible_version': bibleVersion,
        'language': language,
      };

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      bibleVersion: json['bible_version'] as String? ?? 'NVI',
      language: json['language'] as String? ?? 'pt-BR',
    );
  }
}

/// Classe que representa o contexto de uma mensagem no chat
class MessageContext {
  /// Lista de mensagens anteriores na conversa
  final List<Map<String, String>> previousMessages;

  /// Preferências do usuário para personalização
  final UserPreferences? userPreferences;

  const MessageContext({
    this.previousMessages = const [],
    this.userPreferences,
  });

  Map<String, dynamic> toJson() => {
        'previous_messages': previousMessages,
        'user_preferences': userPreferences?.toJson(),
      };

  factory MessageContext.fromJson(Map<String, dynamic> json) {
    return MessageContext(
      previousMessages: (json['previous_messages'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          [],
      userPreferences: json['user_preferences'] != null
          ? UserPreferences.fromJson(
              json['user_preferences'] as Map<String, dynamic>)
          : null,
    );
  }
}
