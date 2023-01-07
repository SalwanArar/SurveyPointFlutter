part of 'custom_widgets.dart';

class TimerDialog extends StatefulWidget {
  const TimerDialog({Key? key}) : super(key: key);

  @override
  State<TimerDialog> createState() => _TimerDialogState();
}

class _TimerDialogState extends State<TimerDialog> {
  AudioPlayer audio = AudioPlayer();

  int counter = timerDuration;
  Timer? countDownTimer;
  late Duration duration;

  void startTimer() {
    duration = const Duration(seconds: timerDuration);
    countDownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setCountDown(),
    );
  }

  void stopTimer() => setState(() => countDownTimer!.cancel());

  void setCountDown() {
    const reduceSecondsBy = 1;
    final seconds = duration.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      countDownTimer!.cancel();
      // TODO: add register time out
      if (mounted) {
        BlocProvider.of<SurveyCubit>(context).onSubmitReview();
      }
    } else {
      duration = Duration(seconds: seconds);
      setState(() {
        counter = seconds;
      });
      //TODO: remove print
      debugPrint('Seconds:\t$seconds');
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    if (countDownTimer != null) countDownTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Local local = BlocProvider.of<SurveyCubit>(context).state.local;
    String fontFaimly = getFontFamily(local);
    return AlertDialog(
      elevation: 50.0,
      clipBehavior: Clip.hardEdge,
      title: Text(
        getTimerMsgLocale(local),
        // style: theme.textTheme.displayMedium!.copyWith(
        //   color: theme.colorScheme.onPrimaryContainer,
        // ),
        style: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontFamily: fontFaimly,
        ),
      ),
      backgroundColor: colorScheme.primaryContainer,
      content: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Center(
          heightFactor: 0.5,
          child: Text(
            '$counter',
            // style: theme.textTheme.displayMedium!.copyWith(
            //   color: colorScheme.tertiary,
            // ),
            style: TextStyle(
              fontFamily: fontFaimly,
              fontSize: 28.0,
              color: colorScheme.tertiary,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            BlocProvider.of<SurveyCubit>(context).onTimerDismiss();
            BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
            if (audio.state == PlayerState.playing) {
              await audio.dispose();
            }
            await audio.play(AssetSource('audios/click1.mp3'));
          },
          child: Text(
            getYesLocale(local),
            style: TextStyle(
              fontFamily: fontFaimly,
              fontSize: 22.0,
            ),
          ),
        ),
      ],
    );
  }
}
