import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/domain/models/release_info.dart';
import 'package:yatadabaron/modules/application.module.dart';

class ReleaseInfoRepository extends IReleaseInfoRepository {
  final SharedPreferences preferences;

  ReleaseInfoRepository({required this.preferences});

  @override
  Future<List<ReleaseInfo>> getLocal() async {
    return [
      ReleaseInfo(
          name: "6.7.3",
          buildNumber: 37,
          description:
              "تم اضافة خاصية تحميل التفاسير - يمكنك الضغط علي الآية وستظهر لك التفاسير المتاحة يمكنك الاختيار بينها وتحميلها - لابد من اتصالك بالانترنت لتتمكن من التحميل"),
      ReleaseInfo(
          name: "6.6.9",
          buildNumber: 33,
          description:
              "تم اضافة خاصية الوضع الليلي - بحيث تتغير جميع الالوان في التطبيق بشكل مريح أكثر للعين في حالات الإضاءة المنخفضة - كما يمكن أيضاً العودة للوضع العادي")
    ];
  }

  @override
  Future<List<ReleaseInfo>> getRemote() {
    // TODO: implement getRemote
    throw UnimplementedError();
  }

  @override
  Future<void> setLocal() {
    // TODO: implement setLocal
    throw UnimplementedError();
  }
}
