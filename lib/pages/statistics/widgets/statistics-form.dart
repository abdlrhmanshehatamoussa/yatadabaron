import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/pages/_widgets/module.dart';
import 'package:flutter/material.dart';

class StatisticsForm extends StatefulWidget {
  final void Function(BasicSearchSettings) onFormSubmit;
  final Future<List<Chapter>> chaptersFuture;

  const StatisticsForm({
    Key? key,
    required this.onFormSubmit,
    required this.chaptersFuture,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<StatisticsForm> {
  BasicSearchSettings settings = BasicSearchSettings();

  @override
  Widget build(BuildContext context) {
    Widget _chaptersWidget = Container();
    if (settings.wholeQuran == false) {
      _chaptersWidget = chapterWidget(
        chaptersFuture: widget.chaptersFuture,
        value: settings.chapterId,
        onChanged: (int? id) {
          setState(() {
            if (id != null) {
              settings = settings.updateChapterId(id);
            }
          });
        },
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _switch(
            title: Localization.SEARCH_IN_WHOLE_QURAN,
            value: settings.wholeQuran,
            onChanged: (bool whole) {
              setState(() {
                if (whole) {
                  settings = settings.updateChapterId(null);
                } else {
                  settings = settings.updateChapterId(1);
                }
              });
            },
          ),
          _chaptersWidget,
          settings.wholeQuran ? Container() : Divider(),
          _switch(
            title: Localization.BASMALA_MODE,
            value: settings.basmala,
            onChanged: (bool basmala) {
              setState(() {
                settings = settings.updateBasmala(basmala);
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: () {
                    widget.onFormSubmit(settings);
                  },
                  child: Text(Localization.SEARCH),
                ),
              ),
            ],
          )
        ],
      ),
      scrollDirection: Axis.vertical,
    );
  }

  Widget chapterWidget({
    required Future<List<Chapter>> chaptersFuture,
    required void Function(int?) onChanged,
    required int? value,
  }) {
    return FutureBuilder<List<Chapter>>(
      future: chaptersFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Chapter>> snapshot) {
        if (snapshot.hasData) {
          List<DropdownMenuItem<int>> menuItems =
              snapshot.data!.map((Chapter dto) {
            return DropdownMenuItem<int>(
              child: Text(dto.chapterNameAR),
              value: dto.chapterID,
            );
          }).toList();
          return ListTile(
            title: Text(Localization.CHAPTER),
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                items: menuItems,
                value: value,
                onChanged: onChanged,
              ),
            ),
          );
        }
        return Center(
          child: LoadingWidget(),
        );
      },
    );
  }

  Widget _switch({
    required bool value,
    required String title,
    required void Function(bool v) onChanged,
  }) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
