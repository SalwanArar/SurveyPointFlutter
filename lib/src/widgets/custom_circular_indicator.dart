part of 'custom_widgets.dart';

class CustomCircularIndicator extends StatelessWidget {
  const CustomCircularIndicator({
    Key? key,
    required this.title,
    required this.isSystem,
    required this.isSurvey,
  }) : super(key: key);
  final String title;
  final bool isSystem;
  final bool isSurvey;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Directionality(
        textDirection: getDirectionally(
          isSystem
              ? context.select<StatusBarCubit, Local>(
                  (cubit) => cubit.state.local,
                )
              : isSurvey
                  ? context.select<SurveyCubit, Local>(
                      (cubit) => cubit.state.local,
                    )
                  : Local.ar,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 32.0),
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }
}
