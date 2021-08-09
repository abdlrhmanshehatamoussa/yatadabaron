import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:Yatadabaron/presentation/modules/shared-blocs.module.dart';
import 'package:Yatadabaron/presentation/modules/shared.dtos.module.dart';

class ThemeBloc {
  ThemeBloc() {
    updateTheme(
      ThemeDataWrapper(
        Theming.darkTheme(),
        AppTheme.DARK,
      ),
    );
  }

  final CustomStreamController<ThemeDataWrapper> _themeBloc =
      CustomStreamController<ThemeDataWrapper>();

  Stream<ThemeDataWrapper> get stream => _themeBloc.stream;

  void updateTheme(ThemeDataWrapper wrapper) {
    _themeBloc.add(wrapper);
  }
}
