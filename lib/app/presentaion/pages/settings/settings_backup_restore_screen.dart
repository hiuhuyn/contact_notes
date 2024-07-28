import 'package:contact_notes/app/data/data_sources/remote/firebase_service.dart';
import 'package:contact_notes/app/domain/repository/google_drive_repository.dart';
import 'package:contact_notes/app/domain/usecases/google_drive/backup_to_google_drive.dart';
import 'package:contact_notes/app/domain/usecases/google_drive/clean_folder_google_drive.dart';
import 'package:contact_notes/app/domain/usecases/google_drive/restore_from_google_drive.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/utils/utils.dart';
import '../../../../setup.dart';

class SettingsBackupRestoreScreen extends StatefulWidget {
  const SettingsBackupRestoreScreen({super.key});

  @override
  State<SettingsBackupRestoreScreen> createState() =>
      SsettingsBackupRestoreState();
}

class SsettingsBackupRestoreState extends State<SettingsBackupRestoreScreen> {
  bool isAutoBackup = true;
  String? timeLastBackup;
  @override
  void initState() {
    super.initState();
    checkTimeLastBackup();
  }

  checkTimeLastBackup() async {
    sl<GoogleDriveRepository>().getMostRecentlyModifiedFile().then(
      (value) {
        if (value is DataSuccess && value.data != null) {
          final modifiedTime = value.data!.modifiedTime;
          if (modifiedTime != null) {
            final diff = DateTime.now().difference(modifiedTime);
            setState(() {
              int timeInt = diff.inMinutes;
              if (timeInt >= 60) {
                timeInt = diff.inHours;
                if (timeInt >= 24) {
                  timeInt = diff.inDays;
                  timeLastBackup =
                      "$timeInt ${AppLocalizations.of(context)!.days_before}";
                } else {
                  timeLastBackup =
                      "$timeInt ${AppLocalizations.of(context)!.hours_ago}";
                }
              } else {
                timeLastBackup =
                    "$timeInt ${AppLocalizations.of(context)!.minutes_ago}";
              }
            });
          } else {
            setState(() {
              timeLastBackup = null;
            });
          }
        } else {
          setState(() {
            timeLastBackup = null;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor.withAlpha(230),
      appBar: AppBar(
        title: Text(
            "${AppLocalizations.of(context)!.backup} & ${AppLocalizations.of(context)!.restore}"),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.latest_backup,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                        onPressed: () {
                          _showBottomDialogRestoreAndDelete(context);
                        },
                        icon: const Icon(Icons.more_horiz))
                  ],
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '${AppLocalizations.of(context)!.time} ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.7),
                            ),
                      ),
                      TextSpan(
                        text: timeLastBackup ??
                            AppLocalizations.of(context)!.no_backup_yet,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Theme.of(context).cardColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.save,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.data,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.backup_to_google_drive,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.7),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "/${sl<GoogleDriveRepository>().peopleNoteAppFolder}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.google_account,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.7),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${sl<FirebaseService>().googleSignIn?.email}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () {
                        _showDialogBackup(context);
                      },
                      child: Text(AppLocalizations.of(context)!.backup)),
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.restore),
                  trailing: Switch(
                    value: isAutoBackup,
                    onChanged: (value) {
                      setState(() {
                        isAutoBackup = value;
                      });
                    },
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.automatic_daily_backups,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {},
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Theme.of(context).cardColor.withOpacity(0.3),
                ),
                ListTile(
                  leading: const Icon(Icons.error_outline),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  title: Text(
                    AppLocalizations.of(context)!.details_about_backup_data,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future _showDialogBackup(BuildContext ctx) async {
    return showDialog<void>(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              AppLocalizations.of(context)!.are_you_sure_you_want_to_back_up),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await showLoadingWithFuture(
                  ctx,
                  sl<BackupToGoogleDrive>().call(),
                  onLoadSuccess: () {
                    checkTimeLastBackup();
                  },
                );
              },
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      },
    );
  }

  Future _showDialogRestore(BuildContext ctx) async {
    return showDialog<void>(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.are_you_sure),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await showLoadingWithFuture(
                  ctx,
                  sl<RestoreFromGoogleDrive>().call(),
                  onLoadSuccess: () {
                    checkTimeLastBackup();
                  },
                );
              },
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      },
    );
  }

  Future _showDialogDeleteBackup(BuildContext ctx) async {
    return showDialog<void>(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!
              .are_you_sure_you_want_to_delete_this_backup),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showLoadingWithFuture(
                  ctx,
                  sl<CleanFolderGoogleDrive>().call(),
                  onLoadSuccess: () {
                    checkTimeLastBackup();
                  },
                );
              },
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      },
    );
  }

  Future _showBottomDialogRestoreAndDelete(BuildContext ctx) async {
    return showModalBottomSheet(
      context: ctx,
      builder: (context) => Container(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Container(
              height: 8,
              width: 60,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20)),
            ),
            ListTile(
              leading: const Icon(Icons.restore),
              title: Text(AppLocalizations.of(context)!.restore),
              onTap: () {
                Navigator.of(context).pop();
                _showDialogRestore(ctx);
              },
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Theme.of(context).cardColor.withOpacity(0.3),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text(AppLocalizations.of(context)!.delete_backup),
              onTap: () {
                Navigator.of(context).pop();
                _showDialogDeleteBackup(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}
