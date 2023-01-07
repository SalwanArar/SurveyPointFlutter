import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:survey_point_05/src/modules/blocs/device_bloc/device_bloc.dart';
import 'package:survey_point_05/src/utils/services/business_locale.dart';

import '../../../../constants/assets_path.dart';
import '../../../../constants/const_values.dart';
import '../../../../constants/enums.dart';
import '../../../../utils/services/functions.dart';

class OutOfServicePage extends StatelessWidget {
  const OutOfServicePage({Key? key}) : super(key: key);

  static Route<void> route() => MaterialPageRoute(
        builder: (context) => const OutOfServicePage(),
      );

  @override
  Widget build(BuildContext context) {
    List<Local> locals = List.from(
      context.select<DeviceBloc, List<Local>>(
        (DeviceBloc bloc) => bloc.state.deviceInfo.locals,
      ),
    );
    if (locals.isEmpty) {
      locals.addAll([
        Local.ar,
        Local.en,
      ]);
    }
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Align(
    //       alignment: Alignment.bottomCenter,
    //       child: Image.asset(
    //         assetWarningSign,
    //         // TODO: const assetsWarningOutOfService = 192
    //         height: 192.0,
    //         width: 192.0,
    //       ),
    //     ),
    //     SizedBox(height: 32.0),
    //     Align(
    //       alignment: Alignment.bottomCenter,
    //       child: AnimatedTextKit(
    //         repeatForever: true,
    //         animatedTexts: locals
    //             .map<AnimatedText>(
    //               (local) => FadeAnimatedText(
    //                 getOutOfServiceMsgLocale(local),
    //                 // TODO: add headline to config headline1 font size 55
    //                 textStyle: Theme.of(context).textTheme.headline1!.copyWith(
    //                       fontSize: 55.0,
    //                       fontFamily: getFontFamily(local),
    //                     ),
    //                 textAlign: TextAlign.center,
    //                 fadeInEnd: 0.05,
    //                 fadeOutBegin: 0.85,
    //                 duration: const Duration(seconds: animatedTextDuration),
    //               ),
    //             )
    //             .toList(),
    //       ),
    //     ),
    //     Container(
    //       padding: const EdgeInsets.only(top: 16.0),
    //       alignment: Alignment.topCenter,
    //       child: AnimatedTextKit(
    //         repeatForever: true,
    //         animatedTexts: locals
    //             .map<FadeAnimatedText>(
    //               (local) => FadeAnimatedText(
    //                 getThankYouLocale(local),
    //                 // TODO: add headline to config headline1 font size 55
    //                 textStyle: Theme.of(context).textTheme.headline1!.copyWith(
    //                       fontSize: 55.0,
    //                       fontFamily: getFontFamily(local),
    //                     ),
    //                 textAlign: TextAlign.center,
    //                 fadeInEnd: 0.05,
    //                 fadeOutBegin: 0.85,
    //                 duration: const Duration(seconds: animatedTextDuration),
    //               ),
    //             )
    //             .toList(),
    //       ),
    //     ),
    //   ],
    // );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              assetWarningSign,
              // TODO: const assetsWarningOutOfService = 192
              height: 192.0,
              width: 192.0,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Align(
            alignment: Alignment.topCenter,
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: locals
                  .map<AnimatedText>(
                    (local) => FadeAnimatedText(
                      getOutOfServiceMsgLocale(local),
                      // TODO: add headline to config headline1 font size 55
                      textStyle:
                          Theme.of(context).textTheme.headline1!.copyWith(
                                fontSize: 55.0,
                                fontFamily: getFontFamily(local),
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
        // const SizedBox(height: 16.0),
        // Flexible(
        //   flex: 1,
        //   fit: FlexFit.tight,
        //   child: Container(
        //     padding: const EdgeInsets.only(top: 16.0),
        //     alignment: Alignment.topCenter,
        //     child: AnimatedTextKit(
        //       repeatForever: true,
        //       animatedTexts: locals
        //           .map<FadeAnimatedText>(
        //             (local) => FadeAnimatedText(
        //               getThankYouLocale(local),
        //               // TODO: add headline to config headline1 font size 55
        //               textStyle:
        //                   Theme.of(context).textTheme.headline1!.copyWith(
        //                         fontSize: 55.0,
        //                         fontFamily: getFontFamily(local),
        //                       ),
        //               textAlign: TextAlign.center,
        //               fadeInEnd: 0.05,
        //               fadeOutBegin: 0.85,
        //               duration: const Duration(seconds: animatedTextDuration),
        //             ),
        //           )
        //           .toList(),
        //     ),
        //   ),
        // ),
        // Text(
        //   AppLocalizations.of(context)!.thankYou,
        //   // TODO: add headline to config headline1 font size 55
        //   style: Theme.of(context)
        //       .textTheme
        //       .headline1!
        //       .copyWith(fontSize: 55.0),
        //   textAlign: TextAlign.center,
        // ),
      ],
    );
  }
}
