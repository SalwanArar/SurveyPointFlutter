part of '../settings_page.dart';

// class _Section4 extends StatefulWidget {
//   const _Section4({Key? key}) : super(key: key);
//
//   @override
//   State<_Section4> createState() => _Section4State();
// }

class _Section4 extends StatelessWidget {
  const _Section4({Key? key}) : super(key: key);

  // List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  // final _wifi = WiFiScan.instance;
  //
  // Future<List<WiFiAccessPoint>> getWifiAccessPoints() async {
  //   if (await WiFiForIoTPlugin.isWiFiAPEnabled()) {
  //     await WiFiForIoTPlugin.setWiFiAPEnabled(true);
  //   }
  //   else{
  //     await WiFiForIoTPlugin.setEnabled(true);
  //   }
  //   await Future.delayed(const Duration(seconds: 1));
  //   switch (await _wifi.canStartScan()) {
  //     case CanStartScan.yes:
  //       if (await _wifi.startScan()) {
  //         switch (await _wifi.canGetScannedResults()) {
  //           case CanGetScannedResults.yes:
  //             return await _wifi.getScannedResults();
  //           default:
  //             return accessPoints;
  //         }
  //       }
  //       return accessPoints;
  //     default:
  //       return accessPoints;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    getKioskMode().then((value) => _kioskMode = value == KioskMode.enabled);
    return Center(
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (builderContext) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: BlocProvider.of<AuthenticationBloc>(context),
                    ),
                    BlocProvider.value(
                      value: BlocProvider.of<StatusBarCubit>(context),
                    )
                  ],
                  child: const _UnlinkDialog(),
                ),
              );
            },
            icon: const FaIcon(
              FontAwesomeIcons.rightFromBracket,
              size: 18.0,
            ),
            label: Text(AppLocalizations.of(context)!.reset),
          ),
          const SizedBox(width: 8.0),
          OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const WiFiButtonDialog(),
                // builder: (_) => AccessPointDialog(
                //   getWifiAccessPoints: getWifiAccessPoints(),
                //   bssidName: null,
                // ),
              );
            },
            icon: const FaIcon(
              FontAwesomeIcons.wifi,
              size: 18.0,
            ),
            label: Text(AppLocalizations.of(context)!.networkSettings),
          ),
          const Spacer(),
          Text(
            AppLocalizations.of(context)!.kioskMode,
            style: Theme.of(context).textTheme.button,
          ),
          const SizedBox(
            width: 4.0,
          ),
          FutureBuilder<KioskMode>(
            future: getKioskMode(),
            builder: (context, snapshot) {
              _kioskMode = snapshot.data == KioskMode.enabled;
              return StatefulBuilder(
                builder: (context, setState) {
                  return FlutterSwitch(
                    value: _kioskMode,
                    height: 32,
                    width: 52,
                    activeColor: Theme.of(context).primaryColor,
                    toggleSize: 24,
                    onToggle: (bool value) {
                      setState(() {
                        _kioskMode = value;
                      });
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _UnlinkDialog extends StatelessWidget {
  const _UnlinkDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var statusBar = context.select<StatusBarCubit, StatusBarState>(
      (cubit) => cubit.state,
    );
    return Directionality(
      textDirection: getDirectionally(statusBar.local),
      child: AlertDialog(
        title: Text(
          // TODO: headline 2
          // style: Theme.of(context).textTheme.headline2,
          AppLocalizations.of(context)!.reset,
        ),
        content: Container(
          // TODO: const maxWidthDialog
          constraints: const BoxConstraints(maxWidth: 512.0),
          child: Text(
            // TODO: headline 4
            // style: Theme.of(context).textTheme.headline4,
            AppLocalizations.of(context)!.resetMsg,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (!statusBar.serverConnectionStatus) {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (builderContext) => BlocProvider.value(
                    value: BlocProvider.of<AuthenticationBloc>(context),
                    child: const _UnlinkDialogWarning(),
                  ),
                );
              } else {
                BlocProvider.of<AuthenticationBloc>(context).add(
                  const AuthenticationLogout(),
                );
              }
            },
            child: Text(
              AppLocalizations.of(context)!.reset,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnlinkDialogWarning extends StatelessWidget {
  const _UnlinkDialogWarning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Local local = context.select<StatusBarCubit, Local>(
      (cubit) => cubit.state.local,
    );
    return Directionality(
      textDirection: getDirectionally(local),
      child: AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.reset,
          // TODO: headline 2
          style: Theme.of(context).textTheme.headline2,
        ),
        content: Container(
          // TODO: const maxWidthDialog
          constraints: const BoxConstraints(maxWidth: 512.0),
          child: Text(
            AppLocalizations.of(context)!.resetConfirmation,
            // TODO: headline 4
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                const AuthenticationLogout(),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.reset,
            ),
          ),
        ],
      ),
    );
  }
}
