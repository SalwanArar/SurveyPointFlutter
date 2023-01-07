part of 'questions_layout.dart';

class QuestionCheckboxLayout extends StatelessWidget {
  const QuestionCheckboxLayout({
    Key? key,
    required this.questionDetails,
    required this.answersDetails,
  }) : super(key: key);
  final String questionDetails;
  final List<String> answersDetails;

  @override
  Widget build(BuildContext context) {
    AudioPlayer audio = AudioPlayer();
    Local local = context.select(
      (SurveyCubit cubit) => cubit.state.local,
    );
    final answers = List.from(
      context.select(
        (SurveyCubit cubit) =>
            cubit.state.business.questions[cubit.state.surveyIndex].answers,
      ),
    );
    // context
    // .read<SurveyCubit>()
    // .state
    // .business
    // .questions[context.read<SurveyCubit>().state.questionIndex]
    // .answers);
    return Directionality(
      textDirection: getDirectionally(
        context.read<SurveyCubit>().state.local,
      ),
      child: Column(
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
              margin: const EdgeInsets.only(
                left: 128.0,
                right: 128.0,
                bottom: 64.0,
              ),
              child: LayoutGrid(
                columnGap: 12,
                rowGap: 12,
                areas: '''
                  0 1
                  2 3
                  4 5
                  6 7
                ''',
                columnSizes: [1.0.fr, 1.fr],
                rowSizes: [
                  1.0.fr,
                  1.0.fr,
                  1.0.fr,
                  1.0.fr,
                ],
                children: List.generate(
                  answers.length,
                  (index) {
                    return NamedAreaGridPlacement(
                      areaName: index.toString(),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: context
                                .watch<SurveyCubit>()
                                .state
                                .answersId
                                .contains(answers[index].id)
                            ? BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              )
                            : null,
                        child: Directionality(
                          textDirection: getDirectionally(
                            context.read<SurveyCubit>().state.local,
                          ),
                          child: CheckboxListTile(
                            title: Text(
                              answersDetails[index],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: getFontFamily(local),
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              maxLines: 2,
                            ),
                            value: context
                                .watch<SurveyCubit>()
                                .state
                                .answersId
                                .contains(answers[index].id),
                            onChanged: (value) async {
                              BlocProvider.of<SurveyCubit>(context)
                                  .onAddAnswerToReview(
                                answers[index].id,
                              );
                              BlocProvider.of<SurveyCubit>(context)
                                  .onTimerRefresh();
                              if (audio.state == PlayerState.playing) {
                                await audio.dispose();
                              }
                              await audio
                                  .play(AssetSource('audios/keyboard.mp3'));
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Theme.of(context).colorScheme.primary,
                            selectedTileColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        //   ),
                        // ],
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
