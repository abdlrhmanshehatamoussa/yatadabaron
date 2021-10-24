import 'package:flutter/material.dart';
import 'package:yatadabaron/app/page_manager.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/commons/base_view.dart';
import 'package:yatadabaron/pages/release_notes/controller.dart';
import 'package:yatadabaron/widgets/module.dart';

class ReleaseNotesPage extends BaseView<ReleaseNotesController> {
  ReleaseNotesPage(ReleaseNotesController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    return CustomPageWrapper(
      drawer: PageManager.instance.drawer(),
      pageTitle: Localization.RELEASE_NOTES,
      child: Container(
        padding: EdgeInsets.all(5),
        child: Center(
          child: FutureBuilder<List<ReleaseInfo>>(
            future: controller.getVersions(),
            builder: (_, AsyncSnapshot<List<ReleaseInfo>> snapshot) {
              if (snapshot.hasData) {
                List<ReleaseInfo> versions = snapshot.data!;
                return ListView.separated(
                  itemBuilder: (_, int i) {
                    ReleaseInfo version = versions[i];
                    List<String> parts = [
                      Localization.RELEASE_NAME,
                      version.name
                    ];
                    String fullName = parts.join(" : ");
                    return ListTile(
                      title: Text(
                        fullName,
                      ),
                      subtitle: Text(
                        version.description,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) {
                    return Divider(
                      height: 2,
                    );
                  },
                  itemCount: versions.length,
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
      floatingButton: null,
    );
  }
}
