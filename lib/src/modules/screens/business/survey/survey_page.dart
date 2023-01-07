import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_point_05/src/utils/services/functions.dart';
import 'package:survey_point_05/src/widgets/custom_widgets.dart';

import 'survey_form.dart';
import 'customer_info/customer_info_layout.dart';
import '../business_save_layout.dart';
import '../business_thank_layout.dart';
import '../survey/survey_setup.dart';
import '../../../models/device_info.dart';
import '../../../blocs/device_bloc/device_bloc.dart';
import '../../../blocs/survey_cubit/survey_cubit.dart';
import '../../../../constants/enums.dart';

class SurveyPage extends StatelessWidget {
  const SurveyPage({Key? key}) : super(key: key);

  static Route<void> route() => MaterialPageRoute(
        builder: (context) => const SurveyPage(),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceBloc, DeviceState>(
      buildWhen: (previous, current) =>
          previous.deviceInfo != current.deviceInfo,
      builder: (context, state) {
        var value = context.select<DeviceBloc, DeviceInfo>(
          (value) => value.state.deviceInfo.copyWith(
            business: getQuestionsOrder(
              value.state.deviceInfo.business!,
            ),
          ),
        );
        return BlocProvider<SurveyCubit>(
          create: (context) {
            return SurveyCubit(
              value,
              const TimerDialog(),
            );
          },
          child: const _SurveyView(),
        );
      },
    );
  }
}

class _SurveyView extends StatefulWidget {
  const _SurveyView({Key? key}) : super(key: key);

  @override
  State<_SurveyView> createState() => _SurveyViewState();
}

class _SurveyViewState extends State<_SurveyView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SurveyCubit, SurveyState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch ((state.status)) {
          case BusinessStatus.setup:
            _navigator.pushAndRemoveUntil(
              SurveySetup.route(),
              (route) => false,
            );
            break;
          case BusinessStatus.form:
            _navigator.pushAndRemoveUntil(
              SurveyForm.route(),
              (route) => false,
            );
            break;
          case BusinessStatus.save:
            _navigator.pushAndRemoveUntil(
              BusinessSaveLayout.route(true),
              (route) => false,
            );
            break;
          case BusinessStatus.customerInfo:
            // this case is only for *** survey ***
            _navigator.pushAndRemoveUntil(
              CustomerInfoLayout.route(),
              (route) => false,
            );
            break;
          case BusinessStatus.thanks:
            _navigator.pushAndRemoveUntil(
              BusinessThankLayout.route(true),
              (route) => false,
            );
            break;
        }
      },
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (route) => SurveySetup.route(),
      ),
    );
  }
}
