part of 'localization_cubit.dart';

sealed class LocalizationState extends Equatable {
  final Language selectedLanguage;
  const LocalizationState(this.selectedLanguage);

  @override
  List<Object> get props => [selectedLanguage];
}

final class LocalizationInitial extends LocalizationState {
  const LocalizationInitial(super.selectedLanguage);
}

final class GetLanguage extends LocalizationState {
  const GetLanguage(super.selectedLanguage);

  @override
  List<Object> get props => [selectedLanguage];
}
