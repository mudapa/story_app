import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_app/data/cubit/theme/theme_cubit.dart';
import '../../data/cubit/localization/localization_cubit.dart';
import '../../shared/helper.dart';
import '../../shared/localization/language.dart';
import '../../shared/style.dart';
import '../../ui/widgets/form_login.dart';
import '../widgets/custom_mode.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16).w,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<LocalizationCubit, LocalizationState>(
                        builder: (context, state) {
                          return DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: state.selectedLanguage,
                              items: Language.values
                                  .map(
                                    (e) => DropdownMenuItem(
                                      alignment: Alignment.center,
                                      value: e,
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: borderRadius,
                                              border: Border.all(
                                                color: context.select(
                                                        (ThemeCubit cubit) =>
                                                            cubit.state
                                                                .brightness ==
                                                            Brightness.dark)
                                                    ? whiteColor
                                                        .withOpacity(0.8)
                                                    : blackColor
                                                        .withOpacity(0.8),
                                                width: 2.w,
                                              ),
                                            ),
                                            child: Image.asset(
                                              'assets/flag/${e.value.languageCode}.png',
                                              width: 30.w,
                                            ),
                                          ),
                                          gapW,
                                          Text(
                                            e.text,
                                            style: label,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        context
                                            .read<LocalizationCubit>()
                                            .changeLanguage(
                                              Language.values[
                                                  Language.values.indexOf(e)],
                                            );
                                      },
                                    ),
                                  )
                                  .toList(),
                              onChanged: (_) {},
                            ),
                          );
                        },
                      ),
                      const CustomMode(),
                    ],
                  ),
                  gapH,
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
                  Transform(
                    transform: Matrix4.rotationZ(0.1),
                    child: SizedBox(
                      height: 80.h,
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            text(context).headline,
                            textStyle: headline,
                            textAlign: TextAlign.center,
                            cursor: '✏',
                            speed: const Duration(milliseconds: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const FormLogin(),
          ],
        ),
      ),
    );
  }
}
