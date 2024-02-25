import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../data/cubit/auth/auth_cubit.dart';
import '../../data/cubit/theme/theme_cubit.dart';
import '../../shared/helper.dart';
import '../../shared/style.dart';
import 'custom_button.dart';
import 'custom_form.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSignIn = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 0.5.sh,
        decoration: BoxDecoration(
          color: context.select((ThemeCubit cubit) =>
                  cubit.state.brightness == Brightness.dark)
              ? blackColor.withOpacity(0.8)
              : whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: radius,
            topRight: radius,
          ),
          boxShadow: [
            BoxShadow(
              color: context.select((ThemeCubit cubit) =>
                      cubit.state.brightness == Brightness.dark)
                  ? whiteColor.withOpacity(0.1)
                  : blackColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 14,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isSignIn
                          ? text(context).btnTextSignIn
                          : text(context).btnTextSignUp,
                      style: title,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isSignIn = !_isSignIn;
                        });
                      },
                      child: Text(
                        _isSignIn
                            ? text(context).btnTextSignUp
                            : text(context).btnTextSignIn,
                        style: body.copyWith(
                          color: context.select((ThemeCubit cubit) =>
                                  cubit.state.brightness == Brightness.dark)
                              ? blueColor
                              : orangeColor,
                          decoration: TextDecoration.underline,
                          decorationThickness: 2,
                          decorationColor: context.select((ThemeCubit cubit) =>
                                  cubit.state.brightness == Brightness.dark)
                              ? blueColor
                              : orangeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                gapH,
                Column(
                  children: [
                    if (!_isSignIn)
                      CustomForm(
                        controller: _nameController,
                        text: text(context).labelName,
                        hint: text(context).hintName,
                      ),
                    CustomForm(
                      controller: _emailController,
                      text: text(context).labelEmail,
                      hint: text(context).hintEmail,
                    ),
                    CustomForm(
                      controller: _passwordController,
                      text: text(context).labelPassword,
                      obscureText: true,
                    ),
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          snackbar(
                              context, text(context).successSignIn, greenColor);
                          context.goNamed('home');
                        }

                        if (state is RegisterSuccess) {
                          snackbar(
                              context, text(context).successSignUp, greenColor);
                          setState(() {
                            _isSignIn = !_isSignIn;
                          });
                          _nameController.clear();
                          _emailController.clear();
                          _passwordController.clear();
                        }

                        if (state is AuthFailed) {
                          snackbar(context, state.message, redColor);
                        }

                        if (state is RegisterFailed) {
                          snackbar(context, state.message, redColor);
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return Column(
                            children: [
                              gapH,
                              const CircularProgressIndicator(),
                            ],
                          );
                        }
                        return CustomButton(
                          onTap: () {
                            if (_isSignIn) {
                              context.read<AuthCubit>().login(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                            } else {
                              context.read<AuthCubit>().register(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                            }
                          },
                          color: context.select((ThemeCubit cubit) =>
                                  cubit.state.brightness == Brightness.dark)
                              ? blueColor
                              : orangeColor,
                          text: _isSignIn
                              ? text(context).btnTextSignIn
                              : text(context).btnTextSignUp,
                          style: body.copyWith(
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
