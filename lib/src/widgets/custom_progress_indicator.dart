part of 'custom_widgets.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int length = context.read<SurveyCubit>().state.business.questions.length;
    // if (context.read<SurveyCubit>().state.business.survey.customerInfo) {
    //   ++length;
    // }
    length += context.read<SurveyCubit>().state.business.survey.customerInfo.getCustomerInfoCount;
    return SizedBox(
      width: (length + 1) * 48.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Divider(
            color: Colors.black45,
            thickness: 2,
            indent: 24,
            endIndent: 24,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              length + 1,
              (index) {
                final selected =
                    index <= context.watch<SurveyCubit>().state.surveyIndex;
                // ||
                // context.watch<SurveyCubit>().state.status ==
                //     BusinessStatus.customerInfo;
                final passedQuestion =
                    index < context.watch<SurveyCubit>().state.surveyIndex ||
                        context.watch<SurveyCubit>().state.status ==
                            BusinessStatus.customerInfo;
                return index == length
                    ? Container(
                        width: 24.0,
                        height: 24.0,
                        margin: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.background,
                          // border: Border.all(),
                        ),
                        alignment: Alignment.center,
                        child: FaIcon(
                          FontAwesomeIcons.flagCheckered,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20.0,
                        ),
                      )
                    : Container(
                        width: 24.0,
                        height: 24.0,
                        margin: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: selected
                              ? null
                              : Border.all(
                                  color: Colors.black45,
                                  width: 2,
                                ),
                          // borderRadius: BorderRadius.circular(16.0),
                          color: selected
                              ? const Color(0xFF1779C9)
                              : Theme.of(context).colorScheme.background,
                        ),
                        child: Center(
                          child: passedQuestion
                              ? FaIcon(
                                  FontAwesomeIcons.check,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  size: 12.0,
                                )
                              : Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                    color: context
                                                .watch<SurveyCubit>()
                                                .state
                                                .status ==
                                            BusinessStatus.customerInfo
                                        ? Colors.red
                                        : selected
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                            : Theme.of(context)
                                                .colorScheme
                                                .onTertiaryContainer,
                                    fontFamily: 'Montserrat',
                                    fontSize: 12.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
