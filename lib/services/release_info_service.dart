import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/models/module.dart';
import 'interfaces/i_release_info_service.dart';

class ReleaseInfoService extends IReleaseInfoService {
  final SharedPreferences preferences;

  ReleaseInfoService({
    required this.preferences,
  });

  @override
  Future<List<ReleaseInfo>> getReleases() async {
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
}
