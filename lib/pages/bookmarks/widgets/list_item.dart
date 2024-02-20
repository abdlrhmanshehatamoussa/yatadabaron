import 'package:flutter/material.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/global.dart';

class BookmarkListItem extends StatelessWidget {
  final Bookmark bookmark;
  final Function() onClick;
  final Function() onRemove;

  const BookmarkListItem({
    Key? key,
    required this.bookmark,
    required this.onClick,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final versesService = Simply.get<IVersesService>();
    TextStyle usmaniStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontFamily: Simply.get<IMushafTypeService>().getMushafType().fontName,
      fontSize: 18,
    );
    return FutureBuilder(
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        Verse verse = snapshot.data as Verse;
        return ListTile(
          title: SingleChildScrollView(
            child: Text(
              verse.verseTextTashkel,
              style: TextStyle(
                fontSize: 20,
                overflow: TextOverflow.visible,
              ),
            ),
            scrollDirection: Axis.horizontal,
          ),
          subtitle: SingleChildScrollView(
            child: Text(
              verse.chapterName!,
            ),
            scrollDirection: Axis.horizontal,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.close,
              size: 30,
            ),
            onPressed: () async => await onRemove(),
          ),
          leading: Text(
            verse.verseID.toArabicNumber(),
            style: usmaniStyle.copyWith(fontSize: 32),
          ),
          onTap: () async => await onClick(),
        );
      },
      future:
          versesService.getSingleVerse(bookmark.verseId, bookmark.chapterId),
    );
  }
}
