import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_point_05/src/modules/blocs/survey_cubit/survey_cubit.dart';

import '../../../constants/enums.dart';
import '../../../utils/services/business_locale.dart';
import '../../../utils/services/functions.dart';

class BusinessThankLayout extends StatefulWidget {
  const BusinessThankLayout({Key? key, required this.isSurvey})
      : super(key: key);

  final bool isSurvey;

  static Route<void> route(bool isSurvey) =>
      MaterialPageRoute(
        builder: (_) =>
            BusinessThankLayout(
              isSurvey: isSurvey,
            ),
      );

  @override
  State<BusinessThankLayout> createState() => _BusinessThankLayoutState();
}

class _BusinessThankLayoutState extends State<BusinessThankLayout> {
  final AudioPlayer audio = AudioPlayer();
  late Local local = Local.ar;
  late String thankStatus = 'empty';

  @override
  void initState() {
    super.initState();
    if (widget.isSurvey) {
      local = context.read<SurveyCubit>().state.local;
          // context.select((SurveyCubit cubit) => cubit.state.local);
      thankStatus = context.read<SurveyCubit>().state.thankYouStatus.name;
          // context.select((SurveyCubit cubit) =>
          // cubit.state.thankYouStatus
          //     .name,);
    }
    _audioPlay(true);
  }

  Future<void> _audioPlay(bool isStart) async {
    if (audio.state == PlayerState.playing) {
      await audio.dispose();
    }
    if (isStart) {
      await audio.play(AssetSource('audios/confirmation-tone.mp3'));
    } else {
      await audio
          .play(AssetSource('audios/mixkit-single-classic-click-1116.mp3'));
    }
  }

  @override
  void dispose() {
    _audioPlay(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Text(
            getDoneMsgLocal(local) + thankStatus,
            style: Theme
                .of(context)
                .textTheme
                .headline5!
                .copyWith(
              color: Theme
                  .of(context)
                  .colorScheme
                  .primary,
              fontFamily: getFontFamily(local),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Directionality(
          textDirection: getDirectionally(
            local,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getThankYouLocale(local),
                style: TextStyle(
                  fontSize: 80.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: getFontFamily(local),
                ),
              ),
              Text(
                getGoodbyeLocale(local),
                style: TextStyle(
                  fontSize: 80.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: getFontFamily(local),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
