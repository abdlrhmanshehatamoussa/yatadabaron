import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/mushaf-bloc.dart';
import '../../dtos/verse-dto.dart';
import '../../helpers/localization.dart';
import '../../helpers/utils.dart';
import '../../views/shared-widgets/loading-widget.dart';

class VerseList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    MushafBloc mushafBloc = Provider.of<MushafBloc>(context); 
    return StreamBuilder<List<VerseDTO>>(
      stream: mushafBloc.versesStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<VerseDTO>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        }
        List<VerseDTO> results = snapshot.data;
        if (results.length == 0) {
          return Center(
            child: Text(Localization.EMPTY_SEARCH_RESULTS,style: Utils.emptyListStyle(),),
          );
        }

        return ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
          itemCount: results.length,
          itemBuilder: (BuildContext context, int i) {
            VerseDTO result = results[i];
            String body = "${result.verseTextTashkel}";
            return ListTile(
              title: Text(
                body,
                style: TextStyle(fontWeight: FontWeight.w200,fontSize: 18),
              ),
              leading: Text("${result.verseID}"),
            );
          },
        );
      },
    );
  }

}