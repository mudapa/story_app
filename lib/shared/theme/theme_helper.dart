import '../../data/cubit/theme/theme_cubit.dart';

class ThemeHelper {
  static late ThemeCubit _themeCubit;

  static void init() {
    _themeCubit = ThemeCubit()..loadTheme();
  }

  static ThemeCubit getThemeCubit() {
    return _themeCubit;
  }
}
