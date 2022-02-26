import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:yatadabaron/commons/api_helper.dart';
import 'package:yatadabaron/commons/file_helper.dart';
import 'package:yatadabaron/main_app/services/module.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/services/module.dart';

class TafseerSourcesService implements ITafseerSourcesService, ISimpleService {
  TafseerSourcesService({required this.apiHelper, required this.localRepo});
  final CloudHubAPIHelper apiHelper;
  final ILocalRepository<TafseerSource> localRepo;
  final String _tafseerSourcesFileName = "tafseer_sources.csv";

  // Future<List<TafseerSource>> _fetch() async {
  //   List<TafseerSource> results = [];
  //   File? tafseerSourcesFile =
  //       await FileHelper.getIfExists(_tafseerSourcesFileName);
  //   if (tafseerSourcesFile != null) {
  //     List<String> lines = await tafseerSourcesFile.readAsLines();
  //     results = _parseString(lines);
  //   }
  //   return results;
  // }

  // Future<void> _addLocal(List<TafseerSource> sources) async {
  //   List<TafseerSource> existing = await _fetch();
  //   List<String> newLines = [];
  //   for (var source in sources) {
  //     if (existing.any((e) => e.tafseerId == source.tafseerId) == false) {
  //       newLines.add(
  //         "${source.tafseerId},${source.tafseerName},${source.tafseerNameEnglish}",
  //       );
  //     }
  //   }
  //   if (newLines.isNotEmpty) {
  //     String content = newLines.join("\n");
  //     File file = await FileHelper.create(_tafseerSourcesFileName);
  //     await file.writeAsString(content, mode: FileMode.append);
  //   }
  // }

  Future<List<TafseerSource>> _sync() async {
    List<TafseerSource> remote = await _getRemote();
    await localRepo.merge(remote);
    List<TafseerSource> local = await localRepo.getAll();
    return local;
  }

  Future<List<TafseerSource>> _getRemote() async {
    try {
      final Response response = await this
          .apiHelper
          .httpGET(endpoint: CloudHubAPIHelper.ENDPOINT_TAFSEER_SOURCES);
      List<dynamic> tafseerSourcesJson = jsonDecode(response.body);
      List<TafseerSource> results = tafseerSourcesJson
          .map((dynamic json) => TafseerSource.fromJsonRemote(json))
          .toList();
      return results;
    } catch (e) {
      return [];
    }
  }

  // List<TafseerSource> _parseString(List<String> lines) {
  //   List<TafseerSource> results = [];
  //   for (String line in lines) {
  //     List<String> parts = line.split(",");
  //     int? tafseerId = int.tryParse(parts[0]);
  //     if (tafseerId != null) {
  //       TafseerSource dto = TafseerSource(
  //         tafseerId: tafseerId,
  //         tafseerName: parts[1],
  //         tafseerNameEnglish: parts[2],
  //       );
  //       results.add(dto);
  //     }
  //   }
  //   return results;
  // }

  @override
  Future<List<TafseerSource>> getTafseerSources() async {
    try {
      List<TafseerSource> local = await localRepo.getAll();
      if (local.isEmpty) {
        local = await _sync();
      }
      return local;
    } catch (e) {
      return [];
    }
  }
}
