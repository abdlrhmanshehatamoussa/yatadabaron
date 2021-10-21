import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/presentation/modules/widgets.module.dart';
import 'controller.dart';

class ReleaseNotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ReleaseNotesController bloc = Provider.of<ReleaseNotesController>(context);
    return CustomPageWrapper(
      pageTitle: Localization.RELEASE_NOTES,
      child: Container(
        padding: EdgeInsets.all(5),
        child: Center(
          child: FutureBuilder<List<ReleaseInfo>>(
            future: bloc.getVersions(),
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

  static void pushReplacement(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => Provider(
          child: ReleaseNotesPage(),
          create: (_) => ReleaseNotesController(),
        ),
      ),
    );
  }
}
