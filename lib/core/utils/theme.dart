import 'package:contact_notes/core/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kContentColorDarkTheme,
    dialogBackgroundColor: kContentColorDarkTheme,
    appBarTheme: appBarTheme.copyWith(
      surfaceTintColor: kContentColorDarkTheme,
      titleTextStyle: Theme.of(context).textTheme.bodyLarge,
    ),
    shadowColor: Colors.grey.shade500,
    iconTheme: IconThemeData(color: kContentColorLightTheme.withOpacity(0.5)),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: kContentColorLightTheme),
    colorScheme: const ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        iconColor: kContentColorLightTheme.withOpacity(0.7)),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.grey.shade500),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.grey.shade500),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.blue.shade500, width: 2),
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: kContentColorDarkTheme,
      elevation: 0,
      surfaceTintColor: kContentColorDarkTheme,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blue,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(Colors.blue.shade100),
      elevation: WidgetStateProperty.all<double>(0),
      textStyle: WidgetStateProperty.all<TextStyle>(Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
    )),
    cardColor: Colors.grey.shade400,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: kContentColorLightTheme.withOpacity(0.7),
      unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kContentColorLightTheme,
    dialogBackgroundColor: kContentColorLightTheme,
    appBarTheme: appBarTheme.copyWith(
        backgroundColor: kContentColorLightTheme,
        surfaceTintColor: kContentColorLightTheme),
    iconTheme: const IconThemeData(color: kContentColorDarkTheme),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: kContentColorDarkTheme),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: kContentColorLightTheme,
      elevation: 0,
      surfaceTintColor: kContentColorLightTheme,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.grey.shade500),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.grey.shade500),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.blue.shade500, width: 2),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kContentColorLightTheme,
      selectedItemColor: Colors.white70,
      unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

const appBarTheme = AppBarTheme(centerTitle: false, elevation: 0);
