import 'package:Yatadabaron/application/service-manager.dart';
import 'package:Yatadabaron/presentation/modules/shared-blocs.module.dart';
import 'package:Yatadabaron/presentation/modules/shared.dtos.module.dart';

class ThemeBloc {
  ThemeBloc() {
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
