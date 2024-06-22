// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:contact_notes/app/presentaion/blocs/note_label/note_label_cubit.dart';
import 'package:contact_notes/app/presentaion/blocs/people_note/people_note_cubit.dart';
import 'package:contact_notes/app/presentaion/blocs/settings/settings_cubit.dart';
import 'package:contact_notes/app/presentaion/blocs/settings/settings_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:contact_notes/core/router/app_router.dart';
import 'package:contact_notes/core/utils/theme.dart';
import 'package:contact_notes/setup.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<NoteLabelCubit>()),
        BlocProvider(create: (_) => sl<PeopleNoteCubit>()),
        BlocProvider(
          create: (_) => SettingsCubit(
              state: SettingsState(
            isDarkMode:
                MediaQuery.of(context).platformBrightness == Brightness.dark,
          )),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'People Notes',
            theme: lightThemeData(context),
            darkTheme: darkThemeData(context),
            themeMode: context.watch<SettingsCubit>().state.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            onGenerateRoute: AppRouter.generate,
            initialRoute: RouterName.root,
            locale: context.watch<SettingsCubit>().state.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
