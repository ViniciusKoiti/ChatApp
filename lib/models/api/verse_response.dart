import 'package:jesusapp/models/api/bible_reference.dart';

/// Classe que representa a resposta para versículos bíblicos
class VerseResponse {
  /// Lista de versículos
  final List<BibleReference> verses;

  /// Tema ou categoria dos versículos
  final String? theme;

  /// Construtor
  VerseResponse({
    required this.verses,
    this.theme,
  });

  /// Converte o objeto para JSON
  Map<String, dynamic> toJson() => {
        'verses': verses.map((e) => e.toJson()).toList(),
        'theme': theme,
      };

  /// Cria um objeto a partir de JSON
  factory VerseResponse.fromJson(Map<String, dynamic> json) {
    return VerseResponse(
      verses: (json['verses'] as List<dynamic>)
          .map((e) => BibleReference.fromJson(e as Map<String, dynamic>))
          .toList(),
      theme: json['theme'] as String?,
    );
  }
}
