import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/cubit/theme/theme_cubit.dart';
import '../../shared/helper.dart';
import '../../shared/style.dart';

class CustomMode extends StatelessWidget {
  const CustomMode({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch<bool>.dual(
      current: context.select(
          (ThemeCubit cubit) => cubit.state.brightness == Brightness.dark),
      first: false,
      second: true,
      spacing: 10.w,
      style: ToggleStyle(
        borderColor: transparentColor,
        boxShadow: [
          BoxShadow(
            color: context.select((ThemeCubit cubit) =>
                    cubit.state.brightness == Brightness.dark)
                ? whiteColor.withOpacity(0.2)
                : blackColor.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      borderWidth: 5.0,
      height: 40.h,
      onChanged: (value) => context.read<ThemeCubit>().toggleTheme(),
      styleBuilder: (value) =>
          ToggleStyle(indicatorColor: value ? blueColor : orangeColor),
      iconBuilder: (value) => value
          ? const Icon(Icons.dark_mode_rounded)
          : Icon(Icons.light_mode_rounded, color: whiteColor),
      textBuilder: (value) => value
          ? Center(
              child: Text(
                text(context).labelDark,
                style: label,
              ),
            )
          : Center(
              child: Text(
                text(context).labelLight,
                style: label,
              ),
            ),
    );
  }
}
