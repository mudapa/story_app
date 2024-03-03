import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/cubit/camera/camera_cubit.dart';
import '../../../data/cubit/theme/theme_cubit.dart';
import '../../../data/cubit/upload/upload_cubit.dart';
import '../../../shared/helper.dart';
import '../../../shared/style.dart';
import '../../widgets/custom_button.dart';

class CreateStoryPage extends StatefulWidget {
  const CreateStoryPage({super.key});

  @override
  State<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends State<CreateStoryPage> {
  final _descriptionController = TextEditingController();

  LatLng? _location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(text(context).titleNewStory),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: const Icon(
            Icons.chevron_left_rounded,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            _headerContent(context),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _headerContent(BuildContext context) {
    final imagePath =
        context.select((CameraCubit cubit) => cubit.state.imagePath);
    return Column(
      children: [
        Stack(
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
            SizedBox(
              width: double.infinity,
              height: 200.h,
              child: imagePath != null
                  ? Image.file(
                      File(imagePath),
                      fit: BoxFit.fitHeight,
                    )
                  : Image.asset(
                      'assets/placeholder_image.png',
                      fit: BoxFit.fitHeight,
                    ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomButton(
              text: text(context).btnTextCamera,
              onTap: () => onCamera(context),
              color: blueColor,
              width: 100.w,
              style: label.copyWith(
                color: whiteColor,
              ),
            ),
            CustomButton(
              text: text(context).btnTextGallery,
              onTap: () => onGallery(context),
              color: blueColor,
              width: 100.w,
              style: label.copyWith(
                color: whiteColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: text(context).labelDesc,
              hintText: text(context).hintDesc,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: greyColor,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.zero,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: greyColor,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.zero,
                ),
              ),
            ),
          ),
          gapH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                width: 200.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: greyColor,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text(context).labelLocation,
                    ),
                    Text(_location != null
                        ? '${_location!.latitude}, ${_location!.longitude}'
                        : '-'),
                  ],
                ),
              ),
              IconButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.zero,
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    redColor,
                  ),
                ),
                onPressed: () async {
                  _setLocation(context);
                },
                icon: Icon(
                  Icons.location_on,
                  color: whiteColor,
                ),
              ),
            ],
          ),
          gapH,
          BlocConsumer<UploadCubit, UploadState>(
            listener: (context, state) {
              if (state is UploadSuccess) {
                snackbar(context, text(context).successUpload, greenColor);
                GoRouter.of(context).replaceNamed('home');
              }

              if (state is UploadFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is UploadLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return CustomButton(
                text: text(context).btnTextUpload,
                onTap: () =>
                    onUpload(context, _descriptionController.text, _location),
                color: blueColor,
                style: label.copyWith(
                  color: whiteColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _setLocation(BuildContext context) {
    GoRouter.of(context).pushNamed('set-location').then((value) {
      if (value != null) {
        setState(() {
          _location = value as LatLng;
        });
      }
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
