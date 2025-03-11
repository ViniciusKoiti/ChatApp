import 'dart:math';

import 'package:jesusapp/services/api/interfaces/i_verse_service.dart';

class Verse {
  final String text;
  final String reference;

  Verse({required this.text, required this.reference});
}

class MockVerseService implements IVerseService {
  static final List<Verse> _verses = [
    Verse(
      text:
          "Porque Deus amou o mundo de tal maneira que deu o seu Filho unigênito, para que todo aquele que nele crê não pereça, mas tenha a vida eterna.",
      reference: "João 3:16",
    ),
    Verse(
      text:
          "Eu sou o caminho, a verdade e a vida. Ninguém vem ao Pai, a não ser por mim.",
      reference: "João 14:6",
    ),
    Verse(
      text: "Tudo posso naquele que me fortalece.",
      reference: "Filipenses 4:13",
    ),
    Verse(
      text: "O Senhor é o meu pastor, nada me faltará.",
      reference: "Salmos 23:1",
    ),
    Verse(
      text:
          "Não temas, porque eu sou contigo; não te assombres, porque eu sou teu Deus; eu te fortaleço, e te ajudo, e te sustento com a destra da minha justiça.",
      reference: "Isaías 41:10",
    ),
    Verse(
      text:
          "Confie no Senhor de todo o seu coração e não se apoie em seu próprio entendimento.",
      reference: "Provérbios 3:5",
    ),
    Verse(
      text:
          "Porque eu bem sei os pensamentos que tenho a vosso respeito, diz o Senhor; pensamentos de paz, e não de mal, para vos dar o fim que esperais.",
      reference: "Jeremias 29:11",
    ),
    Verse(
      text: "E conhecereis a verdade, e a verdade vos libertará.",
      reference: "João 8:32",
    ),
    Verse(
      text:
          "Mas os que esperam no Senhor renovarão as forças, subirão com asas como águias; correrão, e não se cansarão; caminharão, e não se fatigarão.",
      reference: "Isaías 40:31",
    ),
    Verse(
      text:
          "Não se turbe o vosso coração; credes em Deus, crede também em mim.",
      reference: "João 14:1",
    ),
    Verse(
      text:
          "Buscai primeiro o reino de Deus, e a sua justiça, e todas estas coisas vos serão acrescentadas.",
      reference: "Mateus 6:33",
    ),
    Verse(
      text:
          "Vinde a mim, todos os que estais cansados e oprimidos, e eu vos aliviarei.",
      reference: "Mateus 11:28",
    ),
    Verse(
      text:
          "Porque o salário do pecado é a morte, mas o dom gratuito de Deus é a vida eterna em Cristo Jesus, nosso Senhor.",
      reference: "Romanos 6:23",
    ),
    Verse(
      text:
          "Portanto, agora nenhuma condenação há para os que estão em Cristo Jesus.",
      reference: "Romanos 8:1",
    ),
    Verse(
      text:
          "Sabemos que todas as coisas cooperam para o bem daqueles que amam a Deus, daqueles que são chamados segundo o seu propósito.",
      reference: "Romanos 8:28",
    ),
  ];

  /// Retorna um versículo aleatório da lista
  @override
  Future<Verse> getRandomVerse() async {
    final random = Random();
    return _verses[random.nextInt(_verses.length)];
  }

  /// Retorna um versículo específico pelo índice
  @override
  Future<Verse> getVerseByIndex(int index) async {
    if (index < 0 || index >= _verses.length) {
      throw ArgumentError('Índice fora dos limites');
    }
    return _verses[index];
  }

  /// Retorna todos os versículos
  Future<List<Verse>> getAllVerses() async {
    return List.from(_verses);
  }

  /// Busca versículos que contenham o texto fornecido
  Future<List<Verse>> searchVerses(String query) async {
    final lowercaseQuery = query.toLowerCase();
    return _verses.where((verse) {
      return verse.text.toLowerCase().contains(lowercaseQuery) ||
          verse.reference.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
