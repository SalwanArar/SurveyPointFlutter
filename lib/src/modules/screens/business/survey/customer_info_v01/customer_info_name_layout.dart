part of 'customer_info_layouts.dart';

class CustomerInfoNameLayout extends StatelessWidget {
  const CustomerInfoNameLayout({Key? key, required this.controller})
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
    Size size = MediaQuery.of(context).size;
    int length = 64;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 3,
          child: CustomQuestionWidget(
            questionDetails: getNameTitleLocale(local),
          ),
        ),
        Flexible(
          flex: 4,
          child: Container(
            alignment: getAlignment(local),
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.0375),
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.none,
              decoration: decoration(
                label: getNameLocale,
                local: local,
                isOptional: isOptional,
                color: Theme.of(context).colorScheme.error,
              ),
              autofocus: true,
              maxLength: length,
              maxLines: 1,
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
                  insertText(value, controller, length);
                  if (controller.text.length > 2) {
                    BlocProvider.of<SurveyCubit>(context).onAddingInfo(
                      controller.text.trim(),
                      CustomerInfoType.name,
                    );
                  }
                },
                onBackspace: () {
                  BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                  backspace(controller);
                  if (controller.text.length < 3) {
                    BlocProvider.of<SurveyCubit>(context).onAddingInfo(
                      '',
                      CustomerInfoType.name,
                    );
                  } else {
                    BlocProvider.of<SurveyCubit>(context).onAddingInfo(
                      controller.text.trim(),
                      CustomerInfoType.name,
                    );
                  }
                },
                onDone: null,
              ),
            ),
          ),
        ),
        const Spacer(flex: 1),
      ],
    );
  }
}
