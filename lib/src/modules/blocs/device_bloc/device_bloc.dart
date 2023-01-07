import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:survey_point_05/src/utils/services/rest_api_service.dart';

import '../../models/repositories/device_repository.dart';
import '../../../constants/enums.dart';
import '../../models/device_info.dart';
import '../authentication_bloc/authentication_bloc.dart';

part 'device_event.dart';

part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceBloc(
    DeviceRepository deviceRepository,
    AuthenticationBloc authenticationBloc,
  )   : _deviceRepository = deviceRepository,
        _authenticationBloc = authenticationBloc,
        super(const DeviceState._()) {
    on<DeviceStatusChangeEvent>(_onDeviceStatusChangeEvent);
    on<DeviceOutOfServiceEvent>(_onDeviceOutOfServiceEven);
    _deviceAuthenticationStatusSubscription = _deviceRepository.status.listen(
      (info) {
        if (info != null) {
          DeviceAuthenticatedStatus status;
          if (info.outOfService) {
            status = DeviceAuthenticatedStatus.outOfService;
          } else if (info.business != null) {
            status = DeviceAuthenticatedStatus.survey;
          } else if (info.registration != null) {
            status = DeviceAuthenticatedStatus.registration;
          } else {
            status = DeviceAuthenticatedStatus.outOfService;
          }
          return add(DeviceStatusChangeEvent(status, info));
        } else {
          _authenticationBloc.add(const AuthenticationLogout());
          return add(
            DeviceStatusChangeEvent(
              DeviceAuthenticatedStatus.unknown,
              info,
            ),
          );
        }
      },
    );
  }

  final DeviceRepository _deviceRepository;
  final AuthenticationBloc _authenticationBloc;
  late StreamSubscription<DeviceInfo?> _deviceAuthenticationStatusSubscription;

  @override
  Future<void> close() {
    _deviceAuthenticationStatusSubscription.cancel();
    _deviceRepository.dispose();
    return super.close();
  }

  Future<void> _onDeviceStatusChangeEvent(
    DeviceStatusChangeEvent event,
    Emitter<DeviceState> emit,
  ) async {
    switch (event.deviceStatus) {
      case DeviceAuthenticatedStatus.unknown:
        _deviceRepository.dispose();
        return emit(const DeviceState.unknown());
      case DeviceAuthenticatedStatus.survey:
        if (_deviceAuthenticationStatusSubscription.isPaused) {
          _deviceAuthenticationStatusSubscription.resume();
        }
        return emit(
          DeviceState.survey(
            event.deviceInfo ?? state.deviceInfo,
          ),
        );
      case DeviceAuthenticatedStatus.registration:
        if (_deviceAuthenticationStatusSubscription.isPaused) {
          _deviceAuthenticationStatusSubscription.resume();
        }
        return emit(
          DeviceState.registration(
            event.deviceInfo ?? state.deviceInfo,
          ),
        );
      case DeviceAuthenticatedStatus.outOfService:
        if (_deviceAuthenticationStatusSubscription.isPaused) {
          _deviceAuthenticationStatusSubscription.resume();
        }
        return emit(
          DeviceState.outOfService(
            event.deviceInfo ?? state.deviceInfo,
          ),
        );
      case DeviceAuthenticatedStatus.settings:
        _deviceAuthenticationStatusSubscription.pause();
        return emit(
          DeviceState.settings(
            event.deviceInfo ?? state.deviceInfo,
          ),
        );
    }
  }

  Future<void> _onDeviceOutOfServiceEven(
    DeviceOutOfServiceEvent event,
    Emitter<DeviceState> emit,
  ) async {
    try {
      apiPostDeviceStatus(event.outOfService);
    } catch (e) {
      print('_onDeviceOutOfServiceEven:\t${e.toString()}');
    }
    return emit(
      DeviceState.outOfService(
        state.deviceInfo.copyWith(
          outOfService: event.outOfService,
        ),
      ),
    );
  }

// Future<void> _onDeviceUpdateInfoEvent(
//   DeviceUpdateInfoEvent event,
//   Emitter<DeviceState> emit,
// ) async {
//   try {
//     _deviceRepository.updateDeviceInfo();
//   } catch (_) {
//     print('error:\t_onDeviceUpdateInfoEvent');
//     _deviceRepository.updateDeviceInfo();
//     rethrow;
//   }
// }
}
