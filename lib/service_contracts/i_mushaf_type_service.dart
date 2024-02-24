import 'package:yatadabaron/_modules/models.module.dart';

abstract class IMushafTypeService {
  Future<void> changeMushafType(MushafType mushafType);
  Future<void> toggleMushafType();
  MushafType getMushafType();
}
