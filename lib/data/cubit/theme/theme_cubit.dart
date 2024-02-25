import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../shared/theme/theme_preference.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(ThemeData.light());

  void toggleTheme() async {
    final currentTheme = state;
    final newTheme = currentTheme.brightness == Brightness.light
        ? ThemeData.dark()
        : ThemeData.light();
    emit(newTheme);
    await ThemePreference.setTheme(newTheme.brightness == Brightness.dark);
  }

  void loadTheme() async {
    final isDark = await ThemePreference.getTheme();
    final themeData = isDark ? ThemeData.dark() : ThemeData.light();
    emit(themeData);
  }
}
