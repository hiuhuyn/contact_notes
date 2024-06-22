import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:contact_notes/app/domain/usecases/google/sign_in_and_out_with_google.dart';
import 'package:contact_notes/core/router/app_router.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/setup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    sl<SignInAndOutWithGoogleUseCase>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Placeholder(
                fallbackHeight: 200.h,
                strokeWidth: 200.w,
              ),
            ],
          )),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              final response =
                  await sl<SignInAndOutWithGoogleUseCase>().signIn();
              if (response is DataSuccess) {
                // ignore: use_build_context_synchronously
                AppRouter.navigateToHome(context);
              } else if (response is DataFailed) {
                showDialog(
                  // ignore: use_build_context_synchronously
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      AppLocalizations.of(context)!.sign_in_failed,
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
            child: Container(
              width: 700.w,
              padding: const EdgeInsets.all(5),
              margin: EdgeInsets.only(bottom: 100.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/icons/google-48.png",
                    width: 120.w,
                    height: 120.h,
                  ),
                  Text(AppLocalizations.of(context)!.sign_in_with_google)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
