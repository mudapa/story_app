part of 'upload_cubit.dart';

sealed class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object> get props => [];
}

final class UploadInitial extends UploadState {}

final class UploadLoading extends UploadState {}

final class UploadSuccess extends UploadState {
  final UploadResponse uploadResponse;

  const UploadSuccess(
    this.uploadResponse,
  );

  @override
  List<Object> get props => [
        uploadResponse,
      ];
}

final class UploadFailed extends UploadState {
  final String message;

  const UploadFailed(
    this.message,
  );

  @override
  List<Object> get props => [
        message,
      ];
}
