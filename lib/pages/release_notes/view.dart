import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/release_notes/backend.dart';
import 'package:yatadabaron/pages/_widgets/module.dart';

class ReleaseNotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ReleaseNotesBackend backend = ReleaseNotesBackend(context);
    String currentVersion = backend.getVersionName();
    return CustomPageWrapper(
      pageTitle: Localization.RELEASE_NOTES,
      child: Container(
        padding: EdgeInsets.all(5),
        child: Center(
          child: FutureBuilder<List<ReleaseInfo>>(
            future: backend.getVersions(),
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
                      release.releaseName,
                    ];
                    String fullName = parts.join(" : ");
                    bool isCurrent = release.releaseName == currentVersion;
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
          await backend.syncReleases();
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
