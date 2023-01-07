import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../constants/enums.dart';

part 'status_bar_state.dart';

class StatusBarCubit extends Cubit<StatusBarState> {
  StatusBarCubit(Local local) : super(StatusBarState._(local: local));

  void onChangeInternetStatus(bool internetStatus) => emit(
    internetStatus
        ? StatusBarState.turnInternetOn(
      state.serverConnectionStatus,
      state.local,
    )
        : StatusBarState.turnInternetOff(
      state.local,
    ),
  );

  void onChangeServerStatus(bool serverStatus) => emit(
    StatusBarState.changeServerConnectionStatus(
      state.internetConnectionStatus,
      serverStatus,
      state.local,
    ),
  );

  Future<void> onLocalChanged(Local local) async => emit(
    StatusBarState.changeLocale(
      local,
      state.internetConnectionStatus,
      state.serverConnectionStatus,
    ),
  );

}
