import 'package:Yatadabaron/services/analytics-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../blocs/search-session-bloc.dart';
import '../../dtos/chapter-simple-dto.dart';
import '../../dtos/search-settings.dart';
import '../../enums/enums.dart';
import '../../repositories/chapters-repository.dart';
import '../../helpers/localization.dart';
import '../../helpers/extensions.dart';
import '../../views/shared-widgets/loading-widget.dart';

class SearchForm extends StatelessWidget {
  final SearchSessionBloc bloc;
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
                    // AnalyticsHelper.instance.logEvent(
                    //     EventTypes.SEARCH_PAGE_BASMALA + "-" + val.toString());
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
              AnalyticsService.instance.logFormFilled("SEARCH FORM",
                  payload:
                      "KEYWORD=${settings.keyword}|MODE=${describeEnum(settings.mode)}|LOCATION=${settings.chapterID}|BASMALA=${settings.basmala}");
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

  static void show(BuildContext context, SearchSessionBloc bloc) {
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
