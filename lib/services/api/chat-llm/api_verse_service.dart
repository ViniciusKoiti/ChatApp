import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jesusapp/services/api/interfaces/i_verse_service.dart';
import 'package:jesusapp/services/api/mock/mock_verse_service.dart';

class ApiVerseService implements IVerseService {
  final String baseUrl;

  ApiVerseService({required this.baseUrl});

  @override
  Future<Verse> getRandomVerse() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/verses/random'));
      print('Resposta do getRandomVerse: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic decodedResponse = jsonDecode(response.body);

        // Handle the specific structure where verses is an array
        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey('verses') &&
            decodedResponse['verses'] is List &&
            (decodedResponse['verses'] as List).isNotEmpty) {
          final verseData = decodedResponse['verses'][0];
          return Verse(
            text: verseData['text'] ?? '',
            reference: verseData['verse'] ?? '',
          );
        }

        throw Exception('Formato de resposta inesperado: $decodedResponse');
      } else {
        throw Exception(
            'Erro ao buscar versículo aleatório: ${response.statusCode}');
      }
    } catch (e) {
      print('Exceção no getRandomVerse: $e');
      rethrow;
    }
  }

  @override
  Future<Verse> getVerseByIndex(int index) async {
    final response = await http.get(Uri.parse('$baseUrl/verses/$index'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      final Map<String, dynamic> verseData = responseData['verse'];

      return Verse(
        text: verseData['text'],
        reference:
            verseData['verse'], // Usando 'verse' como chave para a referência
      );
    } else {
      throw Exception('Erro ao buscar versículo por índice');
    }
  }

  @override
  Future<List<Verse>> getAllVerses() async {
    final response = await http.get(Uri.parse('$baseUrl/verses'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> versesData = responseData['verses'];

      return versesData
          .map((verse) => Verse(
                text: verse['text'],
                reference: verse['verse'], // Já está usando 'verse' como chave
              ))
          .toList();
    } else {
      throw Exception(
          'Erro ao buscar todos os versículos: ${response.statusCode}');
    }
  }

  @override
  Future<List<Verse>> searchVerses(String query) async {
    final response =
        await http.get(Uri.parse('$baseUrl/verses/search?q=$query'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> versesData = responseData['verses'];

      return versesData
          .map((verse) => Verse(
                text: verse['text'],
                reference: verse[
                    'verse'], // Usando 'verse' como chave para a referência
              ))
          .toList();
    } else {
      throw Exception('Erro ao buscar versículos');
    }
  }
}
