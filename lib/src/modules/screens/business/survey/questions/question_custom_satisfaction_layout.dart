part of 'questions_layout.dart';

class QuestionCustomSatisfactionLayout extends StatefulWidget {
  const QuestionCustomSatisfactionLayout({
    Key? key,
    required this.questionDetails,
    required this.answers,
    required this.answersDetails,
  }) : super(key: key);
  final String questionDetails;
  final List<Answer> answers;
  final List<String> answersDetails;

  @override
  State<QuestionCustomSatisfactionLayout> createState() =>
      _QuestionCustomSatisfactionLayoutState();
}

class _QuestionCustomSatisfactionLayoutState
    extends State<QuestionCustomSatisfactionLayout> {
  int itemIndex = -1;
  List<Widget> items = [];

  @override
  Widget build(BuildContext context) {
    AudioPlayer audio = AudioPlayer();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: CustomQuestionWidget(questionDetails: widget.questionDetails),
        ),
        Flexible(
          flex: 5,
          fit: FlexFit.tight,
          child: Padding(
            padding: answerPicPadding(MediaQuery.of(context).size.width),
            child: Builder(
              builder: (builderContext) {
                List<Widget> firstRow = [];
                List<Widget> secondRow = [];
                if (widget.answers.length == 1) {
                  return _OnlyOptionSatisfaction(
                    answerDetails: widget.answersDetails.first,
                    questionId: widget.answers.first.id,
                    answerPicUrl: widget.answers.first.pictureId,
                  );
                }
                for (int i = 0; i < widget.answers.length; i++) {
                  // items.add(
                  //   _SelectedSatisfactionOption(
                  //     answerDetails: widget.answersDetails[i],
                  //     questionId: widget.answers[i].id,
                  //     answerPicUrl: widget.answers[i].pictureId,
                  //   ),
                  // );
                  onTap() async {
                    BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                    BlocProvider.of<SurveyCubit>(context).onRemoveAnswers();
                    if (BlocProvider.of<SurveyCubit>(context)
                        .state
                        .questionsId
                        .contains(widget.answers[i].id)) {
                      BlocProvider.of<SurveyCubit>(context)
                          .onRemoveReview(widget.answers[i].id);
                    } else {
                      itemIndex = i;
                      BlocProvider.of<SurveyCubit>(context).onDialogVisible(
                        _SelectedSatisfactionOption(
                          answerDetails: widget.answersDetails[i],
                          questionId: widget.answers[i].id,
                          answerPicUrl: widget.answers[i].pictureId,
                        ),
                      );
                      // showDialog(
                      //   context: context,
                      //   barrierDismissible: false,
                      //   builder: (_) => BlocProvider.value(
                      //     value: BlocProvider.of<SurveyCubit>(context),
                      //     child: _SelectedSatisfactionOption(
                      //       answerDetails: answersDetails[i],
                      //       questionId: answers[i].id,
                      //       answerPicUrl: answers[i].pictureId,
                      //     ),
                      //   ),
                      // );
                    }
                    if (audio.state == PlayerState.playing) {
                      await audio.dispose();
                    }
                    await audio.play(AssetSource('audios/keyboard.mp3'));
                  }

                  if (i < 4) {
                    firstRow.add(
                      BlocBuilder<SurveyCubit, SurveyState>(
                        buildWhen: (current, previous) =>
                            current.review != previous.review,
                        builder: (context, state) {
                          int? value;
                          try {
                            value = state.review.reviewedQuestions
                                .firstWhere((element) =>
                                    element.questionId == widget.answers[i].id)
                                .answers
                                .first;
                          } catch (_) {}
                          return _QuestionCardPic(
                            answerDetails: widget.answersDetails[i],
                            id: widget.answers[i].id,
                            answerUrl: widget.answers[i].pictureId,
                            isCustom: true,
                            onTap: onTap,
                            checkWidget: _getSatisfactionCheck(value),
                          );
                        },
                      ),
                    );
                  }
                  if (i >= 4) {
                    secondRow.add(
                      BlocBuilder<SurveyCubit, SurveyState>(
                        buildWhen: (current, previous) =>
                            current.review != previous.review,
                        builder: (context, state) {
                          int? value;
                          try {
                            value = state.review.reviewedQuestions
                                .firstWhere((element) =>
                                    element.questionId == widget.answers[i].id)
                                .answers
                                .first;
                          } catch (_) {}
                          return _QuestionCardPic(
                            answerDetails: widget.answersDetails[i],
                            id: widget.answers[i].id,
                            answerUrl: widget.answers[i].pictureId,
                            isCustom: true,
                            onTap: onTap,
                            checkWidget: _getSatisfactionCheck(value),
                          );
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


class _OnlyOptionSatisfaction extends StatelessWidget {
  const _OnlyOptionSatisfaction({
    Key? key,
    required this.answerDetails,
    required this.questionId,
    required this.answerPicUrl,
  }) : super(key: key);
  final String answerDetails;
  final String? answerPicUrl;
  final int questionId;

  @override
  Widget build(BuildContext context) {
    final Local local = context.select(
          (SurveyCubit cubit) => cubit.state.local,
    );
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 288 * 0.75,
            height: 240 * 0.75,
            // margin: const EdgeInsets.symmetric(vertical: 32.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: colorScheme.secondary,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: CachedNetworkImage(
              imageUrl: answerPicUrl ??
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
                margin: const EdgeInsets.all(16.0),
                constraints: const BoxConstraints.expand(),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Text(
            answerDetails,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.w500,
              fontFamily: getFontFamily(local),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: 672,
            height: 160,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                _SatisfactionEmojiSmall(
                  satisfactionEmoji: SatisfactionEmoji.angry,
                ),
                SizedBox(width: 8.0),
                _SatisfactionEmojiSmall(
                  satisfactionEmoji: SatisfactionEmoji.unsatisfied,
                ),
                SizedBox(width: 8.0),
                _SatisfactionEmojiSmall(
                  satisfactionEmoji: SatisfactionEmoji.natural,
                ),
                SizedBox(width: 8.0),
                _SatisfactionEmojiSmall(
                  satisfactionEmoji: SatisfactionEmoji.satisfied,
                ),
                SizedBox(width: 8.0),
                _SatisfactionEmojiSmall(
                  satisfactionEmoji: SatisfactionEmoji.happy,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


Widget? _getSatisfactionCheck(int? value) {
  if (value == null) return null;
  return Image.asset(
    '$assetsDirImages${value - 7}_s.png',
    height: 24.0,
    width: 24.0,
  );
}

class _SelectedContainer extends StatelessWidget {
  const _SelectedContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border.all(
          color: Colors.black12,
          width: 4.0,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(28.0),
        ),
        boxShadow: [
          BoxShadow(
            blurStyle: BlurStyle.normal,
            // offset: Offset(1.0, 1.0),
            blurRadius: 2,
            spreadRadius: 5,
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
        ],
      ),
      child: child,
    );
  }
}

// class _SelectedSatisfactionOption extends StatefulWidget {
//   const _SelectedSatisfactionOption({
//     Key? key,
//     required this.answerDetails,
//     required this.questionId,
//     this.answerPicUrl,
//   }) : super(key: key);
//
//   final String answerDetails;
//   final String? answerPicUrl;
//   final int questionId;
//
//   @override
//   State<_SelectedSatisfactionOption> createState() =>
//       _SelectedSatisfactionOptionState();
// }

class _SelectedSatisfactionOption extends StatelessWidget {
  const _SelectedSatisfactionOption({
    Key? key,
    required this.answerDetails,
    required this.questionId,
    this.answerPicUrl,
  }) : super(key: key);

  final String answerDetails;
  final String? answerPicUrl;
  final int questionId;

  @override
  Widget build(BuildContext context) {
    Local local = context.select(
      (SurveyCubit cubit) => cubit.state.local,
    );
    return _SelectedContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          optionTitle(
            title: answerDetails,
            local: local,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              optionPicture(
                answerPicUrl: answerPicUrl,
                colorScheme: Theme.of(context).colorScheme,
              ),
              SizedBox(
                width: 672,
                height: 160,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    _SatisfactionEmojiSmall(
                      satisfactionEmoji: SatisfactionEmoji.angry,
                    ),
                    SizedBox(width: 8.0),
                    _SatisfactionEmojiSmall(
                      satisfactionEmoji: SatisfactionEmoji.unsatisfied,
                    ),
                    SizedBox(width: 8.0),
                    _SatisfactionEmojiSmall(
                      satisfactionEmoji: SatisfactionEmoji.natural,
                    ),
                    SizedBox(width: 8.0),
                    _SatisfactionEmojiSmall(
                      satisfactionEmoji: SatisfactionEmoji.satisfied,
                    ),
                    SizedBox(width: 8.0),
                    _SatisfactionEmojiSmall(
                      satisfactionEmoji: SatisfactionEmoji.happy,
                    ),
                  ],
                ),
              ),
            ],
          ),
          DoneButton(
            questionId: questionId,
          ),
        ],
      ),
    );
  }
}

class _SatisfactionEmojiSmall extends StatelessWidget {
  const _SatisfactionEmojiSmall({
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
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  BlocProvider.of<SurveyCubit>(context).onReplaceAnswer(
                    satisfactionEmoji.toIndex,
                  );
                  BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                  if (audio.state == PlayerState.playing) {
                    await audio.dispose();
                  }
                  await audio.play(AssetSource('audios/keyboard.mp3'));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: formAnimationDuration),
                  width: isSelected ? 112.0 : 96.0,
                  height: isSelected ? 112.0 : 96.0,
                  alignment: Alignment.center,
                  decoration: isSelected
                      ? BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        )
                      : null,
                  child: Image.asset(satisfactionEmoji.toEmojiAssets),
                ),
              ),
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
                      size: 19.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0, right: 3.0),
            child: Text(
              getText(local),
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: isSelected ? FontWeight.bold : null,
                fontFamily: getFontFamily(local),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
