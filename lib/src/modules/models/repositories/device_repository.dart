import 'dart:async';
import 'dart:io';

import 'package:survey_point_05/src/constants/enums.dart';
import 'package:survey_point_05/src/modules/blocs/status_bar_cubit/status_bar_cubit.dart';

import '../../../utils/services/local_storage_service.dart';
import '../../../utils/services/exceptions.dart';
import '../../../utils/services/rest_api_service.dart';
import '../../../utils/services/secure_storage_service.dart';
import '../device_info.dart';

class DeviceRepository {
  final _controller = StreamController<DeviceInfo?>();

  DeviceRepository({this.statusBarCubit});

  final StatusBarCubit? statusBarCubit;

  DeviceInfo? _deviceInfo;
  bool isStreaming = true;

  Stream<DeviceInfo?> get status async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _deviceInfo;
    updateDeviceInfo();
    yield* _controller.stream;
  }

  Future<DeviceInfo?> getDeviceInfo() async {
    try {
      var response = await apiGetDeviceInfo();
      if (response.statusCode == HttpStatus.ok) {
        _deviceInfo = DeviceInfo.fromJson(response.body);
        return _deviceInfo;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<void> updateDeviceInfo() async {
    while (isStreaming) {
      try {
        await Future.delayed(const Duration(seconds: 30));
        var responseDeviceInfo = await apiGetDeviceInfo();
        switch (responseDeviceInfo.statusCode) {
          case HttpStatus.ok:
            _deviceInfo = DeviceInfo.fromJson(responseDeviceInfo.body);
            if (_deviceInfo!.business != null) {
              setSurveyId(_deviceInfo!.business!.survey.id);
            }

            setLastUpdate(_deviceInfo!.updatedAt);
            print('updated:\t ${_deviceInfo!.organizationName}');
            _controller.add(_deviceInfo!);
            break;
          case HttpStatus.noContent:
            if (_deviceInfo == null) {
              _controller.add(null);
              throw const UnAuthenticatedException(
                'Unauthenticated when update device info',
              );
            }
            break;
          case HttpStatus.unauthorized:
            _controller.add(null);
            throw const UnAuthenticatedException(
              'Unauthenticated when update device info',
            );
        }
        if (!await DBProvider.db.isEmpty()) {
          await DBProvider.db.uploadReview();
        }
        if (statusBarCubit != null) {
          statusBarCubit!.onChangeServerStatus(true);
        }
      } on TooManyAttemptsException {
        if (statusBarCubit != null) {
          statusBarCubit!.onChangeServerStatus(false);
        }
        _controller.add(null);
      } catch (e) {
        if (statusBarCubit != null) {
          statusBarCubit!.onChangeServerStatus(false);
        }
        print(e.toString());
        print('error updateDeviceInfo');
      }
    }
  }

  void dispose() {
    isStreaming = false;
    _controller.close();
  }
}
