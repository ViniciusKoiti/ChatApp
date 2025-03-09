/// Classe que representa uma referência bíblica
class BibleReference {
  /// Referência do versículo (ex: "João 3:16")
  final String verse;

  /// Texto do versículo
  final String text;

  /// Construtor
  BibleReference({
    required this.verse,
    required this.text,
  });

  /// Converte o objeto para JSON
  Map<String, dynamic> toJson() => {
        'verse': verse,
        'text': text,
      };

  /// Cria um objeto a partir de JSON
  factory BibleReference.fromJson(Map<String, dynamic> json) {
    return BibleReference(
      verse: json['verse'] as String,
      text: json['text'] as String,
    );
  }
}
