part of 'customer_info_layouts.dart';

class CustomerInfoCommentLayout extends StatelessWidget {
  const CustomerInfoCommentLayout({Key? key, required this.controller})
      : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final Local local = context.select(
      (SurveyCubit cubit) => cubit.state.local,
    );
    final bool isOptional = context.select((SurveyCubit cubit) {
      final customerInfo = cubit.state.business.survey.customerInfo;
      final test =
          cubit.state.surveyIndex - cubit.state.business.questions.length;
      return customerInfo.getInfoOptional(test);
    });
    final double fieldPadding = MediaQuery.of(context).size.width * 0.0375;
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 3,
          child: CustomQuestionWidget(
            questionDetails: getFeedbackLabelLocal(local),
          ),
        ),
        Flexible(
          flex: 4,
          fit: FlexFit.loose,
          child: Container(
            alignment: Alignment.center,
            width: size.width * 0.8,
            padding: EdgeInsets.symmetric(horizontal: fieldPadding),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.none,
              decoration: decoration(
                label: getCommentLabelLocale,
                local: local,
                isOptional: isOptional,
                color: Theme.of(context).colorScheme.error,
              ),
              autofocus: true,
              maxLength: 255,
              maxLines: 4,
            ),
          ),
        ),
        Flexible(
          flex: 6,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: size.width * 0.8,
              child: CustomKeyboard(
                onTextInput: (String value) {
                  BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                  int length = 255;
                  insertText(value, controller, length);
                  if (controller.text.length > 10) {
                    BlocProvider.of<SurveyCubit>(context).onAddingInfo(
                      controller.text,
                      CustomerInfoType.comment,
                    );
                  }
                },
                onBackspace: () {
                  BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                  backspace(controller);
                  if (controller.text.length <= 10) {
                    BlocProvider.of<SurveyCubit>(context).onAddingInfo(
                      '',
                      CustomerInfoType.comment,
                    );
                  } else {
                    BlocProvider.of<SurveyCubit>(context).onAddingInfo(
                      controller.text,
                      CustomerInfoType.comment,
                    );
                  }
                },
                onDone: () {
                  BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                  if (controller.text.allMatches('\n').length < 5) {
                    insertText('\n', controller, 255);
                  }
                },
              ),
            ),
          ),
        ),
        const Spacer(flex: 1),
      ],
    );
  }
}
