part of 'questions_layout.dart';

class QuestionCheckboxPicLayout extends StatelessWidget {
  const QuestionCheckboxPicLayout({
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
          // child: customQuestionWidget(context, questionDetails),
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
                          BlocProvider.of<SurveyCubit>(context)
                              .onTimerRefresh();
                          BlocProvider.of<SurveyCubit>(context)
                              .onAddAnswerToReview(answers[i].id);
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
                          BlocProvider.of<SurveyCubit>(context)
                              .onAddAnswerToReview(answers[i].id);
                          BlocProvider.of<SurveyCubit>(context)
                              .onTimerRefresh();
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
