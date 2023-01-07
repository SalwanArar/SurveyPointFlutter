part of 'questions_layout.dart';

class QuestionSatisfactionLayout extends StatelessWidget {
  const QuestionSatisfactionLayout({
    Key? key,
    required this.questionDetails,
  }) : super(key: key);
  final String questionDetails;

  @override
  Widget build(BuildContext context) {
    final Local local = context.select<SurveyCubit, Local>(
      (cubit) => cubit.state.local,
    );
    return Column(
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: CustomQuestionWidget(questionDetails: questionDetails),
        ),
        Flexible(
          flex: 5,
          fit: FlexFit.tight,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _SatisfactionEmojiBig(
                  satisfactionEmoji: SatisfactionEmoji.angry,
                ),
                _SatisfactionEmojiBig(
                  satisfactionEmoji: SatisfactionEmoji.unsatisfied,
                ),
                _SatisfactionEmojiBig(
                  satisfactionEmoji: SatisfactionEmoji.natural,
                ),
                _SatisfactionEmojiBig(
                  satisfactionEmoji: SatisfactionEmoji.satisfied,
                ),
                _SatisfactionEmojiBig(
                  satisfactionEmoji: SatisfactionEmoji.happy,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

}

// const List<String> _satisfactionImages = [
//   assetsVeryUnsatisfied,
//   assetsUnsatisfied,
//   assetsNatural,
//   assetsSatisfied,
//   assetsVerySatisfied,
// ];

class _SatisfactionEmojiBig extends StatelessWidget {
  const _SatisfactionEmojiBig({
    Key? key,
    required this.satisfactionEmoji,
  }) : super(key: key);
  final SatisfactionEmoji satisfactionEmoji;

  String getText(Local local) {
    switch (satisfactionEmoji) {
      case SatisfactionEmoji.angry:
        return getAngryLocale(local);
      case SatisfactionEmoji.unsatisfied:
        return getUnsatisfiedLocale(local);
      case SatisfactionEmoji.natural:
        return getNaturalLocale(local);
      case SatisfactionEmoji.satisfied:
        return getSatisfiedLocale(local);
      case SatisfactionEmoji.happy:
        return getHappyLocale(local);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelected = context
        .watch<SurveyCubit>()
        .state
        .answersId
        .contains(satisfactionEmoji.toIndex);
    final Local local = context.select(
      (SurveyCubit cubit) => cubit.state.local,
    );
    final AudioPlayer audio = AudioPlayer();
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            fit: StackFit.passthrough,
            children: [
              Positioned(
                top: 5.0,
                left: 5.0,
                child: Visibility(
                  visible: isSelected ? true : false,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.solidCircleCheck,
                      color: Theme.of(context).colorScheme.primary,
                      size: 26.0,
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: formAnimationDuration),
                height: isSelected ? 160 : 128,
                width: isSelected ? 160 : 128,
                decoration: isSelected
                    ? BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: borderWidth,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      )
                    : null,
                child: GestureDetector(
                  onTap: () async {
                    BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                    BlocProvider.of<SurveyCubit>(context)
                        .onReplaceAnswer(satisfactionEmoji.toIndex);
                    if (audio.state == PlayerState.playing) {
                      await audio.dispose();
                    }
                    await audio.play(AssetSource('audios/keyboard.mp3'));
                  },
                  // child: Image.asset(
                  //   _satisfactionImages[satisfactionEmoji.toIndex - 8],
                  // ),
                  child: Image.asset(satisfactionEmoji.toEmojiAssets),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              getText(local),
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 22.0,
                fontWeight: isSelected ? FontWeight.bold : null,
                fontFamily: getFontFamily(Local.en),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
