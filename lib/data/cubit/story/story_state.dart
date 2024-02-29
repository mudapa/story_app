part of 'story_cubit.dart';

sealed class StoryState extends Equatable {
  const StoryState();

  @override
  List<Object> get props => [];
}

final class StoryInitial extends StoryState {}

final class StoryLoading extends StoryState {}

final class StorySuccess extends StoryState {
  final List<Story> listStory;

  const StorySuccess(this.listStory);

  @override
  List<Object> get props => [listStory];
}

final class StoryFailed extends StoryState {
  final String message;

  const StoryFailed({required this.message});

  @override
  List<Object> get props => [message];
}
