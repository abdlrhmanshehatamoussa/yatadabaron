import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/commons/localization.dart';

class TafseerSection extends StatelessWidget {
  final String? tafseer;
  final int tafseerSourceID;
  final Function(int sourceId) onDownloadSource;
  final Future<int> getTafseerSize;

  TafseerSection({
    required this.tafseerSourceID,
    required this.tafseer,
    required this.onDownloadSource,
    required this.getTafseerSize,
  });

  @override
  Widget build(BuildContext context) {
    if (tafseer != null) {
      return Container(
        padding: EdgeInsets.all(15),
        child: SelectableText(
          tafseer!,
          style: TextStyle(fontSize: 17, fontFamily: 'Arial'),
        ),
      );
    } else {
      return ListTile(
        title: Text(
          Localization.DOWNLOAD_TRANSLATION_FIRST,
        ),
        subtitle: FutureBuilder<int>(
          future: getTafseerSize,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String message = Localization.CLICK_TO_DOWNLOAD_TAFSEER;
              if (snapshot.data! > 0) {
                String size =
                    Utils.convertToArabiNumber(snapshot.data, reverse: false);
                message +=
                    " " + Localization.MEGA_BYTES.replaceFirst("%", size);
              }
              return Text(
                message,
                style: TextStyle(fontFamily: 'Arial'),
              );
            }
            return Container();
          },
        ),
        trailing: Icon(Icons.file_download),
        onTap: () => this.onDownloadSource(tafseerSourceID),
      );
    }
  }
}
