import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/commons/arabic-numbers-service.dart';
import 'package:yatadabaron/commons/localization.dart';
import '../controller.dart';

class TafseerSection extends StatelessWidget {
  final String? tafseer;
  final int tafseerSourceID;

  TafseerSection({
    required this.tafseerSourceID,
    required this.tafseer,
  });

  @override
  Widget build(BuildContext context) {
    //TODO: Remove dependency on controller and pass direct parameters to the widget
    TafseerPageController bloc = Provider.of(context);
    if (tafseer != null) {
      return Container(
        padding: EdgeInsets.all(15),
        child: Text(
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
          future: bloc.getTafseerSizeMB(tafseerSourceID),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String message = Localization.CLICK_TO_DOWNLOAD_TAFSEER;
              if (snapshot.data! > 0) {
                String size = ArabicNumbersService.instance
                    .convert(snapshot.data, reverse: false);
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
        onTap: () async {
          bloc.downloadTafseerSource(tafseerSourceID, context);
        },
      );
    }
  }
}
