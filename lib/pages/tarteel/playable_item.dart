import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/service_contracts/i_verses_service.dart';

class TarteelPlayableItem {
  final String verseText;
  final int verseId;
  final int order;
  final String chapterName;
  final String audioUrl;
  final String imageUrl;

  TarteelPlayableItem({
    required this.order,
    required this.verseText,
    required this.verseId,
    required this.chapterName,
    required this.audioUrl,
    required this.imageUrl,
  });
  static Future<List<TarteelPlayableItem>> mock(
    String reciterName,
    int chapterId,
    int start,
    int end,
  ) async {
    var result = <TarteelPlayableItem>[];
    var service = Simply.get<IVersesService>();
    var verses = await service.getVersesByChapterId(chapterId, false);
    verses = verses
        .where((element) => element.verseID >= start && element.verseID <= end)
        .toList();
    for (var i = 0; i < verses.length; i++) {
      var verse = verses[i];
      var verseIndex = verse.verseID.toString().padLeft(3, '0');
      var chapterIndex = chapterId.toString().padLeft(3, '0');
      result.add(
        TarteelPlayableItem(
          order: i,
          verseText: verse.verseTextTashkel +
              " " +
              ArabicNumbers().convert(verse.verseID.toString()),
          verseId: verse.verseID,
          chapterName: verse.chapterName ?? "",
          audioUrl:
              "https://everyayah.com/data/$reciterName/$chapterIndex$verseIndex.mp3",
          imageUrl:
              "https://everyayah.com/data/images_png/${chapterId}_${verse.verseID}.png",
        ),
      );
    }
    return result;
  }
}
