import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import 'package:flutter/cupertino.dart';
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

  static Future<void> show({
    required BuildContext context,
    required void Function(BasicSearchSettings) onFormSubmit,
    required Future<List<Chapter>> chaptersFuture,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: StatisticsForm(
                chaptersFuture: chaptersFuture,
                onFormSubmit: onFormSubmit,
              ),
            )
          ],
        );
      },
    );
  }
}

class _State extends State<StatisticsForm> {
  BasicSearchSettings settings = BasicSearchSettings.empty();

  Widget chapterWidget({
    required Future<List<Chapter>> chaptersFuture,
    required void Function(int?) onChanged,
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
                value: settings.chapterId,
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

  Widget _customButton(
      {required BuildContext context,
      Function? onPressed,
      required String text}) {
    return ElevatedButton(
        onPressed: onPressed as void Function()?, child: Text(text));
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
          _switch(
            title: Localization.WHOLE_QURAN,
            value: settings.searchWholeQuran,
            onChanged: (bool whole) {
              setState(() {
                settings = settings.copyWithWholeQuran(whole);
              });
            },
          ),
          chapterWidget(
            chaptersFuture: widget.chaptersFuture,
            onChanged: (int? id) {
              if (id != null) {
                settings = settings.copyWithChapterId(id);
              }
            },
          ),
          Divider(),
          _switch(
            title: Localization.BASMALA_MODE,
            value: settings.basmala,
            onChanged: (bool basmala) {
              setState(() {
                settings = settings.copyWithBasmala(basmala);
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: _customButton(
                    context: context,
                    onPressed: () {
                      widget.onFormSubmit(settings);
                      Navigator.of(context).pop();
                    },
                    text: Localization.SEARCH),
              ),
              closeButton(context),
            ],
          )
        ],
      ),
      scrollDirection: Axis.vertical,
    );
  }
}
