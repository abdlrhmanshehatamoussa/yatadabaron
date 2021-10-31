import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/release_notes/controller.dart';
import 'package:yatadabaron/services/interfaces/i_release_info_service.dart';
import 'package:yatadabaron/services/interfaces/module.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/widgets/module.dart';

class ReleaseNotesPage extends SimpleView {
  @override
  Widget build(BuildContext context) {
    IVersionInfoService versionInfoService =
        getService<IVersionInfoService>(context);

    ReleaseNotesController controller = ReleaseNotesController(
      releaseInfoService: getService<IReleaseInfoService>(context),
    );
    String currentVersion = versionInfoService.getVersionName();
    return CustomPageWrapper(
      pageTitle: Localization.RELEASE_NOTES,
      child: Container(
        padding: EdgeInsets.all(5),
        child: Center(
          child: FutureBuilder<List<ReleaseInfo>>(
            future: controller.getVersions(),
            builder: (_, AsyncSnapshot<List<ReleaseInfo>> snapshot) {
              if (snapshot.hasData) {
                List<ReleaseInfo> releases = snapshot.data!;
                if (releases.length == 0) {
                  return Text(Localization.EMPTY_LIST);
                }
                return ListView.separated(
                  itemBuilder: (_, int i) {
                    ReleaseInfo release = releases[i];
                    List<String> parts = [
                      Localization.RELEASE_NAME,
                      release.uniqueId,
                    ];
                    String fullName = parts.join(" : ");
                    bool isCurrent = release.uniqueId == currentVersion;
                    return ListTile(
                      title: Text(
                        fullName,
                      ),
                      subtitle: Text(
                        release.releaseNotes,
                      ),
                      trailing: isCurrent ? Icon(Icons.done) : null,
                    );
                  },
                  separatorBuilder: (_, __) {
                    return Divider(
                      height: 2,
                    );
                  },
                  itemCount: releases.length,
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
      floatingButton: FloatingActionButton(
        onPressed: () async {
          await controller.syncReleases();
          await Utils.showCustomDialog(
            context: context,
            text: "",
            title: Localization.UPDATE_DONE,
          );
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
