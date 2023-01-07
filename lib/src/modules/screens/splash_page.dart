import 'package:flutter/material.dart';
import '/src/widgets/custom_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static Route<void> route() => MaterialPageRoute<void>(
        builder: (_) => const SplashPage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomCircularIndicator(
        title: AppLocalizations.of(context)!.pleaseWait,
        isSystem: true,
        isSurvey: false,
      ),
    );
  }
}
