import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'data/cubit/localization/localization_cubit.dart';
import 'data/cubit/theme/theme_cubit.dart';
import 'l10n/l10n.dart';
import 'routes/app_routes.dart';
import 'routes/bloc_providers.dart';
import 'shared/theme/theme_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timeago.setLocaleMessages('id', timeago.IdMessages());
  await Hive.initFlutter();
  await Hive.openBox('settings');
  ThemeHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: BlocProviders.providers,
      child: BlocBuilder<LocalizationCubit, LocalizationState>(
        builder: (context, state) {
          final locale = state.selectedLanguage.value;
          return BlocBuilder<ThemeCubit, ThemeData>(
            builder: (context, themeData) {
              return ScreenUtilInit(
                designSize: const Size(360, 690),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, child) {
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    routerConfig: AppRoutes.router,
                    title: 'Story',
                    theme: ThemeData.light(),
                    darkTheme: ThemeData.dark(),
                    themeMode: themeData.brightness == Brightness.dark
                        ? ThemeMode.dark
                        : ThemeMode.light,
                    supportedLocales: AppLocalizations.supportedLocales,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    locale: locale,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
