import 'package:jesusapp/models/api/bible_reference.dart';

/// Classe que representa a resposta para orações
class PrayerResponse {
  /// Texto da oração
  final String prayer;

  /// Categoria da oração
  final String category;

  /// Referências bíblicas relacionadas à oração
  final List<BibleReference>? references;

  /// Construtor
  PrayerResponse({
    required this.prayer,
    required this.category,
    this.references,
  });

  /// Converte o objeto para JSON
  Map<String, dynamic> toJson() => {
        'prayer': prayer,
        'category': category,
        'references': references?.map((e) => e.toJson()).toList(),
      };

  /// Cria um objeto a partir de JSON
  factory PrayerResponse.fromJson(Map<String, dynamic> json) {
    return PrayerResponse(
      prayer: json['prayer'] as String,
      category: json['category'] as String,
      references: (json['references'] as List<dynamic>?)
          ?.map((e) => BibleReference.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
