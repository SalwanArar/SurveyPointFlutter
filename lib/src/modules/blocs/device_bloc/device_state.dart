part of 'device_bloc.dart';

class DeviceState extends Equatable {
  const DeviceState._({
    this.deviceStatus = DeviceAuthenticatedStatus.unknown,
    this.deviceInfo = DeviceInfo.empty,
  });

  DeviceState copyWith({
    DeviceAuthenticatedStatus? deviceStatus,
    DeviceInfo? deviceInfo,
  }) =>
      DeviceState._(
        deviceStatus: deviceStatus ?? this.deviceStatus,
        deviceInfo: deviceInfo ?? this.deviceInfo,
      );

  const DeviceState.unknown() : this._();

  const DeviceState.survey(
    DeviceInfo deviceInfo,
  ) : this._(
          deviceStatus: DeviceAuthenticatedStatus.survey,
          deviceInfo: deviceInfo,
        );

  const DeviceState.registration(
    DeviceInfo deviceInfo,
  ) : this._(
          deviceStatus: DeviceAuthenticatedStatus.registration,
          deviceInfo: deviceInfo,
        );

  const DeviceState.outOfService(DeviceInfo deviceInfo)
      : this._(
          deviceStatus: DeviceAuthenticatedStatus.outOfService,
          deviceInfo: deviceInfo,
        );

  const DeviceState.settings(DeviceInfo deviceInfo)
      : this._(
          deviceStatus: DeviceAuthenticatedStatus.settings,
    deviceInfo: deviceInfo,
        );

  final DeviceAuthenticatedStatus deviceStatus;
  final DeviceInfo deviceInfo;

  @override
  List<Object> get props => [
        deviceStatus,
        deviceInfo,
      ];
}