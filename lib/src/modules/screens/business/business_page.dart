import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/const_values.dart';
import '../../blocs/authentication_bloc/authentication_bloc.dart';
import '/src/modules/blocs/device_bloc/device_bloc.dart';
import '/src/modules/screens/business/device_header.dart';
import '/src/modules/screens/business/registration/registration_page.dart';
import '/src/modules/screens/business/survey/survey_page.dart';
import '/src/modules/screens/settings/settings_page.dart';

import '../../../constants/enums.dart';
import '../../../widgets/custom_widgets.dart';
import '../../models/repositories/device_repository.dart';
import 'out_of_service/out_of_service_page.dart';

class BusinessPage extends StatelessWidget {
  const BusinessPage({
    Key? key,
    required this.deviceRepository,
  }) : super(key: key);

  static Route<void> route(DeviceRepository deviceRepository) =>
      MaterialPageRoute<void>(
        builder: (_) => BusinessPage(
          deviceRepository: deviceRepository,
        ),
      );

  final DeviceRepository deviceRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => deviceRepository,
      child: BlocProvider(
        create: (context) => DeviceBloc(
          deviceRepository,
          BlocProvider.of<AuthenticationBloc>(context),
        ),
        child: const _BusinessView(),
      ),
    );
  }
}

class _BusinessView extends StatefulWidget {
  const _BusinessView({Key? key}) : super(key: key);

  @override
  State<_BusinessView> createState() => _BusinessViewState();
}

class _BusinessViewState extends State<_BusinessView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFC4B4B4B),
        // color: colorScheme.secondary,
        // image: DecorationImage(
        //   image: AssetImage(
        //     'assets/images/background2.jpg',
        //   ),
        //   fit: BoxFit.fill
        // ),
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   transform: GradientRotation(90),
        //   colors: <Color>[
        //     // colorScheme.primary,
        //     // colorScheme.secondary,
        //     // colorScheme.tertiary,
        //     // colorScheme.secondary,
        //     // colorScheme.primary,
        //     Color(0xff000000),
        //     // Color(0xff75546e),
        //     // Color(0xff775273),
        //     // Color(0xff795079),
        //     // Color(0xff794f80),
        //     // Color(0xff784e87),
        //     // Color(0xff764d8f),
        //     // Color(0xff734d97),
        //     // Color(0xff6e4e9f),
        //     // Color(0xff664ea8),
        //     // Color(0xff5c50b1),
        //     // Color(0xff4e52bb),
        //     Color(0xff3854c4),
        //   ],
        //   // Gradient from https://learnui.design/tools/gradient-generator.html
        //   tileMode: TileMode.mirror,
        // ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const DeviceHeader(),
          Flexible(
            flex: 6,
            child: Container(
              margin: const EdgeInsets.only(
                right: businessMargin,
                left: businessMargin,
                bottom: businessMargin,
                top: 0.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(businessRadius),
              ),
              clipBehavior: Clip.hardEdge,
              child: BlocListener<DeviceBloc, DeviceState>(
                listenWhen: (previous, current) =>
                    current.deviceStatus != previous.deviceStatus,
                listener: (context, state) {
                  switch (state.deviceStatus) {
                    case DeviceAuthenticatedStatus.unknown:
                      _navigator.pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => CustomCircularIndicator(
                            title: AppLocalizations.of(context)!.pleaseWait,
                            isSystem: true,
                            isSurvey: false,
                          ),
                        ),
                        (route) => false,
                      );
                      break;
                    case DeviceAuthenticatedStatus.survey:
                      _navigator.pushAndRemoveUntil(
                        SurveyPage.route(),
                        (route) => false,
                      );
                      break;
                    case DeviceAuthenticatedStatus.registration:
                      _navigator.pushAndRemoveUntil(
                        RegistrationPage.route(),
                        (route) => false,
                      );
                      break;
                    case DeviceAuthenticatedStatus.outOfService:
                      _navigator.pushAndRemoveUntil(
                        OutOfServicePage.route(),
                        (route) => false,
                      );
                      break;
                    case DeviceAuthenticatedStatus.settings:
                      _navigator.pushAndRemoveUntil(
                        SettingsPage.route(),
                        (route) => false,
                      );
                      break;
                  }
                },
                child: Navigator(
                  key: _navigatorKey,
                  onGenerateRoute: (route) => MaterialPageRoute(
                    builder: (_) {
                      return Container(
                        margin: const EdgeInsets.all(businessMargin),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius:
                                BorderRadius.circular(businessRadius)),
                        child: CustomCircularIndicator(
                          title: AppLocalizations.of(context)!.pleaseWait,
                          isSystem: true,
                          isSurvey: false,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class Test extends StatelessWidget {
//   const Test({
//     Key? key,
//     this.title = 'Unknown',
//   }) : super(key: key);
//   final String title;
//
//   static Route<void> route({String? title}) => MaterialPageRoute(
//         builder: (_) => Test(
//           title: title ?? 'Unknown',
//         ),
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 BlocProvider.of<DeviceBloc>(context).add(
//                   const DeviceStatusChangeEvent(
//                     DeviceAuthenticatedStatus.settings,
//                   ),
//                 );
//               },
//               child: const Text('Settings'),
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 BlocProvider.of<DeviceBloc>(context).add(
//                   const DeviceStatusChangeEvent(
//                     DeviceAuthenticatedStatus.survey,
//                   ),
//                 );
//               },
//               child: const Text('Survey'),
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 BlocProvider.of<DeviceBloc>(context).add(
//                   const DeviceStatusChangeEvent(
//                     DeviceAuthenticatedStatus.registration,
//                   ),
//                 );
//               },
//               child: const Text('Registration'),
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 BlocProvider.of<DeviceBloc>(context).add(
//                   const DeviceStatusChangeEvent(
//                     DeviceAuthenticatedStatus.outOfService,
//                   ),
//                 );
//               },
//               child: const Text('Out Of Service'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
