import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:Yatadabaron/modules/domain.module.dart';
import 'package:Yatadabaron/modules/shared-widgets.module.dart';
import 'package:Yatadabaron/repositories/chapters-repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Yatadabaron/presentation/statistics/viewmodel.dart';

class StatisticsForm extends StatelessWidget {
  final StatisticsBloc bloc;
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
            child: FutureBuilder(
              future: ChaptersRepository.instance
                  .getChaptersSimple(includeWholeQuran: true),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ChapterSimpleDTO>> snapshot) {
                if (snapshot.hasData) {
                  List<DropdownMenuItem<int>> menuItems =
                      snapshot.data!.map((ChapterSimpleDTO dto) {
                    return DropdownMenuItem<int>(
                      child: Text(dto.chapterNameAR!),
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
      onPressed: onPressed as void Function()?,
      child: Text(text),
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).primaryColor),
      ),
    );
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

  static void show(BuildContext context, StatisticsBloc bloc) {
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
