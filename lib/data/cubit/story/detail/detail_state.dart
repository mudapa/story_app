part of 'detail_cubit.dart';

sealed class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

final class DetailInitial extends DetailState {}

final class DetailStoryLoading extends DetailState {}

final class DetailStorySuccess extends DetailState {
  final DetailStoryModel detailStory;

  const DetailStorySuccess(this.detailStory);

  @override
  List<Object> get props => [detailStory];
}

final class DetailStoryFailed extends DetailState {
  final String message;

  const DetailStoryFailed({required this.message});

  @override
  List<Object> get props => [message];
}
