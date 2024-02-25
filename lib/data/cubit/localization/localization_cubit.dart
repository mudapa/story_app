import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../shared/helper.dart';
import '../../../shared/localization/language.dart';

part 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit()
      : super(const LocalizationInitial(
          Language.indonesia,
        ));

  void changeLanguage(Language selectedLanguage) {
    settings.put('selectedLanguage', selectedLanguage.value.languageCode);
    emit(LocalizationInitial(selectedLanguage));
  }

  void getLanguage() {
    final selectedLanguage = settings.get('selectedLanguage');

    if (selectedLanguage != null) {
      emit(LocalizationInitial(Language.values
          .where((item) => item.value.languageCode == selectedLanguage)
          .first));
    } else {
      emit(const GetLanguage(Language.indonesia));
    }
  }
}
