part of 'camera_cubit.dart';

class CameraState {
  final String? imagePath;
  final XFile? imageFile;

  CameraState({this.imagePath, this.imageFile});

  CameraState copyWith({
    String? imagePath,
    XFile? imageFile,
  }) {
    return CameraState(
      imagePath: imagePath ?? this.imagePath,
      imageFile: imageFile ?? this.imageFile,
    );
  }
}
