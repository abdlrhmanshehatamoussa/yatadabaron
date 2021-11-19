import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/widgets/module.dart';

class SearchFormBackend {
  KeywordSearchSettings settings = KeywordSearchSettings.empty();
  void updateKeyword(String newKeyword) {
    settings = settings.copyWithKeyword(newKeyword);
  }

  void updateBasmala(bool newBasmala) {
    settings = settings.copyWithBasmala(newBasmala);
  }

  void updateChapterId(int newChapterId) {
    settings = settings.copyWithChapterId(newChapterId);
  }

  void updateMode(SearchMode newMode) {
    settings = settings.copyWithMode(newMode);
  }

  void updateWholeQuran(bool wholeQuran) {
    settings = settings.copyWithWholeQuran(wholeQuran);
  }
}

class SearchForm extends StatelessWidget {
  SearchForm({
    required this.chaptersFuture,
    required this.onSearch,
  });

  final Future<List<Chapter>> chaptersFuture;
  final Function(KeywordSearchSettings settings) onSearch;
  final SearchFormBackend backend = SearchFormBackend();
  final TextEditingController keywordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    keywordController.addListener(() {
      backend.updateKeyword(keywordController.text);
    });
    return SingleChildScrollView(
      child: StatefulBuilder(
        builder: (_, setState) {
          bool wholeQuran = backend.settings.searchInWholeQuran;
          return Column(
            children: <Widget>[
              searchKeywordWidget(),
              Divider(),
              searchModeWidget(),
              Divider(),
              searchInQuranWidget(
                value: wholeQuran,
                onChanged: (bool v) {
                  setState(() {
                    backend.updateWholeQuran(v);
                  });
                },
              ),
              wholeQuran ? Container() : chapterWidget(),
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
          );
        },
      ),
      scrollDirection: Axis.vertical,
    );
  }

  static Future show({
    required BuildContext context,
    required Future<List<Chapter>> chaptersFuture,
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
                chaptersFuture: chaptersFuture,
              ),
            )
          ],
        );
      },
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
        child: StatefulBuilder(
          builder: (_, setState) {
            return DropdownButton<SearchMode>(
              items: menuItems,
              value: backend.settings.mode,
              onChanged: (SearchMode? s) {
                setState(() {
                  if (s != null) {
                    backend.updateMode(s);
                  }
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget chapterWidget() {
    return CustomFutureBuilder(
      future: chaptersFuture,
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
            child: StatefulBuilder(
              builder: (context, setState) {
                return DropdownButton<int>(
                  items: menuItems,
                  value: backend.settings.chapterID,
                  onChanged: (int? s) {
                    setState(() {
                      if (s != null) {
                        backend.updateChapterId(s);
                      }
                    });
                  },
                );
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
            value: backend.settings.basmala,
            onChanged: (bool val) async {
              setState(() {
                backend.updateBasmala(val);
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
      title: Text(Localization.WHOLE_QURAN),
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
            this.onSearch(backend.settings);
          } catch (e) {}
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
