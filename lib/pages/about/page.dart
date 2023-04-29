import 'package:simply/simply.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/pages/_widgets/module.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/service_contracts/i_version_info_service.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> statements = [
      Localization.APP_DESCRIPTION,
      Localization.MUSHAF_DESCRIPTION,
      Localization.TAFSEER_ABOUT,
      Localization.QURAN_AUDIO_SOURCE,
      (Localization.VERSION_BUILD_ID).replaceFirst(
        "#",
        Simply.get<IVersionInfoService>().getBuildId(),
      ),
    ];
    return CustomPageWrapper(
      pageTitle: Localization.ABOUT,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: ListView.separated(
            itemBuilder: (_, int i) {
              return SelectableText(
                "- ${statements[i]}",
                style: TextStyle(fontSize: 18),
              );
            },
            separatorBuilder: (_, __) {
              return Divider(
                height: 10,
                color: Theme.of(context).colorScheme.secondary,
              );
            },
            itemCount: statements.length,
          ),
        ),
      ),
      floatingButton: null,
    );
  }
}
