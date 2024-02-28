import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../data/cubit/localization/localization_cubit.dart';
import '../../data/cubit/story/detail/detail_cubit.dart';
import '../../data/cubit/theme/theme_cubit.dart';
import '../../data/model/story.dart';
import '../../shared/helper.dart';
import '../../shared/style.dart';

class ContentStory extends StatelessWidget {
  final Story story;
  const ContentStory({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<DetailCubit>().getDetailStory(story.id!).then(
              (value) => context.goNamed('detail'),
            );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerContent(context),
          _imageContent(context),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _headerContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      child: Row(
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
            story.name!,
          ),
        ],
      ),
    );
  }

  Widget _imageContent(BuildContext context) {
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
          child: SizedBox(
            width: double.infinity,
            height: 200.h,
            child: CachedNetworkImage(
              imageUrl: story.photoUrl!,
              progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(value: progress.progress)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReadMoreText(
            story.description!,
            style: body,
            textAlign: TextAlign.start,
            trimLines: 2,
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
          gapH,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
        ],
      ),
    );
  }
}
