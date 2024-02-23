import 'package:yatadabaron/_modules/models.module.dart';

abstract class ITarteelService {
  List<String> getReciterKeys(MushafType mushafType);
  String getReciterName(String reciterKey);
  String? getCachedReciterKey(MushafType mushafType);
  Future<void> setCachedReciterKey(String reciterKey, MushafType mushafType);
}
