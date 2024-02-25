import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import '../data/cubit/auth/auth_cubit.dart';
import '../data/cubit/camera/camera_cubit.dart';
import '../data/cubit/localization/localization_cubit.dart';
import '../data/cubit/story/detail/detail_cubit.dart';
import '../data/cubit/story/story_cubit.dart';
import '../data/cubit/theme/theme_cubit.dart';
import '../data/cubit/upload/upload_cubit.dart';

class BlocProviders {
  static List<SingleChildWidget> providers = [
    BlocProvider(
      create: (context) => LocalizationCubit()..getLanguage(),
    ),
    BlocProvider(
      create: (context) => ThemeCubit()..loadTheme(),
    ),
    BlocProvider(
      create: (context) => CameraCubit(),
    ),
    BlocProvider(
      create: (context) => AuthCubit(),
    ),
    BlocProvider(
      create: (context) => StoryCubit(),
    ),
    BlocProvider(
      create: (context) => DetailCubit(),
    ),
    BlocProvider(
      create: (context) => UploadCubit(),
    ),
  ];
}
