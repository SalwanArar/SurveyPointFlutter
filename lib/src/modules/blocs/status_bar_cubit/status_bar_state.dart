part of 'status_bar_cubit.dart';

class StatusBarState extends Equatable {
  const StatusBarState._({
    this.internetConnectionStatus = false,
    this.serverConnectionStatus = false,
    required this.local,
  });

  final bool internetConnectionStatus;
  final bool serverConnectionStatus;
  final Local local;

  const StatusBarState.turnInternetOn(
      bool serverConnectionStatus,
      Local local,
      ) : this._(
    internetConnectionStatus: true,
    serverConnectionStatus: serverConnectionStatus,
    local: local,
  );

  const StatusBarState.turnInternetOff(
      Local local,
      ) : this._(
    internetConnectionStatus: false,
    serverConnectionStatus: false,
    local: local,
  );

  const StatusBarState.changeServerConnectionStatus(
      bool internetConnectionStatus,
      bool serverConnectionStatus,
      Local local,
      ) : this._(
    internetConnectionStatus: internetConnectionStatus,
    serverConnectionStatus: serverConnectionStatus,
    local: local,
  );

  const StatusBarState.changeLocale(
      Local local,
      bool internetConnectionStatus,
      bool serverConnectionStatus,
      ) : this._(
    local: local,
    internetConnectionStatus: internetConnectionStatus,
    serverConnectionStatus: serverConnectionStatus,
  );

  @override
  List<Object> get props => [
    internetConnectionStatus,
    serverConnectionStatus,
    local,
  ];
}

