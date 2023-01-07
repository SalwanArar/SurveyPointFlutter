import 'dart:async';
import 'dart:io';

import 'package:android_flutter_wifi/android_flutter_wifi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:toast/toast.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../blocs/authentication_bloc/authentication_bloc.dart';
import '../../blocs/status_bar_cubit/status_bar_cubit.dart';
import '../../../widgets/custom_widgets.dart';
import '../../../constants/const_values.dart';
import '../../../constants/assets_path.dart';
import '../../../constants/enums.dart';
import '../../../utils/services/rest_api_service.dart';
import '../../../utils/services/functions.dart';
import '../../../utils/services/exceptions.dart';
import '../../../utils/services/local_storage_service.dart';
import '../../../utils/services/rest_api_service_v02.dart';

part 'setup_layout.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute<void>(builder: (_) => const SetupPage());

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  late Stream<_SetupInfo> _steam;

  Stream<_SetupInfo> _streamTest() async* {
    _SetupInfo setupInfo = _SetupInfo(
      // title: AppLocalizations.of(context)!.welcomeTitle,
      deviceCode: await getDeviceCode(),
      msg: DeviceStatus.unauthenticated,
    );
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      // TODO: remove print
      // debugPrint('${await getTermsAgreed()}');
      try {
        if (setupInfo.deviceCode == null) {
          // TODO: remove print
          // debugPrint('there is no device code!');
          await apiPostDeviceCodeV2();
          setupInfo.deviceCode = await getDeviceCode();

          // TODO: remove print
          debugPrint(setupInfo.deviceCode);
        }
        // TODO: remove print
        debugPrint('Token:\t${await getToken()}');
        if ((await apiPostDevice()).statusCode == HttpStatus.created) {
          // TODO: remove print
          debugPrint('HttpStatus.created');
          setupInfo.msg = DeviceStatus.authenticated;
        }
        if (mounted) {
          BlocProvider.of<StatusBarCubit>(context).onChangeServerStatus(
            true,
          );
          // setupInfo.title = AppLocalizations.of(context)!.welcomeTitle;
        }
      } on TimeoutException catch (e) {
        // TODO: remove print
        debugPrint('_streamTest:\t${e.message}\t${e.runtimeType}');
        // debugPrint('_streamTest:\t${e.message}');
        if (mounted) {
          BlocProvider.of<StatusBarCubit>(context).onChangeServerStatus(
            false,
          );
          // setupInfo.title = AppLocalizations.of(context)!.serverError;
          setupInfo.deviceCode = null;
        }
        yield setupInfo;
        // rethrow;
      } on UnimplementedError catch (e) {
        // TODO: remove print
        debugPrint('_streamTest:\t${e.message}');
        if (mounted) {
          BlocProvider.of<StatusBarCubit>(context).onChangeServerStatus(
            false,
          );
          // setupInfo.title = AppLocalizations.of(context)!.serverError;
          setupInfo.deviceCode = null;
        }
        // yield setupInfo;
        // rethrow;
      } on TooManyAttemptsException catch (e) {
        // TODO: remove print
        debugPrint('_streamTest:\t${e.msg}');
        if (mounted) {
          BlocProvider.of<StatusBarCubit>(context).onChangeServerStatus(
            false,
          );
          // setupInfo.title = AppLocalizations.of(context)!.serverError;
          setupInfo.deviceCode = null;
        }
        // yield setupInfo;
        rethrow;
      } on DeviceAlreadyAttachedException catch (e) {
        if ((await apiGetVerification()).statusCode == HttpStatus.noContent) {
          setupInfo.msg = DeviceStatus.authenticated;
        } else {
          // TODO: remove print
          debugPrint('_streamTest:\t${e.msg}');
          setupInfo.deviceCode = null;
          // yield setupInfo;
          rethrow;
        }
      } catch (_) {
        if (mounted) {
          BlocProvider.of<StatusBarCubit>(context).onChangeServerStatus(
            false,
          );
          // setupInfo.title = AppLocalizations.of(context)!.connectToInternetMsg;
          setupInfo.deviceCode = null;
        }
        // yield setupInfo;
        // rethrow;
      } finally {
        yield setupInfo;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _steam = _streamTest();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<_SetupInfo>(
      stream: _steam,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CustomCircularIndicator(
            title: AppLocalizations.of(context)!.pleaseWait,
            isSystem: true,
            isSurvey: false,
          );
        }
        _SetupInfo? setupInfo = snapshot.data;
        String title;
        if (snapshot.hasError) {
          BlocProvider.of<StatusBarCubit>(context).onChangeServerStatus(
            false,
          );
          setupInfo?.deviceCode = null;
          // TODO: remove print
          debugPrint('snapshotError:\t ${snapshot.error.runtimeType}');
          switch (snapshot.error.runtimeType) {
            case DeviceAlreadyAttachedException:
              setupInfo?.msg = DeviceStatus.attached;
              title = AppLocalizations.of(context)!.attachedDeviceMsg;
              BlocProvider.of<AuthenticationBloc>(context).add(
                const AuthenticationLogout(),
              );
              return Builder(builder: (context) {
                Future.delayed(const Duration(seconds: 4), () {
                  setState(() {
                    _steam = _streamTest();
                  });
                });
                return CustomCircularIndicator(
                  title: title,
                  isSystem: true,
                  isSurvey: false,
                );
              });
            case TooManyAttemptsException:
              title = AppLocalizations.of(context)!.serverError;
              context.read<AuthenticationBloc>().add(
                    const AuthenticationRestart(),
                  );
              // setState(() {
              //   _steam = _streamTest();
              // });
              break;
            default:
              title = AppLocalizations.of(context)!.connectToInternetMsg;
              break;
          }
        } else {
          title = AppLocalizations.of(context)!.welcomeTitle;
        }
        if (snapshot.hasData) {
          if (snapshot.data!.msg == DeviceStatus.authenticated) {
            BlocProvider.of<AuthenticationBloc>(context).add(
              const AuthenticationStatusChanged(
                AuthenticationStatus.authenticated,
              ),
            );
            return CustomCircularIndicator(
              title: AppLocalizations.of(context)!.pleaseWait,
              isSystem: true,
              isSurvey: false,
            );
          }
        }
        return _SetupLayout(
          // title:
          // snapshot.data?.title ?? AppLocalizations.of(context)!.pleaseWait,
          // title: title,
          size: MediaQuery.of(context).size,
          deviceCode: snapshot.data?.deviceCode,
          onRefresh: () => context.read<AuthenticationBloc>().add(
                const AuthenticationRestart(),
              ),
        );
      },
    );
  }
}
