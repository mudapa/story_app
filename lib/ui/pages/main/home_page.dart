import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../data/cubit/story/story_cubit.dart';
import '../../../data/cubit/theme/theme_cubit.dart';
import '../../../shared/helper.dart';
import '../../../shared/style.dart';
import '../../widgets/content_story.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/story.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<StoryCubit>().getAllStory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.h,
        elevation: 0,
        shadowColor: context.select(
                (ThemeCubit cubit) => cubit.state.brightness == Brightness.dark)
            ? whiteColor.withOpacity(0.2)
            : blackColor.withOpacity(0.2),
        title: context.select(
                (ThemeCubit cubit) => cubit.state.brightness == Brightness.dark)
            ? Image.asset(
                'assets/logo_white.png',
                width: 100.w,
              )
            : Image.asset(
                'assets/logo_dark.png',
                width: 100.w,
              ),
        actions: [
          IconButton(
            onPressed: () {
              showLanguageBottomSheet(context);
            },
            icon: const Icon(
              Icons.menu_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future<void>.delayed(const Duration(seconds: 3)).then(
              (value) {
                context.read<StoryCubit>().getAllStory();
              },
            );
          },
          child: ListView(
            children: [
              const Story(),
              gapH,
              BlocBuilder<StoryCubit, StoryState>(
                builder: (context, state) {
                  if (state is StoryLoading) {
                    return Lottie.asset(
                      'assets/loading.json',
                      width: 100.w,
                      height: 100.h,
                    );
                  }

                  if (state is StoryFailed) {
                    return Center(
                      child: Column(
                        children: [
                          Lottie.asset(
                            'assets/not_found.json',
                            width: 250.w,
                            height: 250.h,
                          ),
                          gapH,
                          CustomButton(
                            text: text(context).btnTextRefresh,
                            onTap: () {
                              context.read<StoryCubit>().getAllStory();
                            },
                            color: blueColor,
                            style: label.copyWith(
                              color: whiteColor,
                            ),
                            width: 100.w,
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: state is StorySuccess
                        ? state.stories.listStory!.map(
                            (story) {
                              return ContentStory(
                                story: story,
                              );
                            },
                          ).toList()
                        : [],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
