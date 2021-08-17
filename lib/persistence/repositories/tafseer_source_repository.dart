import 'dart:io';
import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';

abstract class ITafseerSourceRepository {
  Future<void> sync();
  Future<List<TafseerSource>> getAll();
}

class TafseerSourceRepository implements ITafseerSourceRepository {
  TafseerSourceRepository._();

  static TafseerSourceRepository instance = TafseerSourceRepository._();

  String get _directoryName => "tafseer";
  String get _tafseerSourcesFileName => "$_directoryName/tafseer_sources.csv";

  @override
  Future<List<TafseerSource>> getAll() async {
    List<TafseerSource> results = [];
    File? tafseerSourcesFile = await Utils.getFile(_tafseerSourcesFileName);
    if (tafseerSourcesFile != null) {
      List<String> lines = await tafseerSourcesFile.readAsLines();
      for (String line in lines) {
        List<String> parts = line.split(",");
        int? tafseerId = int.tryParse(parts[0]);
        if (tafseerId != null) {
          TafseerSource dto = TafseerSource(
            tafseerId: tafseerId,
            tafseerName: parts[1],
            tafseerNameEnglish: parts[2],
          );
          results.add(dto);
        }
      }
    }
    return results;
  }

  @override
  Future<void> sync() {
    // TODO: implement sync (remote=>local, merge)
    throw UnimplementedError();
  }
}
