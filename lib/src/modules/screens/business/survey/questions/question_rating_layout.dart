part of 'questions_layout.dart';

class QuestionRatingLayout extends StatelessWidget {
  const QuestionRatingLayout({
    Key? key,
    required this.questionDetails,
  }) : super(key: key);
  final String questionDetails;

  @override
  Widget build(BuildContext context) {
    final Local local = context.select<SurveyCubit, Local>(
      (cubit) => cubit.state.local,
    );
    const double fontSize = 22;
    return Column(
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
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _RatingButton(RatingColor.rating1, false),
                _RatingButton(RatingColor.rating2, false),
                _RatingButton(RatingColor.rating3, false),
                _RatingButton(RatingColor.rating4, false),
                _RatingButton(RatingColor.rating5, false),
              ],
            ),
          ),
        ),
      ],
    );
  }

}
