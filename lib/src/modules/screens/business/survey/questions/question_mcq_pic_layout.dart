part of 'questions_layout.dart';

class QuestionMcqPicLayout extends StatelessWidget {
  const QuestionMcqPicLayout({
    Key? key,
    required this.questionDetails,
    required this.answers,
    required this.answersDetails,
  }) : super(key: key);
  final String questionDetails;
  final List<Answer> answers;
  final List<String> answersDetails;

  @override
  Widget build(BuildContext context) {
    AudioPlayer audio = AudioPlayer();
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: CustomQuestionWidget(questionDetails: questionDetails),
        ),
        Flexible(
          flex: 5,
          fit: FlexFit.tight,
          child: Padding(
            padding: answerPicPadding(MediaQuery.of(context).size.width),
            child: Builder(
              builder: (context) {
                List<Widget> firstRow = [];
                List<Widget> secondRow = [];
                for (int i = 0; i < answers.length; i++) {
                  if (i < 4) {
                    firstRow.add(
                      _QuestionCardPic(
                        answerDetails: answersDetails[i],
                        id: answers[i].id,
                        answerUrl: answers[i].pictureId,
                        onTap: () async {
                          // BlocProvider.of<SurveyCubit>(context)
                          //     .changeTimerStatus(
                          //   BusinessTimer.restart,
                          // );
                          BlocProvider.of<SurveyCubit>(context)
                              .onTimerRefresh();
                          BlocProvider.of<SurveyCubit>(context)
                              .onReplaceAnswer(answers[i].id);
                          if (audio.state == PlayerState.playing) {
                            await audio.dispose();
                          }
                          await audio.play(AssetSource('audios/keyboard.mp3'));
                        },
                      ),
                    );
                  }
                  if (i >= 4) {
                    secondRow.add(
                      _QuestionCardPic(
                        answerDetails: answersDetails[i],
                        id: answers[i].id,
                        answerUrl: answers[i].pictureId,
                        onTap: () async {
                          // BlocProvider.of<SurveyCubit>(context)
                          //     .changeTimerStatus(
                          //   BusinessTimer.restart,
                          // );
                          BlocProvider.of<SurveyCubit>(context)
                              .onTimerRefresh();
                          BlocProvider.of<SurveyCubit>(context)
                              .onReplaceAnswer(answers[i].id);
                          if (audio.state == PlayerState.playing) {
                            await audio.dispose();
                          }
                          await audio.play(AssetSource('audios/keyboard.mp3'));
                        },
                      ),
                    );
                  }
                }
                if (secondRow.isEmpty) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: firstRow,
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: firstRow),
                      const SizedBox(height: 16.0),
                      Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: secondRow),
                    ],
                  );
                }
              },
            ),
          ),
        )
      ],
    );
  }
}

class _QuestionCardPic extends StatelessWidget {
  const _QuestionCardPic({
    Key? key,
    required this.answerDetails,
    required this.id,
    required this.answerUrl,
    required this.onTap,
    this.isCustom = false,
    this.checkWidget,
  }) : super(key: key);
  final String answerDetails;
  final int id;
  final String? answerUrl;
  final bool isCustom;
  final void Function() onTap;
  final Widget? checkWidget;

  @override
  Widget build(BuildContext context) {
    // bool isSelected = isCustom
    //     ? context.watch<SurveyCubit>().state.questionsId.contains(id)
    //     : context.watch<SurveyCubit>().state.answersId.contains(id);
    bool isSelected = context.select((SurveyCubit cubit) {
      var state = cubit.state;
      return isCustom
          ? state.questionsId.contains(id)
          : state.answersId.contains(id);
    });
    Local local = context.select(
      (SurveyCubit cubit) => cubit.state.local,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 160,
                height: 160,
                margin: const EdgeInsets.symmetric(horizontal: 32.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: isSelected ? borderWidth : 1,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: answerUrl ??
                      "https://lirp.cdn-website.com/873f309c/dms3rep/multi/opt/Final+Design-126w.png",
                  progressIndicatorBuilder: (
                    context,
                    url,
                    downloadProgress,
                  ) =>
                      Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                  ),
                  imageBuilder: (context, imageProvider) => Container(
                    // width: 160,
                    // height: 159,
                    margin: const EdgeInsets.all(20.0),
                    constraints: const BoxConstraints.expand(),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Positioned(
              left: 37.0,
              top: 5.0,
              child: Visibility(
                visible: isSelected ? true : false,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: checkWidget ??
                      FaIcon(
                        FontAwesomeIcons.solidCircleCheck,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24.0,
                      ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 160,
          child: Text(
            answerDetails,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  fontFamily: getFontFamily(local),
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
