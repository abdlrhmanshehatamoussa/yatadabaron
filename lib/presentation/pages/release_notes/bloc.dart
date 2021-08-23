import './dtos/release_info.dart';

class NewFeaturesPageBloc {
  Future<List<ReleaseInfo>> getVersions() async {
    //TODO: This should be separated into a service and come from a remote service (My be it should be cahced)
    return [
      ReleaseInfo(
        name: "6.7.3",
        buildNumber: 37,
        description: "تم اضافة خاصية تحميل التفاسير - يمكنك الضغط علي الآية وستظهر لك التفاسير المتاحة يمكنك الاختيار بينها وتحميلها - لابد من اتصالك بالانترنت لتتمكن من التحميل"
      ),
      ReleaseInfo(
        name: "6.6.9",
        buildNumber: 33,
        description: "تم اضافة خاصية الوضع الليلي - بحيث تتغير جميع الالوان في التطبيق بشكل مريح أكثر للعين في حالات الإضاءة المنخفضة - كما يمكن أيضاً العودة للوضع العادي"
      )
    ];
  }
}
