import 'package:Yatadabaron/presentation/modules/shared-blocs.module.dart';
import 'package:Yatadabaron/presentation/modules/shared.dtos.module.dart';

class ThemeBloc {
  ThemeBloc() {
    updateTheme(
      ThemeDataWrapper.dark(),
    );
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
