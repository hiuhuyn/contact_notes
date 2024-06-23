import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:contact_notes/app/domain/entity/note_label.dart';
import 'package:contact_notes/app/domain/entity/people_note.dart';
import 'package:contact_notes/app/domain/usecases/google/sign_in_and_out_with_google.dart';
import 'package:contact_notes/app/presentaion/pages/people_note/addable_relationships_list.dart';
import 'package:contact_notes/app/presentaion/pages/login_screen.dart';
import 'package:contact_notes/app/presentaion/pages/note_label_screen.dart';
import 'package:contact_notes/app/presentaion/pages/people_note/information/informaion_people_screen.dart';
import 'package:contact_notes/app/presentaion/pages/people_note_from_note_label_screen.dart';
import 'package:contact_notes/app/presentaion/pages/photos_screen.dart';
import 'package:contact_notes/app/presentaion/pages/settings/settings_screen.dart';
import 'package:contact_notes/app/presentaion/widgets/app_drawer.dart';
import '../../app/presentaion/pages/home_screen.dart';
import '../../app/presentaion/pages/settings/settings_backup_restore_screen.dart';
import '../../setup.dart';
import 'router_name.dart';
export 'router_name.dart';

class AppRouter {
  static PageRoute generate(RouteSettings settings) {
    log(settings.name.toString());
    String? routeName = settings.name;

    if (routeName == RouterName.root) {
      if (sl<SignInAndOutWithGoogleUseCase>().isCheckSignIn()) {
        routeName = RouterName.home;
      } else {
        routeName = RouterName.login;
      }
    }
    RouteSettings newSettings =
        RouteSettings(name: routeName, arguments: settings.arguments);
    switch (routeName) {
      case RouterName.home:
        return PageRouteBuilder(
          settings: newSettings,
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return const HomeScreen();
          },
        );
      case RouterName.login:
        return PageRouteBuilder(
          settings: newSettings,
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return const LoginScreen();
          },
        );
      case RouterName.settings:
        return PageRouteBuilder(
          settings: newSettings,
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return const SettingsScreen();
          },
        );
      case RouterName.noteTag:
        return PageRouteBuilder(
          settings: newSettings,
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            final data = newSettings.arguments as Map<String, dynamic>;
            NoteLabel? noteLabel = data["noteLabel"];
            bool selectNewLabel = data["selectNewLabel"];
            if (noteLabel != null) {
              return PeopleNoteFromNoteLabelScreen(noteLabel: noteLabel);
            } else {
              return NoteLabelScreen(
                selectNewLabel: selectNewLabel,
              );
            }
          },
        );
      case RouterName.createPeople:
        return PageRouteBuilder(
          settings: newSettings,
          pageBuilder: (context, animation, secondaryAnimation) {
            final data = newSettings.arguments as Map<String, dynamic>;
            String? idLabel = data["idLabel"];
            return InformationPeopleScreen.create(
              idLabel: idLabel,
            );
          },
        );
      case RouterName.informationPeople:
        return PageRouteBuilder(
          settings: newSettings,
          pageBuilder: (context, animation, secondaryAnimation) {
            final data = newSettings.arguments as Map<String, dynamic>;
            PeopleNote peopleNote = data["peopleNote"];
            return InformationPeopleScreen.update(
              peopleNote: peopleNote,
            );
          },
        );
      case RouterName.addableRelationshipsList:
        return PageRouteBuilder(
          settings: newSettings,
          pageBuilder: (context, animation, secondaryAnimation) {
            final data = newSettings.arguments as Map<String, dynamic>;
            List<String> relationships = data["relationships"] ?? [];
            String? id = data["id"];
            return AddableRelationshipsList(
              id: id,
              relationships: relationships,
            );
          },
        );
      case RouterName.photos:
        return PageRouteBuilder(
          settings: newSettings,
          pageBuilder: (context, animation, secondaryAnimation) {
            final data = newSettings.arguments as Map<String, dynamic>;
            List<String> photos = data["photos"] ?? [];
            bool isOffline = data["isOffline"] ?? true;
            int startIndex = data["startIndex"] ?? 0;
            Function(String value)? onDelete = data["onDelete"];

            return PhotosScreen(
              photos: photos,
              isOffline: isOffline,
              startIndex: startIndex,
              onDelete: onDelete,
            );
          },
        );
      case RouterName.settingsBackupRestore:
        return PageRouteBuilder(
          settings: newSettings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return const SettingsBackupRestoreScreen();
          },
        );
      default:
        return PageRouteBuilder(
          settings: newSettings,
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return Scaffold(
              appBar: AppBar(
                title: Text(newSettings.name.toString()),
              ),
              body: Center(
                child: Text(newSettings.name.toString()),
              ),
              drawer: AppDrawer(tag: DrawerTag.unknown),
            );
          },
        );
    }
  }

  static Future<void> navigateToHome(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await Navigator.pushNamedAndRemoveUntil(
      context,
      RouterName.home,
      (route) => false,
    );
  }

  static Future<void> navigateToLogin(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await Navigator.pushNamedAndRemoveUntil(
      context,
      RouterName.login,
      (route) => false,
    );
  }

  static Future navigateToSettings(BuildContext context) async {
    FocusScope.of(context).unfocus();
    return await Navigator.pushNamed(
      context,
      RouterName.settings,
    );
  }

  static Future navigateToSettingsBackupAndRestore(BuildContext context) async {
    FocusScope.of(context).unfocus();
    return await Navigator.pushNamed(
      context,
      RouterName.settingsBackupRestore,
    );
  }

  static Future<void> navigateToCreateNewPeopleNote(BuildContext context,
      {String? idLabel}) async {
    FocusScope.of(context).unfocus();
    await Navigator.pushNamed(
      context,
      RouterName.createPeople,
      arguments: {
        "idLabel": idLabel,
      },
    );
  }

  static Future<void> navigateToInformationPeopleNote(BuildContext context,
      {required PeopleNote peopleNote}) async {
    FocusScope.of(context).unfocus();
    await Navigator.pushNamed(
      context,
      RouterName.informationPeople,
      arguments: {"peopleNote": peopleNote},
    );
  }

  static Future<void> navigateToPhotos(
    BuildContext context, {
    required List<String> photos,
    bool isOffline = true,
    int startIndex = 0,
    Function(String value)? onDelete,
  }) async {
    FocusScope.of(context).unfocus();
    await Navigator.pushNamed(
      context,
      RouterName.photos,
      arguments: {
        "photos": photos,
        "isOffline": isOffline,
        "startIndex": startIndex,
        "onDelete": onDelete,
      },
    );
  }

  static Future<List<PeopleNote>> navigateToAddableRelationshipsList(
      BuildContext context,
      {required List<String> relationships,
      String? id}) async {
    FocusScope.of(context).unfocus();
    final result = await await Navigator.pushNamed(
      context,
      RouterName.addableRelationshipsList,
      arguments: {"relationships": relationships, "id": id},
    );
    if (result != null && result is List<PeopleNote>) {
      return result;
    } else {
      return [];
    }
  }

  static Future<void> navigateToAbout(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await Navigator.pushNamedAndRemoveUntil(
      context,
      RouterName.home,
      (route) => false,
    );
  }

  static Future<void> navigateToHelp(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await Navigator.pushNamedAndRemoveUntil(
      context,
      RouterName.help,
      (route) => false,
    );
  }

  static Future<void> navigateToNoteTag(BuildContext context,
      {NoteLabel? noteLabel, bool selectNewLabel = false}) async {
    FocusScope.of(context).unfocus();
    await Navigator.pushNamedAndRemoveUntil(
      context,
      RouterName.noteTag,
      arguments: {'noteLabel': noteLabel, "selectNewLabel": selectNewLabel},
      (route) => false,
    );
  }
}
