import 'package:share_plus/share_plus.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';

class ShareService extends IShareService {
  @override
  Future<void> share(String textToShare) async {
    await Share.share(textToShare);
  }
}
