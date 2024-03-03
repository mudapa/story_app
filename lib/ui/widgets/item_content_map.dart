import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:readmore/readmore.dart';

import '../../../data/cubit/theme/theme_cubit.dart';
import '../../data/model/story.dart';
import '../../shared/helper.dart';
import '../../shared/style.dart';

class ItemContentMap extends StatelessWidget {
  final geo.Placemark placemark;
  final Story story;
  const ItemContentMap({
    super.key,
    required this.placemark,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(
        color: context.select(
                (ThemeCubit cubit) => cubit.state.brightness == Brightness.dark)
            ? blackColor
            : whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 20,
            offset: Offset.zero,
            color: greyColor.withOpacity(0.5),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
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
          ),
        ],
      ),
    );
  }
}
