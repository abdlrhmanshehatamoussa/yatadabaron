import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/pages/_widgets/module.dart';
import 'package:yatadabaron/models/_module.dart';

class SearchForm extends StatefulWidget {
  SearchForm({
    required this.chaptersFuture,
    required this.onSearch,
    required this.settings,
  });

  final Future<List<Chapter>> chaptersFuture;
  final KeywordSearchSettings settings;
  final Function(KeywordSearchSettings settings) onSearch;

  @override
  State<StatefulWidget> createState() => _State();

  static Future show({
    required BuildContext context,
    required Future<List<Chapter>> chaptersFuture,
    required KeywordSearchSettings settings,
    required Function(KeywordSearchSettings settings) onSearch,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: SearchForm(
                onSearch: onSearch,
                settings: settings,
                chaptersFuture: chaptersFuture,
              ),
            )
          ],
        );
      },
    );
  }
}

class _State extends State<SearchForm> {
  late KeywordSearchSettings settings = widget.settings;
  late TextEditingController keywordController = TextEditingController(
    text: settings.keyword,
  );
  @override
  Widget build(BuildContext context) {
    keywordController.addListener(() {
      setState(() {
        settings = settings.updateKeyword(keywordController.text);
      });
    });
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          searchKeywordWidget(),
          Divider(),
          searchModeWidget(),
          Divider(),
          searchInQuranWidget(
            value: settings.searchInWholeQuran,
            onChanged: (bool v) {
              setState(() {
                if (v) {
                  settings = settings.updateChapterId(null);
                } else {
                  settings = settings.updateChapterId(1);
                }
                FocusScope.of(context).unfocus();
              });
            },
          ),
          settings.searchInWholeQuran ? Container() : chapterWidget(),
          Divider(),
          basmalaWidget(),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              searchButton(context),
              closeButton(context),
            ],
          )
        ],
      ),
      scrollDirection: Axis.vertical,
    );
  }

  Widget searchKeywordWidget() {
    return TextField(
      controller: keywordController,
      autofocus: false,
      decoration: InputDecoration(
        suffix: Icon(Icons.search),
        hintText: Localization.ENTER_SEARCH_KEYWORD,
        labelText: Localization.ENTER_SEARCH_KEYWORD,
      ),
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
    return ListTile(
      title: Text(Localization.SEARCH_MODE),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<SearchMode>(
          items: menuItems,
          value: settings.mode,
          onChanged: (SearchMode? s) {
            setState(() {
              if (s != null) {
                settings = settings.updateMode(s);
              }
              FocusScope.of(context).unfocus();
            });
          },
        ),
      ),
    );
  }

  Widget chapterWidget() {
    return CustomFutureBuilder(
      future: widget.chaptersFuture,
      loading: LoadingWidget(),
      done: (List<Chapter> chapters) {
        List<DropdownMenuItem<int>> menuItems = chapters.map((Chapter chapter) {
          return DropdownMenuItem<int>(
            child: Text(chapter.chapterNameAR),
            value: chapter.chapterID,
          );
        }).toList();
        return ListTile(
          title: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              items: menuItems,
              value: settings.chapterID,
              onChanged: (int? s) {
                setState(() {
                  if (s != null) {
                    settings = settings.updateChapterId(s);
                  }
                  FocusScope.of(context).unfocus();
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget basmalaWidget() {
    return ListTile(
      title: Text(Localization.BASMALA_MODE),
      trailing: StatefulBuilder(
        builder: (context, setState) {
          return Switch(
            value: settings.basmala,
            onChanged: (bool val) async {
              setState(() {
                settings = settings.updateBasmala(val);
                FocusScope.of(context).unfocus();
              });
            },
          );
        },
      ),
    );
  }

  Widget searchInQuranWidget({
    required bool value,
    required Function(bool v) onChanged,
  }) {
    return ListTile(
      title: Text(Localization.SEARCH_IN_WHOLE_QURAN),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _customButton({
    required BuildContext context,
    required Function onTap,
    required String text,
  }) {
    return ElevatedButton(
      onPressed: () async {
        await onTap();
      },
      child: Text(text),
    );
  }

  Widget searchButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: _customButton(
        context: context,
        onTap: () async {
          try {
            await widget.onSearch(settings);
          } catch (e) {
            print(e);
          }
          Navigator.of(context).pop();
        },
        text: Localization.SEARCH,
      ),
    );
  }

  Widget closeButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: _customButton(
          context: context,
          onTap: () {
            Navigator.of(context).pop();
          },
          text: Localization.CLOSE),
    );
  }
}
