import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class EmptyDataWidget extends StatelessWidget {
  EmptyDataWidget({super.key, this.onRetry});
  Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/icons/empty-data-light.png",
              width: MediaQuery.of(context).size.width * 0.8,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.empty_data,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            if (onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                child: Text(AppLocalizations.of(context)!.retry),
              ),
          ],
        ),
      ),
    );
  }
}
