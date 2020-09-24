import '../dtos/verse-dto.dart';

class VerseCollection{
  final List<VerseDTO> verses;
  final String collectionName;

  VerseCollection(this.verses, this.collectionName);
}