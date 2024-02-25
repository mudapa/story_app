import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../data/cubit/theme/theme_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    var settings = Hive.box('settings');
    Future.delayed(const Duration(seconds: 3), () {
      if (settings.get('user') != null) {
        context.goNamed('home');
      } else {
        context.goNamed('login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            context.select((ThemeCubit cubit) =>
                    cubit.state.brightness == Brightness.dark)
                ? Image.asset(
                    'assets/logo_white.png',
                    width: 250.w,
                  )
                : Image.asset(
                    'assets/logo_dark.png',
                    width: 250.w,
                  ),
          ],
        ),
      ),
    );
  }
}
