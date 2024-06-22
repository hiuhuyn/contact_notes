import 'dart:developer';

import 'package:contact_notes/app/domain/repository/google_drive_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_notes/app/domain/usecases/clear_database_local.dart';
import 'package:contact_notes/app/domain/usecases/google/sign_in_and_out_with_google.dart';
import 'package:contact_notes/app/presentaion/blocs/note_label/note_label_cubit.dart';
import 'package:contact_notes/app/presentaion/blocs/people_note/people_note_cubit.dart';
import 'package:contact_notes/app/presentaion/blocs/settings/settings_cubit.dart';
import 'package:contact_notes/core/exceptions/custom_exception.dart';
import 'package:contact_notes/core/router/app_router.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/language.dart';
import 'package:contact_notes/setup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

/*

*/
class _SettingsScreenState extends State<SettingsScreen> {
  final textStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Column(
        children: [
          _itemSetting(
              title: AppLocalizations.of(context)!.shows_image_preview,
              icon: Icons.preview_rounded,
              trailing: Switch(
                value: context.read<SettingsCubit>().state.isShowPreviewPhotos,
                onChanged: (value) {
                  setState(() {
                    context.read<SettingsCubit>().changeTheme(
                        isShowPreviewPhotos: !context
                            .read<SettingsCubit>()
                            .state
                            .isShowPreviewPhotos);
                  });
                },
              )),
          _itemSetting(
              title: AppLocalizations.of(context)!.dark_mode,
              icon: context.read<SettingsCubit>().state.isDarkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              trailing: Switch(
                value: context.read<SettingsCubit>().state.isDarkMode,
                onChanged: (value) {
                  setState(() {
                    context.read<SettingsCubit>().changeTheme(
                        isDarkMode:
                            !context.read<SettingsCubit>().state.isDarkMode);
                  });
                },
              )),
          _itemSetting(
            title: AppLocalizations.of(context)!.language,
            icon: Icons.language,
            onTap: () {
              _showDiaLogSelectLanguage(context);
            },
          ),
          _itemSetting(
            title: AppLocalizations.of(context)!.backup,
            icon: Icons.save_alt_rounded,
            onTap: () async {
              await sl<GoogleDriveRepository>().backupToGoogleDrive().then(
                (value) {
                  if (value is DataSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Backup successful"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
              );
            },
          ),
          _itemSetting(
            title: AppLocalizations.of(context)!.delete_data_local,
            icon: Icons.delete_sweep_outlined,
            onTap: () async {
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                    AppLocalizations.of(context)!.delete_data_local,
                  ),
                  content: Text(AppLocalizations.of(context)!
                      .are_you_sure_you_want_to_delete),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx, "cancel");
                      },
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    TextButton(
                      onPressed: () async {
                        await sl<ClearDatabaseLocal>().call().then((value) {
                          if (value is DataSuccess) {
                            Navigator.pop(ctx, "success");
                          } else {
                            Navigator.pop(ctx, value.error);
                          }
                        });
                      },
                      child: Text(AppLocalizations.of(context)!.ok),
                    )
                  ],
                ),
              ).then(
                (value) {
                  if (value is CustomException) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(value.messange),
                      ),
                    );
                  } else if (value == "success") {
                    context.read<PeopleNoteCubit>().loaded();
                    context.read<NoteLabelCubit>().loaded();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(AppLocalizations.of(context)!.delete_success),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
              );
            },
          ),
          _itemSetting(
            title: AppLocalizations.of(context)!.about,
            icon: Icons.info_outline_rounded,
            onTap: () {},
          ),
          _itemSetting(
            title: AppLocalizations.of(context)!.sign_out,
            icon: Icons.exit_to_app,
            onTap: () async {
              final response =
                  await sl<SignInAndOutWithGoogleUseCase>().signOut();
              if (response is DataSuccess) {
                // ignore: use_build_context_synchronously
                AppRouter.navigateToLogin(context);
              } else {
                showDialog(
                  // ignore: use_build_context_synchronously
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      AppLocalizations.of(context)!.sign_out_failed,
                    ),
                    content: Text(response.error.toString()),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(AppLocalizations.of(context)!.ok),
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _itemSetting(
      {required String title,
      IconData? icon,
      Function()? onTap,
      Widget? trailing}) {
    return ListTile(
      title: Text(
        title,
        style: textStyle,
      ),
      leading: Icon(icon),
      onTap: onTap,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded),
    );
  }

  void _showDiaLogSelectLanguage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          AppLocalizations.of(context)!.select_language,
        ),
        children: getLanguages
            .map(
              (e) => SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, e);
                },
                child: Text(e.title),
              ),
            )
            .toList(),
      ),
    ).then(
      (value) {
        if (value is Language) {
          context.read<SettingsCubit>().changeTheme(language: value);
        }
      },
    );
  }
}
