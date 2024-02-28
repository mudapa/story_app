import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../model/detail_story_model.dart';
import '../../../services/story_service.dart';

part 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit() : super(DetailInitial());

  Future<void> getDetailStory(String id) async {
    emit(DetailStoryLoading());
    try {
      final detailStory = await StoryService().getStoryById(id);
      emit(DetailStorySuccess(detailStory));
    } catch (e) {
      emit(DetailStoryFailed(message: e.toString()));
    }
  }
}
