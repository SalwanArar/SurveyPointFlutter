part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();
}

class DeviceStatusChangeEvent extends DeviceEvent {
  const DeviceStatusChangeEvent(this.deviceStatus, this.deviceInfo);

  final DeviceAuthenticatedStatus deviceStatus;
  final DeviceInfo? deviceInfo;

  @override
  List<Object?> get props => [
        deviceStatus,
        deviceInfo,
      ];
}

class DeviceSurveyStatusEvent extends DeviceEvent {
  const DeviceSurveyStatusEvent(this.business);

  final Business business;

  @override
  List<Object?> get props => [business];
}

class DeviceRegistrationStatusEvent extends DeviceEvent {
  const DeviceRegistrationStatusEvent(this.registration);

  final Registration registration;

  @override
  List<Object?> get props => [];
}

class DeviceSettingsStatusEvent extends DeviceEvent {
  @override
  List<Object?> get props => [];
}

class DeviceOutOfServiceEvent extends DeviceEvent {
  const DeviceOutOfServiceEvent(this.outOfService);
  final bool outOfService;

  @override
  List<Object?> get props => [outOfService];
}

// class DeviceUpdateInfoEvent extends DeviceEvent {
//   const DeviceUpdateInfoEvent();
//
//   @override
//   List<Object?> get props => [];
// }
