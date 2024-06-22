// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SettingsState extends Equatable {
  Locale locale;
  bool isDarkMode = false;
  bool isShowPreviewPhotos = true;
  SettingsState({
    this.locale = const Locale("en"),
    this.isDarkMode = false,
    this.isShowPreviewPhotos = true,
  });

  @override
  List<Object> get props => [
        locale,
        isDarkMode,
        isShowPreviewPhotos,
      ];

  SettingsState copyWith({
    Locale? locale,
    bool? isDarkMode,
    bool? isShowPreviewPhotos,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isShowPreviewPhotos: isShowPreviewPhotos ?? this.isShowPreviewPhotos,
    );
  }
}
