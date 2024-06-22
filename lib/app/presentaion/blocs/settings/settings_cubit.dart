import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_notes/app/presentaion/blocs/settings/settings_state.dart';
import 'package:contact_notes/core/utils/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({SettingsState? state}) : super(state ?? SettingsState()) {
    _init();
  }
  void _init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Language language = getLanguages.firstWhere(
      (element) => element.key == prefs.getString("language"),
      orElse: () => getLanguages.first,
    );
    emit(
      state.copyWith(
          isDarkMode: prefs.getBool("isDarkMode"),
          isShowPreviewPhotos: prefs.getBool("isShowPreviewPhotos"),
          locale: Locale(language.key)),
    );
  }

  void changeTheme({
    bool? isShowPreviewPhotos,
    bool? isDarkMode,
    Language? language,
  }) async {
    emit(
      state.copyWith(
        isShowPreviewPhotos: isShowPreviewPhotos,
        isDarkMode: isDarkMode,
        locale: language != null ? Locale(language.key) : null,
      ),
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkMode", state.isDarkMode);
    prefs.setBool("isShowPreviewPhotos", state.isShowPreviewPhotos);
    prefs.setString("language", state.locale.languageCode);
  }
}
