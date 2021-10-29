import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'interfaces/i_release_info_service.dart';

class ReleaseInfoService extends IReleaseInfoService {
  final SharedPreferences preferences;
  final AppSettings appSettings;
  final PackageInfo packageInfo;

  ReleaseInfoService({
    required this.preferences,
    required this.packageInfo,
    required this.appSettings,
  });

  @override
  Future<List<ReleaseInfo>> getReleases() async {
    return [
      ReleaseInfo(
        releaseDate: DateTime.parse("2021-10-29"),
        major: 6,
        minor: 7,
        build: 4,
        releaseNotes:
            "تم اضافة الصفحة الرئيسية وصفحة المرجعيات",
      ),
      ReleaseInfo(
        releaseDate: DateTime.parse("2021-08-23"),
        major: 6,
        minor: 7,
        build: 3,
        releaseNotes:
            "تم اضافة خاصية تحميل التفاسير - يمكنك الضغط علي الآية وستظهر لك التفاسير المتاحة يمكنك الاختيار بينها وتحميلها - لابد من اتصالك بالانترنت لتتمكن من التحميل",
      ),
      ReleaseInfo(
        releaseDate: DateTime.parse("2021-08-11"),
        minor: 6,
        major: 6,
        build: 9,
        releaseNotes:
            "تم اضافة خاصية الوضع الليلي - بحيث تتغير جميع الالوان في التطبيق بشكل مريح أكثر للعين في حالات الإضاءة المنخفضة - كما يمكن أيضاً العودة للوضع العادي",
      ),
    ];
  }

  @override
  String getCurrentVersion() {
    return this.packageInfo.version;
  }
}
