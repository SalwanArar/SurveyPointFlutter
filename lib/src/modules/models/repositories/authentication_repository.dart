// TODO: Missing Documentation
// TODO: Missing Localization

import 'dart:async';
import 'dart:io';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:survey_point_05/src/utils/services/secure_storage_service.dart';

import '../../../constants/enums.dart';
import '../../../utils/services/local_storage_service.dart';
import '../../../utils/services/rest_api_service.dart';

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    try {
      await Future.delayed(const Duration(seconds: 2));

      // if (!await getTermsAgreed()) {
      //   yield AuthenticationStatus.agreement;
      //   yield* _controller.stream;
      //   return;
      // }

      // if there is no internet connectivity go to server out
      if (!await InternetConnectionCheckerPlus().hasConnection) {
        // await WiFiForIoTPlugin.connect(
        //   await getWiFiSsd() ?? '',
        //   password: await getWiFiPassword() ?? '',
        //   security: NetworkSecurity.WPA,
        // );
        // await WiFiForIoTPlugin.forceWifiUsage(true).timeout(
        //   const Duration(seconds: 2),
        // );
        // if (!await InternetConnectionCheckerPlus().hasConnection) {
        yield AuthenticationStatus.unauthenticated;
        yield* _controller.stream;
        return;
        // }
      }

      final responseVerification = await apiGetVerification();
      switch (responseVerification.statusCode) {
        case HttpStatus.noContent:
          yield AuthenticationStatus.authenticated;
          yield* _controller.stream;
          break;
        case HttpStatus.unauthorized:
          yield AuthenticationStatus.unauthenticated;
          yield* _controller.stream;
          break;
        default:
          print('Authentication Repository: status\t'
              '${responseVerification.statusCode}');
          yield AuthenticationStatus.unauthenticated;
          yield* _controller.stream;
          break;
      }
    } catch (e) {
      print('Authentication Repository:\t${e.toString()}');
      yield AuthenticationStatus.unauthenticated;
      yield* _controller.stream;
      throw e.toString();
    }
  }

  void logOut() async {
    try {
      await apiGetLogout();
    } catch (_) {}
    await deletePreferences();
    await DBProvider.db.emptyDatabase();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
