import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import '../data/cubit/camera/camera_cubit.dart';
import '../data/cubit/localization/localization_cubit.dart';
import '../data/cubit/story/story_cubit.dart';
import '../data/cubit/theme/theme_cubit.dart';
import '../data/cubit/upload/upload_cubit.dart';
import '../l10n/l10n.dart';
import '../ui/widgets/custom_button.dart';
import '../ui/widgets/custom_mode.dart';
import 'localization/language.dart';
import 'style.dart';

SizedBox get gapW => SizedBox(width: 8.w);
Widget get gapH => SizedBox(height: 16.h);
Radius get radius => const Radius.circular(18).w;
BorderRadius get borderRadius => BorderRadius.circular(18).w;
Box get settings => Hive.box('settings');

AppLocalizations text(BuildContext context) => AppLocalizations.of(context)!;

void showLanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: radius,
        topRight: radius,
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16).w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.titleBottomSheet,
                  style: title,
                ),
                const CustomMode(),
              ],
            ),
            gapH,
            BlocBuilder<LocalizationCubit, LocalizationState>(
              builder: (context, state) {
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: Language.values.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        context.read<LocalizationCubit>().changeLanguage(
                              Language.values[index],
                            );
                      },
                      title: Text(
                        Language.values[index].text,
                        style: label,
                      ),
                      leading: BlocBuilder<ThemeCubit, ThemeData>(
                        builder: (context, theme) {
                          final isLightTheme =
                              theme.brightness == Brightness.light;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: borderRadius,
                              border: Border.all(
                                color: isLightTheme
                                    ? blackColor.withOpacity(0.8)
                                    : whiteColor.withOpacity(0.8),
                                width: 2.w,
                              ),
                            ),
                            child: Image.asset(
                              'assets/flag/${Language.values[index].value.languageCode}.png',
                              width: 30.w,
                            ),
                          );
                        },
                      ),
                      trailing: Language.values[index] == state.selectedLanguage
                          ? Icon(Icons.check_circle_rounded, color: blueColor)
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: borderRadius,
                        side: Language.values[index] == state.selectedLanguage
                            ? BorderSide(color: blueColor, width: 1.5)
                            : BorderSide(color: greyColor),
                      ),
                      tileColor:
                          Language.values[index] == state.selectedLanguage
                              ? blueColor.withOpacity(0.05)
                              : null,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return gapH;
                  },
                );
              },
            ),
            gapH,
            CustomButton(
              onTap: () {
                showLogoutDialog(
                  context,
                  text(context).btnTextLogout,
                  text(context).contentLogoutDialog,
                  () {
                    settings.delete('user');
                    context.goNamed('login');
                    snackbar(context, text(context).successLogout, greenColor);
                  },
                );
              },
              text: text(context).btnTextLogout,
              color: redColor,
              style: label.copyWith(color: whiteColor),
            ),
          ],
        ),
      );
    },
  );
}

void showLogoutDialog(
    BuildContext context, String title, String content, Function() onConfirm) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(text(context).btnTextCancel),
          ),
          TextButton(
            onPressed: onConfirm,
            child: Text(text(context).btnTextConfirm),
          ),
        ],
      );
    },
  );
}

void snackbar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: label.copyWith(
          color: whiteColor,
        ),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: color,
    ),
  );
}

void loadData(BuildContext context) async {
  await context.read<StoryCubit>().getAllStory(
        pageItems: 1,
        size: 3,
      );
}

onCamera(BuildContext context) async {
  final camera = context.read<CameraCubit>();
  final isAndroid = defaultTargetPlatform == TargetPlatform.android;
  final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
  final isNotMobile = !(isAndroid || isiOS);
  if (isNotMobile) return;

  final picker = ImagePicker();

  final pickedFile = await picker.pickImage(
    source: ImageSource.camera,
  );

  if (pickedFile != null) {
    camera.setImageFile(pickedFile);
    camera.setImagePath(pickedFile.path);
  }
}

onGallery(BuildContext context) async {
  final camera = context.read<CameraCubit>();

  final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
  final isLinux = defaultTargetPlatform == TargetPlatform.linux;
  if (isMacOS || isLinux) return;

  final picker = ImagePicker();

  final pickedFile = await picker.pickImage(
    source: ImageSource.gallery,
  );

  if (pickedFile != null) {
    camera.setImageFile(pickedFile);
    camera.setImagePath(pickedFile.path);
  }
}

compressImage(List<int> bytes) {
  int imageLength = bytes.length;
  if (imageLength < 1000000) return bytes;
  final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
  int compressQuality = 100;
  int length = imageLength;
  List<int> newByte = [];
  do {
    compressQuality -= 10;
    newByte = img.encodeJpg(
      image,
      quality: compressQuality,
    );
    length = newByte.length;
  } while (length > 1000000);
  return newByte;
}

onUpload(BuildContext context, String description, LatLng? location) async {
  final uploadStory = context.read<UploadCubit>();
  final camera = context.read<CameraCubit>();
  final imagePath = camera.state.imagePath;
  final imageFile = camera.state.imageFile;
  if (imagePath == null || imageFile == null || description.isEmpty) {
    snackbar(context, text(context).errorUpload, redColor);
    return;
  }

  final fileName = imageFile.name;
  final bytes = await imageFile.readAsBytes();
  final newBytes = compressImage(bytes);
  if (location == null) {
    uploadStory.uploadStory(
      description: description,
      bytes: newBytes,
      fileName: fileName,
    );
  } else {
    uploadStory.uploadStory(
      description: description,
      bytes: newBytes,
      fileName: fileName,
      lat: location.latitude,
      lon: location.longitude,
    );
  }
}
