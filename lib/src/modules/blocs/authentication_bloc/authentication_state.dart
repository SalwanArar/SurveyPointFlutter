part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.deviceInfo = DeviceInfo.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.authenticated(DeviceInfo deviceInfo)
      : this._(
          status: AuthenticationStatus.authenticated,
          deviceInfo: deviceInfo,
        );

  // const AuthenticationState.agreement()
  //     : this._(
  //         status: AuthenticationStatus.agreement,
  //       );

  final AuthenticationStatus status;
  final DeviceInfo deviceInfo;

  @override
  List<Object> get props => [
        status,
        deviceInfo,
      ];
}
