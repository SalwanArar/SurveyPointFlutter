part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AuthenticationStatusChanged extends AuthenticationEvent {
  const AuthenticationStatusChanged(this.status);

  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];
}

class AuthenticationLogout extends AuthenticationEvent {
  const AuthenticationLogout();

  @override
  List<Object?> get props => [];
}


class AuthenticationDeviceInfoChanged extends AuthenticationEvent {
  const AuthenticationDeviceInfoChanged(this.deviceInfo);

  final DeviceInfo deviceInfo;

  @override
  List<Object?> get props => [deviceInfo];
}


class AuthenticationRestart extends AuthenticationEvent {
  const AuthenticationRestart();

  @override
  List<Object?> get props => [];
}

//
// class AuthenticationStatusRefresh extends AuthenticationEvent {
//   @override
//   List<Object> get props => [];
// }
