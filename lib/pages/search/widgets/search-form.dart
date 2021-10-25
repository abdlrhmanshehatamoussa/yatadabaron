import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/widgets/module.dart';

class SearchForm extends StatelessWidget {
  final Future<List<Chapter>> chaptersFuture;
  final Function(SearchSettings settings) onSearch;
  final SearchSettings settings = SearchSettings.empty();
  final TextEditingController keywordController = TextEditingController();

  SearchForm({
    required this.chaptersFuture,
    required this.onSearch,
  });

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
              future: this.chaptersFuture,
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
            this.onSearch(settings);
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

  static Future show({
    required BuildContext context,
    required Future<List<Chapter>> chaptersFuture,
    required Function(SearchSettings settings) onSearch,
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
}
