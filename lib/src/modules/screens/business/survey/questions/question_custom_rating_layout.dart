part of 'questions_layout.dart';

class QuestionCustomRatingLayout extends StatefulWidget {
  const QuestionCustomRatingLayout({
    Key? key,
    required this.questionDetails,
    required this.answers,
    required this.answersDetails,
  }) : super(key: key);
  final String questionDetails;
  final List<Answer> answers;
  final List<String> answersDetails;

  @override
  State<QuestionCustomRatingLayout> createState() =>
      _QuestionCustomRatingLayoutState();
}

class _QuestionCustomRatingLayoutState
    extends State<QuestionCustomRatingLayout> {
  List<Widget> items = [];
  int itemIndex = -1;

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
              builder: (context) {
                List<Widget> firstRow = [];
                List<Widget> secondRow = [];
                if (widget.answers.length == 1) {
                  return _OnlyOptionRate(
                    answerDetails: widget.answersDetails.first,
                    questionId: widget.answers.first.id,
                    answerPicUrl: widget.answers.first.pictureId,
                  );
                }
                for (int i = 0; i < widget.answers.length; i++) {
                  items.add(
                    _SelectedOption(
                      answerDetails: widget.answersDetails[i],
                      questionId: widget.answers[i].id,
                      answerPicUrl: widget.answers[i].pictureId,
                    ),
                  );
                  onTap() async {
                    BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                    // BlocProvider.of<SurveyCubit>(context)
                    //     .changeTimerStatus(BusinessTimer.restart);
                    BlocProvider.of<SurveyCubit>(context).onRemoveAnswers();
                    if (BlocProvider.of<SurveyCubit>(context)
                        .state
                        .questionsId
                        .contains(
                          widget.answers[i].id,
                        )) {
                      // selectOption = false;
                      BlocProvider.of<SurveyCubit>(context).onRemoveReview(
                        widget.answers[i].id,
                      );
                    } else {
                      // selectOption = true;

                      BlocProvider.of<SurveyCubit>(context).onDialogVisible(
                        _SelectedOption(
                          answerDetails: widget.answersDetails[i],
                          questionId: widget.answers[i].id,
                          answerPicUrl: widget.answers[i].pictureId,
                        ),
                      );
                      itemIndex = i;
                      // showDialog(
                      //   context: context,
                      //   barrierDismissible: false,
                      //   builder: (_) => BlocProvider.value(
                      //     value: BlocProvider.of<SurveyCubit>(context),
                      //     child: _SelectedOption(
                      //       answerDetails: widget.answersDetails[i],
                      //       questionId: widget.answers[i].id,
                      //       answerPicUrl: widget.answers[i].pictureId,
                      //     ),
                      //   ),
                      // );
                    }

                    if (audio.state == PlayerState.playing) {
                      await audio.dispose();
                    }
                    await audio.play(
                      AssetSource(
                        'audios/keyboard.mp3',
                      ),
                    );
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
                            checkWidget: _getRatingValue(value),
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
                            checkWidget: _getRatingValue(value),
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
                        children: firstRow,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: secondRow,
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

Widget? _getRatingValue(int? value) {
  if (value == null) return null;
  return Container(
    height: 24.0,
    width: 24.0,
    margin: const EdgeInsets.only(top: 2, left: 2),
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(4.0),
      color: RatingColor.values[value - 3].getRealColor(),
    ),
    child: Center(
      child: Text(
        (value - 2).toString(),
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'Montserrat',
          height: 1.0,
        ),
      ),
    ),
  );
}

class _OnlyOptionRate extends StatelessWidget {
  const _OnlyOptionRate({
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _RatingButton(RatingColor.rating1, true),
                _RatingButton(RatingColor.rating2, true),
                _RatingButton(RatingColor.rating3, true),
                _RatingButton(RatingColor.rating4, true),
                _RatingButton(RatingColor.rating5, true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedOption extends StatelessWidget {
  const _SelectedOption({
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
    return _SelectedContainer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          optionTitle(
            title: answerDetails,
            local: local,
          ),
          optionPicture(
            answerPicUrl: answerPicUrl,
            colorScheme: Theme.of(context).colorScheme,
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            width: 672,
            height: 160,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _RatingButton(RatingColor.rating1, true),
                _RatingButton(RatingColor.rating2, true),
                _RatingButton(RatingColor.rating3, true),
                _RatingButton(RatingColor.rating4, true),
                _RatingButton(RatingColor.rating5, true),
              ],
            ),
          ),
          DoneButton(
            questionId: questionId,
          ),
        ],
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  const _RatingButton(
    this.ratingColor,
    this.isSmall, {
    Key? key,
  }) : super(key: key);

  final RatingColor ratingColor;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = context
        .watch<SurveyCubit>()
        .state
        .answersId
        .contains(ratingColor.toIndex);
    final Local local = context.select<SurveyCubit, Local>(
      (cubit) => cubit.state.local,
    );
    final AudioPlayer audio = AudioPlayer();
    var overlay = Overlay.of(context);
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              GestureDetector(
                // enableFeedback: false,
                // splashColor: const Color(0x332C9665),
                onTap: () async {
                  BlocProvider.of<SurveyCubit>(context).onReplaceAnswer(
                    ratingColor.toIndex,
                  );
                  BlocProvider.of<SurveyCubit>(context).onTimerRefresh();

                  if (!isSmall) {
                    var overlayEntry = OverlayEntry(
                      builder: (_) {
                        return Positioned(
                          left: size.width * 0.5 - 32.0,
                          bottom: size.height * 0.6 - 32,
                          child: IgnorePointer(
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                width: 64.0,
                                height: 64.0,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    overlay!.insert(
                      overlayEntry,
                    );
                    await Future.delayed(const Duration(seconds: 4));

                    overlayEntry.remove();
                  }

                  if (audio.state == PlayerState.playing) {
                    await audio.dispose();
                  }
                  await audio.play(AssetSource('audios/keyboard.mp3'));
                },
                child: AnimatedContainer(
                  width: isSelected
                      ? isSmall
                          ? 112.0
                          : 160.0
                      : isSmall
                          ? 96.0
                          : 128,
                  height: isSelected
                      ? isSmall
                          ? 112.0
                          : 160.0
                      : isSmall
                          ? 96.0
                          : 128,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: isSelected ? 3 : 1,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                    color: ratingColor.getRealColor(),
                  ),
                  // TODO: const animation Durations
                  duration: const Duration(milliseconds: formAnimationDuration),
                  child: Text(
                    (ratingColor.toIndex - 2).toString(),
                    // TODO: add textStyle
                    style: TextStyle(
                      fontSize: isSmall ? 20.0 : 32.0,
                      fontWeight:
                          isSelected ? FontWeight.w900 : FontWeight.w300,
                      fontFamily: getFontFamily(Local.en),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 5.0,
                left: 5.0,
                child: Visibility(
                  visible: isSelected,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.solidCircleCheck,
                      color: Theme.of(context).colorScheme.primary,
                      size: isSmall ? 19.2 : 32.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (ratingColor == RatingColor.rating5) ...[
            Container(
              alignment: getReverseAlignment(local),
              padding: EdgeInsets.only(
                top: 8.0,
                right: !isDirectionLtr(local)
                    ? 0.0
                    : isSmall
                        ? isSelected
                            ? 14.0
                            : 21.0
                        : isSelected
                            ? 16.0
                            : 32.0,
                left: isDirectionLtr(local)
                    ? 0.0
                    : isSmall
                        ? isSelected
                            ? 14.0
                            : 21.0
                        : isSelected
                            ? 16.0
                            : 32.0,
              ),
              child: Text(
                getVeryGoodLocale(local),
                style: TextStyle(
                  fontSize: isSmall ? null : 20.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: getFontFamily(local),
                ),
              ),
            ),
          ] else if (ratingColor == RatingColor.rating1) ...[
            Container(
              alignment: getAlignment(local),
              padding: EdgeInsets.only(
                top: 8.0,
                left: !isDirectionLtr(local)
                    ? 0.0
                    : isSmall
                        ? isSelected
                            ? 14.0
                            : 21.0
                        : isSelected
                            ? 16.0
                            : 32.0,
                right: isDirectionLtr(local)
                    ? 0.0
                    : isSmall
                        ? isSelected
                            ? 14.0
                            : 21.0
                        : isSelected
                            ? 16.0
                            : 32.0,
              ),
              child: Text(
                getVeryPoorLocale(local),
                style: TextStyle(
                  fontSize: isSmall ? null : 20.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: getFontFamily(local),
                ),
              ),
            ),
          ] else ...[
            SizedBox(
              height: isSmall ? 28.0 : 42.0,
            ),
          ],
        ],
      ),
    );
  }
}

class DoneButton extends StatelessWidget {
  const DoneButton({
    Key? key,
    required this.questionId,
  }) : super(key: key);
  final int questionId;

  @override
  Widget build(BuildContext context) {
    final isAnswersIdNotEmpty =
        context.watch<SurveyCubit>().state.answersId.isNotEmpty;
    final Local local = context.select<SurveyCubit, Local>(
      (cubit) => cubit.state.local,
    );
    return InkWell(
      onTap: () {
        BlocProvider.of<SurveyCubit>(context)
            .onDialogDismiss(const TimerDialog());
        BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
        AudioPlayer().play(AssetSource('audios/keyboard.mp3'));
        // Navigator.pop(context);
        if (isAnswersIdNotEmpty) {
          BlocProvider.of<SurveyCubit>(context).onAddReview(questionId);
        }
      },
      child: Container(
        width: 160.0,
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isAnswersIdNotEmpty
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            width: isAnswersIdNotEmpty ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          getOkLocale(local),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.button!.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: getFontFamily(local),
                color: isAnswersIdNotEmpty
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
              ),
        ),
      ),
    );
  }
}

// return AlertDialog(
//   title: Text(
//     widget.answerDetails,
//     style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 48.0),
//     textAlign: TextAlign.center,
//   ),
//   alignment: Alignment.center,
//   content: Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       Container(
//         width: 288,
//         height: 240,
//         margin: const EdgeInsets.symmetric(vertical: 32.0),
//         decoration: BoxDecoration(
//           border: Border.all(
//             width: 2,
//             color: Theme.of(context).colorScheme.secondary,
//           ),
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         child: CachedNetworkImage(
//           // width: 240,
//           // height: 240,
//           imageUrl: widget.answerPicUrl ??
//               "https://lirp.cdn-website.com/873f309c/dms3rep/multi/opt/Final+Design-126w.png",
//           progressIndicatorBuilder: (
//               context,
//               url,
//               downloadProgress,
//               ) =>
//               Align(
//                 alignment: Alignment.center,
//                 child: CircularProgressIndicator(
//                   value: downloadProgress.progress,
//                 ),
//               ),
//           imageBuilder: (context, imageProvider) => Container(
//             margin: const EdgeInsets.all(16.0),
//             constraints: const BoxConstraints.expand(),
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: imageProvider,
//                 fit: BoxFit.scaleDown,
//               ),
//             ),
//           ),
//           errorWidget: (context, url, error) => const Icon(Icons.error),
//         ),
//       ),
//       const SizedBox(
//         height: 8.0,
//       ),
//       SizedBox(
//         width: 672,
//         height: 160,
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _ratingButton(3),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0, left: 8.0),
//                   child: Text(
//                     getVeryPoorLocale(local),
//                   ),
//                 ),
//               ],
//             ),
//             _ratingButton(4),
//             _ratingButton(5),
//             _ratingButton(6),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 _ratingButton(7),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0, right: 8.0),
//                   child: Text(
//                     getVeryGoodLocale(local),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       )
//     ],
//   ),
//   actions: [
//     DoneButton(
//       questionId: widget.questionId,
//       // parentContext: context,
//     ),
//   ],
// );
