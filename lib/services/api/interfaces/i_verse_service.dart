import 'package:jesusapp/services/api/mock/mock_verse_service.dart';

abstract class IVerseService {
  Future<Verse> getRandomVerse();
  Future<Verse> getVerseByIndex(int index);
  Future<List<Verse>> getAllVerses();
  Future<List<Verse>> searchVerses(String query);
}
