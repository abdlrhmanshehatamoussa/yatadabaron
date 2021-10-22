import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controller.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class StatisticsForm extends StatelessWidget {
  final StatisticsController bloc;
  final StatisticsSettings settings = StatisticsSettings.empty();

  StatisticsForm(this.bloc);

  Widget chapterWidget() {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(Localization.CHAPTER),
            flex: 1,
          ),
          Expanded(
            flex: 1,
            child: FutureBuilder<List<Chapter>>(
              future: bloc.getMushafChapters(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Chapter>> snapshot) {
                if (snapshot.hasData) {
                  List<DropdownMenuItem<int>> menuItems =
                      snapshot.data!.map((Chapter dto) {
                    return DropdownMenuItem<int>(
                      child: Text(dto.chapterNameAR),
                      value: dto.chapterID,
                    );
                  }).toList();
                  return DropdownButtonHideUnderline(
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return DropdownButton<int>(
                          items: menuItems,
                          value: settings.chapterId,
                          onChanged: (int? s) {
                            setState(() {
                              if (s != null) {
                                settings.chapterId = s;
                              }
                            });
                          },
                        );
                      },
                    ),
                  );
                }
                return Center(
                  child: LoadingWidget(),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget basmalaWidget() {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(Localization.BASMALA_MODE),
            flex: 3,
          ),
          Expanded(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Switch(
                  value: settings.basmala,
                  onChanged: (bool val) async {
                    setState(() {
                      settings.basmala = val;
                    });
                  },
                );
              },
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  Widget _customButton(
      {required BuildContext context,
      Function? onPressed,
      required String text}) {
    return ElevatedButton(
        onPressed: onPressed as void Function()?, child: Text(text));
  }

  Widget searchButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: _customButton(
          context: context,
          onPressed: () {
            try {
              this.bloc.changeSettings(settings);
            } catch (e) {
              print("Error: ${e.toString()}");
            }
            Navigator.of(context).pop();
          },
          text: Localization.SEARCH),
    );
  }

  Widget closeButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: _customButton(
          context: context,
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: Localization.CLOSE),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          chapterWidget(),
          Divider(),
          basmalaWidget(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[searchButton(context), closeButton(context)],
          )
        ],
      ),
      scrollDirection: Axis.vertical,
    );
  }

  static void show(BuildContext context, StatisticsController bloc) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: StatisticsForm(bloc),
            )
          ],
        );
      },
    );
  }
}
