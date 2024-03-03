import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../data/cubit/story/story_cubit.dart';
import '../../../data/cubit/theme/theme_cubit.dart';
import '../../../data/model/story.dart';
import '../../../shared/helper.dart';
import '../../../shared/style.dart';
import '../../widgets/content_story.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/header_story.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  List<Story> story = [];
  int pageItems = 1;
  int size = 3;

  @override
  void initState() {
    super.initState();
    story.clear();
    loadData(context);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      pageItems = pageItems + 1;
      context.read<StoryCubit>().getAllStory(
            pageItems: pageItems,
            size: size,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            story.clear();
            pageItems = 1;
            await Future<void>.delayed(const Duration(seconds: 3)).then(
              (value) {
                context.read<StoryCubit>().getAllStory(
                      pageItems: pageItems,
                      size: size,
                    );
              },
            );
          },
          child: Column(
            children: [
              const HeaderStory(),
              gapH,
              BlocBuilder<StoryCubit, StoryState>(
                builder: (context, state) {
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
                              story.clear();
                              pageItems = 1;
                              context.read<StoryCubit>().getAllStory(
                                    pageItems: pageItems,
                                    size: size,
                                  );
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

                  if (pageItems == 1 && state is StoryLoading) {
                    return Expanded(
                      child: Center(
                        child: Lottie.asset(
                          'assets/loading.json',
                          width: 80.w,
                          height: 80.h,
                        ),
                      ),
                    );
                  }

                  if (state is StorySuccess) {
                    final data = state.listStory;
                    story.addAll(data);
                  }

                  return Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          pageItems == 1 ? story.length : story.length + 1,
                      itemBuilder: (context, index) {
                        if (index == story.length && pageItems != 1) {
                          return Center(
                            child: Lottie.asset(
                              'assets/loading.json',
                              width: 80.w,
                              height: 80.h,
                            ),
                          );
                        }

                        return ContentStory(
                          story: story[index],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
