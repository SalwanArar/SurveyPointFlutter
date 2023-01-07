part of 'custom_widgets.dart';

class CustomQuestionWidget extends StatelessWidget {
  const CustomQuestionWidget({
    Key? key,
    required this.questionDetails,
  }) : super(key: key);
  final String questionDetails;

  @override
  Widget build(BuildContext context) {
    final Local local = context.select(
      (SurveyCubit cubit) => cubit.state.local,
    );
    double questionPadding = MediaQuery.of(context).size.width * 0.0375;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: questionPadding),
      alignment: getAlignment(local),
      child: Text(
        questionDetails,
        style: Theme.of(context).textTheme.headline2!.copyWith(
              fontSize: 38.0,
              fontWeight: FontWeight.bold,
              fontFamily: getFontFamily(local),
            ),
        maxLines: 3,
      ),
    );
  }
}

// Widget customQuestionWidget(BuildContext context, String questionDetails) =>
//     Container(
//       padding: const EdgeInsets.symmetric(horizontal: 48.0),
//       alignment: getDirectionally(
//                 context.read<SurveyCubit>().state.local,
//               ) ==
//               TextDirection.ltr
//           ? Alignment.centerLeft
//           : Alignment.centerRight,
//       child: Directionality(
//         textDirection: getDirectionally(
//           context.read<SurveyCubit>().state.local,
//         ),
//         child: Material(
//           child: Text(
//             questionDetails,
//             style: Theme.of(context)
//                 .textTheme
//                 .headline2!
//                 .copyWith(fontSize: 38.0, fontWeight: FontWeight.w900),
//             maxLines: 2,
//           ),
//         ),
//       ),
//     );
