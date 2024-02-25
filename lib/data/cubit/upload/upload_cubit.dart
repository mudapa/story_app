import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/story_model.dart';
import '../../services/story_service.dart';

part 'upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  UploadCubit() : super(UploadInitial());

  Future<void> uploadStory({
    required String description,
    required List<int> bytes,
    required String fileName,
  }) async {
    emit(UploadLoading());
    try {
      final response = await StoryService().uploadStory(
        description: description,
        bytes: bytes,
        fileName: fileName,
      );
      emit(UploadSuccess(response));
    } on SocketException {
      emit(const UploadFailed('No internet connection'));
    } catch (e) {
      emit(UploadFailed(e.toString()));
    }
  }
}
