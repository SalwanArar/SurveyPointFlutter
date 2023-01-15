import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_mode/kiosk_mode.dart';

import 'src/app.dart';
import 'src/bloc_observer.dart';
import 'src/utils/services/local_storage_service.dart';
import 'src/modules/blocs/status_bar_cubit/status_bar_cubit.dart';
import 'src/modules/models/repositories/device_repository.dart';
import 'src/modules/models/repositories/authentication_repository.dart';
import 'src/constants/enums.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (await getKioskMode() == KioskMode.disabled) {
    await startKioskMode();
  }
  // await stopKioskMode();
  setLastUpdate('1997-09-13 13:58:46');
  Bloc.observer = StatusObserver();

  Local local = await getGlobalLocale() ?? Local.en;

  StatusBarCubit statusBarCubit = StatusBarCubit(local);
  runApp(
    App(
      authenticationRepository: AuthenticationRepository(),
      deviceRepository: DeviceRepository(statusBarCubit: statusBarCubit),
      statusBarCubit: statusBarCubit,
    ),
  );
  // await SentryFlutter.init(
  //   (options) {
  //     options.dsn =
  //         'https://33d13b06ac1e48cb89d7628d7319411e@o4504202733027328.ingest.sentry.io/4504202735321088';
  //     options.tracesSampleRate = 1.0;
  //   },
  //   appRunner: () => runApp(
  //     App(
  //       authenticationRepository: AuthenticationRepository(),
  //       deviceRepository: DeviceRepository(statusBarCubit: statusBarCubit),
  //       statusBarCubit: statusBarCubit,
  //     ),
  //   ),
  // );
}
