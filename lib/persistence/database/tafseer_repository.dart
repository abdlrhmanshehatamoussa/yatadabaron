import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yatadabaron/modules/domain.module.dart';

class TafseerRepository {
  static TafseerRepository instance = TafseerRepository._();

  TafseerRepository._();

  static const String _TAFSEER_DIRECTORY_NAME = "tafseer";
  static const String _TAFSEER_NAMES_FILE_NAME = "tafseer_names.csv";

  Future<TafseerResultDTO> getTafseer({
    required int chapterId,
    required int verseId,
    required int tafseerId,
  }) async {
    String? tafseerText;
    File? tafseerTextFile =
        await _getTafseerFile("$chapterId.$verseId.$tafseerId.txt");
    if (tafseerTextFile != null) {
      tafseerText = await tafseerTextFile.readAsString();
    }
    TafseerResultDTO dto = TafseerResultDTO(
      tafseerText: tafseerText,
      tafseerID: tafseerId,
    );
    return dto;
  }

  Future<File?> _getTafseerFile(String name) async {
    Directory parentDirectory = await getApplicationDocumentsDirectory();
    String tafseerNamesPath =
        join(parentDirectory.path, _TAFSEER_DIRECTORY_NAME, name);
    File tafseerNamesFile = File(tafseerNamesPath);
    bool tafseerNameFileExist = await tafseerNamesFile.exists();
    if (tafseerNameFileExist) {
      return tafseerNamesFile;
    }
    return null;
  }

  Future<List<TafseerDTO>> getAvailableTafseers() async {
    List<TafseerDTO> results = [];
    File? tafseerNamesFile = await _getTafseerFile(_TAFSEER_NAMES_FILE_NAME);
    if (tafseerNamesFile != null) {
      List<String> lines = await tafseerNamesFile.readAsLines();
      for (String line in lines) {
        List<String> parts = line.split(",");
        int? tafseerId = int.tryParse(parts[0]);
        if (tafseerId != null) {
          TafseerDTO dto = TafseerDTO(
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
}
