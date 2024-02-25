import 'package:hive/hive.dart';

class ThemePreference {
  static const _boxName = 'themeBox';
  static const _themeKey = 'theme';

  static Future<void> setTheme(bool isDark) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_themeKey, isDark);
  }

  static Future<bool> getTheme() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_themeKey, defaultValue: false);
  }
}
