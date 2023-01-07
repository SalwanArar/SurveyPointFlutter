import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../survey/survey_setup.dart';
import '../../../blocs/survey_cubit/survey_cubit.dart';
import '../../../../constants/enums.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  static Route<void> route() => MaterialPageRoute(
        builder: (context) => const RegistrationPage(),
      );

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Registration'),
      ),
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

  // _start() {
  //   // while (true) {
  //   // await Future.delayed(const Duration(seconds: 30));
  //   // if(mounted) {
  //   try {
  //     context.read<DeviceBloc>().add(const DeviceUpdateInfoEvent());
  //     context.read<StatusBarCubit>().onChangeServerStatus(true);
  //   } on UnAuthenticatedException catch (e) {
  //     // TODO: remove print
  //     if (kDebugMode) {
  //       print(e.msg);
  //     }
  //     context.read<AuthenticationBloc>().add(const AuthenticationLogout());
  //   } on TooManyAttemptsException {
  //     context.read<StatusBarCubit>().onChangeServerStatus(false);
  //     context.read<AuthenticationBloc>().add(const AuthenticationLogout());
  //   } on TimeoutException {
  //     context.read<StatusBarCubit>().onChangeServerStatus(false);
  //   } catch (_) {
  //     context.read<StatusBarCubit>().onChangeServerStatus(false);
  //   }
  //   // }
  //   // }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _stream().listen((event) { });
  }

  @override
  Widget build(BuildContext context) {
    // _start();
    return BlocListener<SurveyCubit, SurveyState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch ((state.status)) {
          case BusinessStatus.setup:
            _navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(
                    child: Text('Setup Registration'),
                  ),
                ),
              ),
              (route) => false,
            );
            break;
          case BusinessStatus.form:
            // TODO: Handle this case.
            break;
          case BusinessStatus.save:
            // TODO: Handle this case.
            break;
          case BusinessStatus.customerInfo:
            // TODO: Handle this case.
            break;
          case BusinessStatus.thanks:
            // TODO: Handle this case.
            break;
        }
      },
      // child: StreamBuilder(
      //   stream: _stream(),
      //   builder: (context, snapshot) {
      //     return
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (route) => SurveySetup.route(),
        //   );
        // }
      ),
    );
  }
}
