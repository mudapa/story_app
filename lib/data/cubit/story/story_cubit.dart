import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/story.dart';
import '../../services/story_service.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  StoryCubit() : super(StoryInitial());

  Future<List<Story>> getAllStory({
    int? pageItems,
    int? size,
  }) async {
    if (pageItems == 1) {
      emit(StoryLoading());
    }
    try {
      final result = await StoryService().getAllStory(
        page: pageItems,
        size: size,
        location: 0,
      );

      emit(StorySuccess(result));
      return result;
    } catch (e) {
      emit(StoryFailed(message: e.toString()));
      return [];
    }
  }
}
