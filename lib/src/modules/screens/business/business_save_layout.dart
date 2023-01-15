import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/src/modules/blocs/survey_cubit/survey_cubit.dart';
import '/src/widgets/custom_widgets.dart';

import '../../../constants/enums.dart';
import '../../../utils/services/business_locale.dart';

class BusinessSaveLayout extends StatelessWidget {
  const BusinessSaveLayout({Key? key, required this.isSurvey})
      : super(key: key);

  final bool isSurvey;

  static Route<void> route(bool isSurvey) => MaterialPageRoute(
        builder: (_) => BusinessSaveLayout(
          isSurvey: isSurvey,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final Local local = isSurvey
        ? context.select<SurveyCubit, Local>(
            (cubit) => cubit.state.local,
          )
        : Local.ar;
    return CustomCircularIndicator(
      title: getSaveLocale(local),
      isSystem: false,
      isSurvey: isSurvey,
    );
  }
}
