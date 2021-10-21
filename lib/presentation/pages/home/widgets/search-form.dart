import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/presentation/modules/shared-widgets.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controller.dart';
import '../view_models/search-settings.dart';

class SearchForm extends StatelessWidget {
  final SearchSessionController bloc;
  final SearchSettings settings = SearchSettings.empty();
  final TextEditingController keywordController = TextEditingController();

  SearchForm(this.bloc);

  Widget searchKeywordWidget() {
    return TextField(
      controller: keywordController,
      autofocus: false,
      decoration: InputDecoration(
          suffix: Icon(Icons.search),
          hintText: Localization.ENTER_SEARCH_KEYWORD,
          labelText: Localization.ENTER_SEARCH_KEYWORD),
    );
  }

  Widget searchModeWidget() {
    List<DropdownMenuItem<SearchMode>> menuItems =
        SearchMode.values.map((SearchMode m) {
      return DropdownMenuItem<SearchMode>(
        child: Text(m.name!),
        value: m,
      );
    }).toList();

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(Localization.SEARCH_MODE),
            flex: 1,
          ),
          Expanded(
            flex: 1,
            child: DropdownButtonHideUnderline(
              child: StatefulBuilder(
                builder: (_, setState) {
                  return DropdownButton<SearchMode>(
                    items: menuItems,
                    value: settings.mode,
                    onChanged: (SearchMode? s) {
                      setState(() {
                        if (s != null) {
                          settings.mode = s;
                        }
                      });
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

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
                          value: settings.chapterID,
                          onChanged: (int? s) {
                            setState(() {
                              if (s != null) {
                                settings.chapterID = s;
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
          onPressed: () async {
            try {
              this.bloc.changeSettings(settings);
            } catch (e) {}
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
    keywordController.addListener(() {
      settings.keyword = keywordController.text;
    });
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          searchKeywordWidget(),
          Divider(),
          chapterWidget(),
          Divider(),
          searchModeWidget(),
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

  static void show(BuildContext context, SearchSessionController bloc) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: SearchForm(bloc),
            )
          ],
        );
      },
    );
  }
}
