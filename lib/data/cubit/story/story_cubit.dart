import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/list_story_model.dart';
import '../../services/story_service.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  StoryCubit() : super(StoryInitial());

  Future<void> getAllStory() async {
    emit(StoryLoading());
    try {
      final stories = await StoryService().getAllStory();
      emit(StorySuccess(stories));
    } catch (e) {
      emit(StoryFailed(message: e.toString()));
    }
  }
}
