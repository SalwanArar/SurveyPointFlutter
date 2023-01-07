import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:survey_point_05/src/modules/blocs/device_bloc/device_bloc.dart';

import '../../../../utils/services/business_locale.dart';
import '../../../blocs/survey_cubit/survey_cubit.dart';
import '../../../../constants/enums.dart';
import '../../../../constants/const_values.dart';
import '../../../../utils/services/functions.dart';

class SurveySetup extends StatelessWidget {
  const SurveySetup({Key? key}) : super(key: key);

  static Route<void> route() => MaterialPageRoute(
        builder: (_) => const SurveySetup(),
      );

  @override
  Widget build(BuildContext context) {
    final List<Local> locals = context.select(
      (DeviceBloc bloc) => bloc.state.deviceInfo.locals,
    );
    if (locals.isEmpty) locals.addAll([Local.ar, Local.en]);
//     print('''
// primary:\t\t\t\t\t${Theme.of(context).colorScheme.primary}
// primaryContainer:\t\t${Theme.of(context).colorScheme.primaryContainer}
// onPrimary:\t\t\t\t${Theme.of(context).colorScheme.onPrimary}
// onPrimaryContainer:\t\t${Theme.of(context).colorScheme.onPrimaryContainer}
// inversePrimary:\t\t\t${Theme.of(context).colorScheme.inversePrimary}
// secondary:\t\t\t\t${Theme.of(context).colorScheme.secondary}
// secondaryContainer:\t\t${Theme.of(context).colorScheme.secondaryContainer}
// onSecondary:\t\t\t\t${Theme.of(context).colorScheme.onSecondary}
// onSecondaryContainer:\t${Theme.of(context).colorScheme.onSecondaryContainer}
// tertiary:\t\t\t\t${Theme.of(context).colorScheme.tertiary}
// tertiaryContainer:\t\t${Theme.of(context).colorScheme.tertiaryContainer}
// onTertiary:\t\t\t\t${Theme.of(context).colorScheme.onTertiary}
// onTertiaryContainer:\t\t${Theme.of(context).colorScheme.onTertiaryContainer}
// error:\t\t\t\t\t${Theme.of(context).colorScheme.error}
// errorContainer:\t\t\t${Theme.of(context).colorScheme.errorContainer}
// onError:\t\t\t\t\t${Theme.of(context).colorScheme.onError}
// onErrorContainer:\t\t${Theme.of(context).colorScheme.onErrorContainer}
// background:\t\t\t\t${Theme.of(context).colorScheme.background}
// onBackground:\t\t\t${Theme.of(context).colorScheme.onBackground}
// surface:\t\t\t\t\t${Theme.of(context).colorScheme.surface}
// surfaceTint:\t\t\t\t${Theme.of(context).colorScheme.surfaceTint}
// surfaceVariant:\t\t\t${Theme.of(context).colorScheme.surfaceVariant}
// onSurface:\t\t\t\t${Theme.of(context).colorScheme.onSurface}
// onSurfaceVariant:\t\t${Theme.of(context).colorScheme.onSurfaceVariant}
// inverseSurface:\t\t\t${Theme.of(context).colorScheme.inverseSurface}
// onInverseSurface:\t\t${Theme.of(context).colorScheme.onInverseSurface}
// outline:\t\t\t\t\t${Theme.of(context).colorScheme.outline}
// shadow:\t\t\t\t\t${Theme.of(context).colorScheme.shadow}
//       ''');
    // TODO: change text animation functionality
    return Column(
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: locals
                  .map(
                    (locale) => FadeAnimatedText(
                      getSetupFeedbackLocale(locale),
                      textStyle: TextStyle(
                        fontFamily: getFontFamily(locale),
                        fontSize: 80.0,
                        letterSpacing: 3.7,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      fadeInEnd: 0.05,
                      fadeOutBegin: 0.85,
                      duration: const Duration(seconds: animatedTextDuration),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          child: Align(
            alignment: Alignment.topCenter,
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: locals
                  .map(
                    (locale) => FadeAnimatedText(
                      getSetupStartSurveyLocale(locale),
                      textStyle: TextStyle(
                        fontFamily: getFontFamily(locale),
                        fontSize: 64.0,
                        letterSpacing: 5,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                      fadeInEnd: 0.05,
                      fadeOutBegin: 0.85,
                      duration: const Duration(seconds: animatedTextDuration),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const Flexible(
          fit: FlexFit.tight,
          child: _SurveySetupButtons(),
        ),
      ],
    );
  }
}

class LanguageButtonClass {
  const LanguageButtonClass(
    this.local,
    this.buttonText,
    this.flag,
  );

  final Local local;
  final String buttonText;
  final String flag;
}

const List<LanguageButtonClass> buttons = [
  LanguageButtonClass(
    Local.ar,
    'ابدأ',
    'assets/flags/saudi-arabia-flag-icon-256.png',
  ),
  LanguageButtonClass(
    Local.en,
    'Start',
    'assets/flags/united-kingdom-flag-icon-256.png',
  ),
  LanguageButtonClass(
    Local.ur,
    'شروع كرين',
    'assets/flags/pakistan.png',
  ),
  LanguageButtonClass(
    Local.tl,
    'Magsimula',
    'assets/flags/philippines.png',
  ),
];

class _SurveySetupButtons extends StatelessWidget {
  const _SurveySetupButtons({Key? key}) : super(key: key);

  List<Widget> _getButtons(
    List<Local> locals,
    BuildContext context,
  ) {
    return locals.map<Widget>((local) {
      LanguageButtonClass b = buttons.firstWhere(
        (element) => element.local == local,
      );
      final ColorScheme colorScheme = Theme.of(context).colorScheme;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 208.0,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8.0),
              color: colorScheme.background,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: MaterialButton(
              height: 88,
              onPressed: () async {
                BlocProvider.of<SurveyCubit>(context).onStartSurvey(local);
                // TODO: apply audio skeleton
                AudioPlayer().play(AssetSource('audios/click1.mp3'));
                // TODO: const setup button duration
                await Future.delayed(const Duration(milliseconds: 625));
              },
              enableFeedback: false,
              splashColor: const Color(0xFF2C9665),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                b.buttonText,
                style: TextStyle(
                  fontSize: 28.0,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontFamily: getFontFamily(b.local),
                  // fontFamily :getDirectionally(Local.ar) == TextDirection.ltr
                  //   ? 'Montserrat'
                  //   : 'Vazirmatn',
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Container(
            decoration: BoxDecoration(border: Border.all()),
            child: Image.asset(
              b.flag,
              fit: BoxFit.fill,
              height: 38.0,
              width: 64.0,
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Local> locals = List.from(
      context.select(
        (DeviceBloc bloc) => bloc.state.deviceInfo.locals,
      ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _getButtons(locals, context),
      // children: locals.map<Widget>((local) {
      //   LanguageButtonClass b =
      //       buttons.firstWhere((element) => element.local == local);
      //   return Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Container(
      //         width: 208.0,
      //         decoration: BoxDecoration(
      //           border: Border.all(),
      //           borderRadius: BorderRadius.circular(8.0),
      //           color: Theme.of(context).backgroundColor,
      //           boxShadow: const [
      //             BoxShadow(
      //               color: Colors.grey,
      //               blurRadius: 2.0,
      //               offset: Offset(2, 2),
      //             ),
      //           ],
      //         ),
      //         child: MaterialButton(
      //           height: 88,
      //           onPressed: () async {
      //             BlocProvider.of<SurveyCubit>(context).onStartSurvey(local);
      //             // TODO: apply audio skeleton
      //             AudioPlayer().play(AssetSource('audios/click1.mp3'));
      //             // TODO: const setup button duration
      //             await Future.delayed(const Duration(milliseconds: 625));
      //           },
      //           enableFeedback: false,
      //           splashColor: const Color(0xFF2C9665),
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(8.0),
      //           ),
      //           child: Text(
      //             b.buttonText,
      //             style: TextStyle(
      //               fontSize: 28.0,
      //               color: Theme.of(context).primaryColor,
      //               fontWeight: FontWeight.bold,
      //               fontFamily: getDirectionally(Local.ar) == TextDirection.ltr
      //                   ? 'Montserrat'
      //                   : 'Vazirmatn',
      //             ),
      //           ),
      //         ),
      //       ),
      //       const SizedBox(
      //         height: 8.0,
      //       ),
      //       Container(
      //         decoration: BoxDecoration(border: Border.all()),
      //         child: Image.asset(
      //           b.flag,
      //           fit: BoxFit.fill,
      //           height: 38.0,
      //           width: 64.0,
      //         ),
      //       ),
      //     ],
      //   );
      // }).toList(),
    );
  }
}

// class _TextFamily {
//   const _TextFamily(this.text, this.fontFamily);
//
//   final String text;
//   final String fontFamily;
// }
