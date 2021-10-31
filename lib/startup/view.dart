import 'package:flutter/material.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/interfaces/i_tafseer_sources_service.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/widgets/loading-widget.dart';

class TestPage3 extends SimpleView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Text("Welcome to page 3"),
        ),
      ),
    );
  }
}

class TestPage2 extends SimpleView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page2"),
      ),
      body: Container(
        child: Center(
          child: Text("Welcome to Page 2"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          navigateReplace(
            context: context,
            view: TestPage3(),
          );
        },
      ),
    );
  }
}

class TestPage extends SimpleView {
  @override
  Widget build(BuildContext context) {
    ITafseerSourcesService service =
        getService<ITafseerSourcesService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome Home"),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder<List<TafseerSource>>(
            future: service.getTafseerSources(),
            builder: (_, var snapshot) {
              if (!snapshot.hasData) {
                return LoadingWidget();
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, int index) {
                    return ListTile(
                      title: Text(snapshot.data![index].tafseerName),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.exit_to_app),
        onPressed: () {
          navigatePush(
            context: context,
            view: TestPage2(),
          );
        },
      ),
    );
  }
}
