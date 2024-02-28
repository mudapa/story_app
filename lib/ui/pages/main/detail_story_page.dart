import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../data/cubit/localization/localization_cubit.dart';
import '../../../data/cubit/story/detail/detail_cubit.dart';
import '../../../data/cubit/theme/theme_cubit.dart';
import '../../../data/model/story.dart';
import '../../../shared/helper.dart';
import '../../../shared/style.dart';
import '../../widgets/custom_button.dart';

class DetailStoryPage extends StatelessWidget {
  const DetailStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DetailCubit, DetailState>(
          builder: (context, state) {
            return ListView(
              children: [
                state is DetailStorySuccess
                    ? _headerContent(context, state.detailStory.story!)
                    : state is DetailStoryFailed
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/not_found.json',
                                  width: 200.w,
                                  height: 200.h,
                                ),
                                gapH,
                                CustomButton(
                                  text: text(context).btnTextError,
                                  onTap: () {
                                    GoRouter.of(context).pop();
                                  },
                                  color: blueColor,
                                  style: label.copyWith(
                                    color: whiteColor,
                                  ),
                                  width: 100.w,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                state is DetailStorySuccess
                    ? _buildContent(context, state.detailStory.story!)
                    : const SizedBox(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _headerContent(BuildContext context, Story story) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: context.select((ThemeCubit cubit) =>
                      cubit.state.brightness == Brightness.dark)
                  ? [
                      whiteColor.withOpacity(0.3),
                      whiteColor.withOpacity(0.1),
                    ]
                  : [
                      blackColor.withOpacity(0.3),
                      blackColor.withOpacity(0.1),
                    ],
            ),
          ),
        ),
        Hero(
          tag: story.id!,
          child: Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: story.photoUrl != null
                    ? NetworkImage(
                        story.photoUrl!,
                      ) as ImageProvider
                    : const AssetImage('assets/placeholder_image.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        Positioned(
          top: 8.h,
          left: 16.w,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: whiteColor.withOpacity(0.3),
            ),
            child: IconButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              icon: Icon(
                Icons.chevron_left_rounded,
                color: blackColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, Story story) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 30.w,
                    height: 30.w,
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
                      width: 30.w,
                    ),
                  ),
                  gapW,
                  Text(
                    story.name != null ? story.name! : 'User Name',
                  ),
                ],
              ),
              BlocBuilder<LocalizationCubit, LocalizationState>(
                builder: (context, state) {
                  return Text(
                    timeago.format(story.createdAt!,
                        locale: state.selectedLanguage.value.languageCode),
                    style: label.copyWith(
                      color: greyColor,
                    ),
                  );
                },
              ),
            ],
          ),
          const Divider(),
          gapH,
          ReadMoreText(
            story.description != null ? story.description! : '...',
            style: body,
            textAlign: TextAlign.start,
            trimLines: 4,
            trimMode: TrimMode.Line,
            moreStyle: label.copyWith(
              color: greyColor,
            ),
            lessStyle: label.copyWith(
              color: greyColor,
            ),
            trimCollapsedText: text(context).more,
            trimExpandedText: text(context).less,
          ),
        ],
      ),
    );
  }
}
