import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';

class MushafTypeService implements IMushafTypeService {
  @override
  MushafType getMushafType() {
    return MushafType.HAFS;
  }

  @override
  Future<void> saveMushafType(MushafType mushafType) async {
    return;
  }
}
