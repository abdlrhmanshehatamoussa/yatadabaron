import 'package:yatadabaron/application/service-manager.dart';
import 'package:yatadabaron/presentation/modules/controllers.module.dart';
import 'package:yatadabaron/presentation/modules/viewmodels.module.dart';

class ThemeController {
  ThemeController() {
    _initializae();
  }

  Future _initializae() async {
    bool? isNightMode =
        await ServiceManager.instance.userDataService.getNightMode();
    switch (isNightMode) {
      case null:
      case true:
        updateTheme(ThemeDataWrapper.dark());
        break;
      case false:
        updateTheme(ThemeDataWrapper.light());
        break;
      default:
    }
  }

  final CustomStreamController<ThemeDataWrapper> _themeBloc =
      CustomStreamController<ThemeDataWrapper>();

  ThemeDataWrapper? currentTheme;

  Stream<ThemeDataWrapper> get stream => _themeBloc.stream;

  void updateTheme(ThemeDataWrapper wrapper) {
    currentTheme = wrapper;
    _themeBloc.add(wrapper);
  }
}
