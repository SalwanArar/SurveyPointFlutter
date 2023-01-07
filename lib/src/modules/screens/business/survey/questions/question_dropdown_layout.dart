part of 'questions_layout.dart';

class QuestionDropdownLayout extends StatefulWidget {
  const QuestionDropdownLayout({
    Key? key,
    required this.questionDetails,
    required this.answers,
    required this.answersDetails,
  }) : super(key: key);

  final String questionDetails;
  final List<Answer> answers;
  final List<String> answersDetails;

  @override
  State<QuestionDropdownLayout> createState() => _QuestionDropdownLayoutState();
}

class _QuestionDropdownLayoutState extends State<QuestionDropdownLayout> {
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Local local = context.select(
      (SurveyCubit cubit) => cubit.state.local,
    );
    List<int> answersId = context.select(
      (SurveyCubit cubit) => cubit.state.answersId,
    );
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    double width = MediaQuery.of(context).size.width;
    const positionJump = 64;
    return Column(
      textDirection: getDirectionally(local),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: CustomQuestionWidget(
            questionDetails: widget.questionDetails * 3,
          ),
        ),
        Flexible(
          flex: 5,
          child: Container(
            margin: EdgeInsets.only(
              left: width * 0.0375,
              right: width * 0.0375,
              bottom: width * 0.01,
            ),
            alignment: getAlignment(local),
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.4,
              ),
              borderRadius: BorderRadius.circular(18.0),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            width: width * 0.6,
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: widget.answers.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool isSelected =
                          answersId.contains(widget.answers[index].id);
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 32.0),
                        // padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: isSelected ? 3 : 1,
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.secondary,
                          ),
                          color:
                              isSelected ? colorScheme.primaryContainer : null,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ListTile(
                          enableFeedback: false,
                          selectedColor: colorScheme.onPrimaryContainer,
                          // style: ListTileStyle.list,
                          selected: isSelected,

                          onTap: () {
                            // TODO: add audio
                            context.read<SurveyCubit>().onTimerRefresh();
                            context.read<SurveyCubit>().onReplaceAnswer(
                                  widget.answers[index].id,
                                );
                          },
                          leading: Text('${(index + 1).toString()} -'),
                          // contentPadding: EdgeInsets,
                          title: Text(
                            widget.answersDetails[index],
                            // TODO: answer style
                            style: TextStyle(
                              fontFamily: getFontFamily(local),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<SurveyCubit>().onTimerRefresh();
                          double upPosition = controller.offset - positionJump;
                          if (upPosition >
                              controller.position.maxScrollExtent) {
                            upPosition = controller.position.maxScrollExtent;
                          }
                          controller.jumpTo(upPosition);
                        },
                        child: FaIcon(
                          FontAwesomeIcons.circleChevronUp,
                          size: 64.0,
                          color: colorScheme.primary,
                        ),
                      ),
                      // const SizedBox(height: .0),
                      GestureDetector(
                        onTap: () {
                          context.read<SurveyCubit>().onTimerRefresh();
                          double downPosition =
                              controller.offset + positionJump;
                          if (downPosition <
                              controller.position.minScrollExtent) {
                            downPosition = controller.position.minScrollExtent;
                          }
                          controller.jumpTo(downPosition);
                        },
                        child: FaIcon(
                          FontAwesomeIcons.circleChevronDown,
                          size: 64.0,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
