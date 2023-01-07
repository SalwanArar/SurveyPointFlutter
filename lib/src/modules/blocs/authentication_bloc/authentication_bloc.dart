import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:survey_point_05/src/utils/services/local_storage_service.dart';

import '../../../constants/enums.dart';

import '../../models/device_info.dart';
import '../../models/repositories/authentication_repository.dart';
import '../../models/repositories/device_repository.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required DeviceRepository deviceRepository,
  })  : _authenticationRepository = authenticationRepository,
        _deviceRepository = deviceRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogout>(_onAuthenticationLogout);
    on<AuthenticationDeviceInfoChanged>(_onAuthenticationDeviceInfoChanged);
    on<AuthenticationRestart>(_onAuthenticationRestart);
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(
        AuthenticationStatusChanged(status),
      ),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final DeviceRepository _deviceRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationRepository.dispose();
    _deviceRepository.dispose();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        await setLastUpdate('0001-01-01 01:01:01');
        DeviceInfo? deviceInfo = await _getDevice();
        return emit(
          deviceInfo == null
              ? const AuthenticationState.unauthenticated()
              : AuthenticationState.authenticated(deviceInfo),
        );
      // case AuthenticationStatus.agreement:
      //   return emit(const AuthenticationState.agreement());
    }
  }

  Future<void> _onAuthenticationDeviceInfoChanged(
    AuthenticationDeviceInfoChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationState.authenticated(event.deviceInfo));
  }

  Future<void> _onAuthenticationLogout(
    AuthenticationLogout event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      _authenticationRepository.logOut();
    } catch (e) {
      // TODO: catch error
      // TODO: remove print
      log('log: ${e.toString()}');
      rethrow;
    }
  }

  _getDevice() async => _deviceRepository.getDeviceInfo();

  Future<void> _onAuthenticationRestart(
    AuthenticationRestart event,
    Emitter<AuthenticationState> emit,
  ) async {
    final AuthenticationState oldStatus = state;
    emit(const AuthenticationState.unknown());
    emit(oldStatus);
  }
}
