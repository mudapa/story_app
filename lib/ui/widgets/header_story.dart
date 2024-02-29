import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../data/cubit/auth/auth_cubit.dart';
import '../../data/cubit/theme/theme_cubit.dart';
import '../../shared/helper.dart';
import '../../shared/style.dart';

class HeaderStory extends StatelessWidget {
  const HeaderStory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  context.goNamed('create');
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.select((ThemeCubit cubit) =>
                                  cubit.state.brightness == Brightness.dark)
                              ? whiteColor.withOpacity(0.8)
                              : blackColor.withOpacity(0.8),
                          width: 1.w,
                        ),
                      ),
                      child: Image.asset(
                        'assets/avatar.png',
                        width: 55.w,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: blueColor,
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          color: whiteColor,
                          size: 18.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              gapW,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state is AuthSuccess
                        ? state.user.loginResult!.name!
                        : settings.get('user') != null
                            ? settings.get('user')['name']
                            : 'User Name',
                    style: label,
                  ),
                  Text(
                    text(context).labelAdd,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
