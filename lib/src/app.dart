import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '/src/modules/models/repositories/device_repository.dart';
import '/src/modules/screens/business/business_page.dart';
import '/src/modules/screens/device_status_bar.dart';
import '/src/utils/services/rest_api_service.dart';
import '/src/modules/blocs/status_bar_cubit/status_bar_cubit.dart';
import 'config/themes/light/light_theme.dart';
import 'constants/enums.dart';
import 'modules/blocs/authentication_bloc/authentication_bloc.dart';
import 'modules/models/repositories/authentication_repository.dart';
import 'modules/screens/setup/setup_page.dart';
import 'modules/screens/splash_page.dart';

class App extends StatelessWidget {
  App({
    Key? key,
    required this.authenticationRepository,
    required this.deviceRepository,
    required this.statusBarCubit,
  }) : super(key: key) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  final AuthenticationRepository authenticationRepository;
  final DeviceRepository deviceRepository;
  final StatusBarCubit statusBarCubit;

  @override
  Widget build(BuildContext context) => RepositoryProvider(
        create: (context) => authenticationRepository,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => statusBarCubit,
            ),
            BlocProvider(
              create: (context) => AuthenticationBloc(
                authenticationRepository: authenticationRepository,
                deviceRepository: deviceRepository,
              ),
            ),
          ],
          child: _AppView(deviceRepository: deviceRepository),
        ),
      );
}

class _AppView extends StatefulWidget {
  const _AppView({
    Key? key,
    required this.deviceRepository,
  }) : super(key: key);

  final DeviceRepository deviceRepository;

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survey Point',
      debugShowCheckedModeBanner: false,
      theme: LightThemeSettings.baseLight(context),
      locale: Locale(
        context.watch<StatusBarCubit>().state.local.name,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        // GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''), // Arabic
        Locale('en', ''), // English
        // Locale('ur', ''), // Urdu
        // Locale('tl', ''), // Tagalog
      ],
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        // first listen to the internet connectivity
        InternetConnectionCheckerPlus().onStatusChange.listen(
          (status) {
            // if the the device connected to the internet
            // change device status
            final bool connection =
                status == InternetConnectionStatus.connected;
            BlocProvider.of<StatusBarCubit>(context).onChangeInternetStatus(
              connection,
            );
          },
        );
        return Scaffold(
          body: Column(
            children: [
              BlocListener<StatusBarCubit, StatusBarState>(
                listenWhen: (previous, current) =>
                    current.internetConnectionStatus !=
                    previous.internetConnectionStatus,
                listener: (context, state) async {
                  // setLastUpdate('1997-09-13 13:58:46');
                  late bool serverStatus;
                  /**
                   * whenever the device status changed check the
                   * connectivity of the server by checking verification
                   * status
                   */
                  try {
                    final responseVerification = await apiGetVerification();
                    switch (responseVerification.statusCode) {
                      case HttpStatus.noContent:
                      case HttpStatus.unauthorized:
                        serverStatus = true;
                        break;
                      default:
                        serverStatus = false;
                        break;
                    }
                  } catch (e) {
                    // TODO: remove print
                    print(
                      'App Device Status Checker:\t${e.toString()}',
                    );
                    serverStatus = false;
                  } finally {
                    BlocProvider.of<StatusBarCubit>(context)
                        .onChangeServerStatus(serverStatus);
                  }
                },
                child: const StatusBar(),
              ),
              Expanded(
                child: BlocListener<AuthenticationBloc, AuthenticationState>(
                  listenWhen: (current, previous) =>
                      current.status != previous.status,
                  listener: (context, state) {
                    switch (state.status) {
                      case AuthenticationStatus.unknown:
                        // TODO: Handle this case.
                        break;
                      case AuthenticationStatus.unauthenticated:
                        _navigator.pushAndRemoveUntil(
                          SetupPage.route(),
                          (route) => false,
                        );
                        break;
                      case AuthenticationStatus.authenticated:
                        _navigator.pushAndRemoveUntil(
                          BusinessPage.route(widget.deviceRepository),
                          (route) => false,
                        );
                        break;
                      // case AuthenticationStatus.agreement:
                      //   _navigator.pushAndRemoveUntil(
                      //     AgreementPage.route(),
                      //     (route) => false,
                      //   );
                      //   break;
                    }
                  },
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
