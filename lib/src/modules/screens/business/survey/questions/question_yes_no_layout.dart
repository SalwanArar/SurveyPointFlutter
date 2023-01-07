part of 'questions_layout.dart';

class QuestionYesNoLayout extends StatelessWidget {
  const QuestionYesNoLayout({
    Key? key,
    required this.questionDetails,
  }) : super(key: key);
  final String questionDetails;

  // AudioPlayer audio = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          // child: customQuestionWidget(context, questionDetails),
          child: CustomQuestionWidget(questionDetails: questionDetails),
          // child: Container(color: Colors.cyan,),
        ),
        Flexible(
          flex: 5,
          fit: FlexFit.tight,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                _YesOrNo(
                  // context,
                  index: 1,
                  // AppLocalizations.of(context)!.yes,
                  color: Color(0xFF009A1E),
                  // audio,
                ),
                SizedBox(width: 128.0),
                _YesOrNo(
                  // context,
                  index: 2,
                  // AppLocalizations.of(context)!.no,
                  color: Color(0xFFDC0000),
                  // audio,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// class _YesOrNo extends StatefulWidget {
//   const _YesOrNo({Key? key, required this.index, required this.color})
//       : super(key: key);
//   final int index;
//   final Color color;
//
//   @override
//   State<_YesOrNo> createState() => _YesOrNoState();
// }

class _YesOrNo extends StatelessWidget {
  const _YesOrNo({Key? key, required this.index, required this.color})
      : super(key: key);

  final int index;
  final Color color;

  @override
  Widget build(BuildContext context) {
    AudioPlayer audio = AudioPlayer();
    Local local = context.select(
      (SurveyCubit cubit) => cubit.state.local,
    );
    var surveyCubit = context.watch<SurveyCubit>();
    bool isSelected = context
        .select((SurveyCubit cubit) => cubit.state.answersId.contains(index));
    // surveyCubit.state.answersId.contains(widget.index);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Material(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              enableFeedback: false,
              borderRadius: BorderRadius.circular(16.0),
              splashColor: const Color(0x332C9665),
              onTap: () async {
                surveyCubit.onReplaceAnswer(index);
                BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                if (audio.state == PlayerState.playing) {
                  await audio.dispose();
                }
                await audio.play(AssetSource('audios/keyboard.mp3'));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: formAnimationDuration),
                width: isSelected ? 180 : 160,
                height: isSelected ? 180 : 160,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                    width: isSelected ? borderWidth : 2,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  index == 1 ? getYesLocale(local) : getNoLocale(local),
                  // TODO: headline2
                  style: TextStyle(
                    color: color,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w400,
                    fontSize: 42.0,
                    fontFamily: getFontFamily(local),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 5,
          left: 5,
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
                size: 32.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
