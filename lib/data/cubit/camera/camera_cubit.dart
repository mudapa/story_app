import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraState());

  void setImagePath(String? value) {
    emit(state.copyWith(imagePath: value));
  }

  void setImageFile(XFile? value) {
    emit(state.copyWith(imageFile: value));
  }
}
