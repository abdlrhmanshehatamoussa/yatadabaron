import 'package:yatadabaron/_modules/models.module.dart';

abstract class IMushafTypeService {
  Future<void> saveMushafType(MushafType mushafType);
  MushafType getMushafType();
}
