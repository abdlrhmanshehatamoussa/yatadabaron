import 'dart:io';
import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:http/http.dart';

abstract class ITafseerSourceRepository {
  Future<void> sync();

  Future<List<TafseerSource>> getLocal();

  Future<void> addLocal(List<TafseerSource> sources);

  Future<List<TafseerSource>> getRemote();
}

class TafseerSourceRepository implements ITafseerSourceRepository {
  final String remoteFileURL;

  TafseerSourceRepository({required this.remoteFileURL});

  String get _tafseerSourcesFileName => "tafseer_sources.csv";

  @override
  Future<List<TafseerSource>> getLocal() async {
    List<TafseerSource> results = [];
    File? tafseerSourcesFile =
        await FileHelper.getIfExists(_tafseerSourcesFileName);
    if (tafseerSourcesFile != null) {
      List<String> lines = await tafseerSourcesFile.readAsLines();
      results = _parseString(lines);
    }
    return results;
  }

  @override
  Future<List<TafseerSource>> getRemote() async {
    Uri uri = Uri.parse(this.remoteFileURL);
    final Response response = await get(uri);
    if ((response.contentLength ?? 0) > 0 && response.body.isNotEmpty) {
      String remoteContext = response.body;
      List<String> lines = remoteContext.split("\n");
      return _parseString(lines);
    }
    return [];
  }

  List<TafseerSource> _parseString(List<String> lines) {
    List<TafseerSource> results = [];
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
    return results;
  }

  @override
  Future<void> sync() async {
    List<TafseerSource> remote = await getRemote();
    List<TafseerSource> local = await getLocal();
    List<TafseerSource> diff = [];
    for (var source in remote) {
      bool exists =
          local.any((TafseerSource s) => s.tafseerId == source.tafseerId);
      if (!exists) {
        diff.add(source);
      }
    }
    await addLocal(diff);
  }

  @override
  Future<void> addLocal(List<TafseerSource> sources) async {
    List<TafseerSource> existing = await getLocal();
    List<String> newLines = [];
    for (var source in sources) {
      if (existing.any((e) => e.tafseerId == source.tafseerId) == false) {
        newLines.add(
          "${source.tafseerId},${source.tafseerName},${source.tafseerNameEnglish}",
        );
      }
    }
    if (newLines.isNotEmpty) {
      String content = newLines.join("\n");
      File file = await FileHelper.create(_tafseerSourcesFileName);
      await file.writeAsString(content, mode: FileMode.append);
    }
  }
}
