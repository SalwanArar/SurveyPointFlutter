part of 'setup_page.dart';

class _SetupInfo {
  _SetupInfo({
    // required this.title,
    required this.msg,
    this.deviceCode,
  });

  // String title;
  String? deviceCode;
  DeviceStatus msg;
}

class _SetupLayout extends StatelessWidget {
  const _SetupLayout({
    Key? key,
    // required this.title,
    required this.onRefresh,
    required this.size,
    required this.deviceCode,
  }) : super(key: key);

  // final String title;
  final Function() onRefresh;
  final Size size;
  final String? deviceCode;

  Widget _iconWidget(IconData icon, String title, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(
          icon,
          color: color,
          size: 38.0,
        ),
        const SizedBox(height: 6),
        Text(
          title,
          // TODO: textStyle icon setup title
          style: TextStyle(
            fontSize: 14.0,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    ToastContext().init(context);
    bool internetConnectivity = context.select(
      (StatusBarCubit cubit) => cubit.state.internetConnectionStatus,
    );
    String title = context.select(
      (StatusBarCubit cubit) => cubit.state.serverConnectionStatus
          ? AppLocalizations.of(context)!.welcomeTitle
          : cubit.state.internetConnectionStatus
              ? AppLocalizations.of(context)!.serverError
              : AppLocalizations.of(context)!.connectToInternetMsg,
    );
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: size.height * 0.225,
        horizontal: size.width * 0.225,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 3.0),
        borderRadius: BorderRadius.circular(28.0),
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(127),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            // fit: FlexFit.tight,
            child: Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    // TODO:: config/consts assetsWarningSetUp = 82
                    child: Image.asset(
                      assetWarningSign,
                      height: 82.0,
                      width: 82.0,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      internetConnectivity
                          ? AppLocalizations.of(context)!.internetConnected
                          : AppLocalizations.of(context)!.internetNotConnected,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16.0,
                        color: internetConnectivity
                            ? Colors.green
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Colors.black,
                    ),
                textAlign: TextAlign.center,
                textDirection:
                    context.read<StatusBarCubit>().state.local == Local.ar
                        ? TextDirection.rtl
                        : null,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Visibility(
              visible: deviceCode != null,
              child: Text(
                deviceCode ?? 'Please try again!',
                // TODO: add text style
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0,
                  fontFamily: getFontFamily(Local.en),
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: deviceCodeLetterSpacing,
                ),
              ),
            ),
          ),
          // const SizedBox(height: ,),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // GestureDetector(
                //   onTap: () {
                //     showDialog(
                //       context: context,
                //       barrierDismissible: false,
                //       builder: (builderContext) => const WifiSettings(),
                //     );
                //   },
                //   child: const Text('Wi-Fi'),
                // ),
                const WiFiButton(),
                const SizedBox(width: 32.0),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => languageDialog(context),
                    );
                  },
                  child: _iconWidget(
                    FontAwesomeIcons.globe,
                    AppLocalizations.of(context)!.chooseLanguage,
                    primaryColor,
                  ),
                ),
                const SizedBox(width: 32.0),
                GestureDetector(
                  onTap: onRefresh,
                  child: _iconWidget(
                    FontAwesomeIcons.arrowsRotate,
                    // TODO: add localization
                    AppLocalizations.of(context)!.refresh,
                    primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WifiSettings extends StatefulWidget {
  const WifiSettings({Key? key}) : super(key: key);

  @override
  State<WifiSettings> createState() => _WifiSettingsState();
}

class _WifiSettingsState extends State<WifiSettings> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  final _wifi = WiFiScan.instance;
  String? ssidName;
  String? bssidName;

  setSsidName() async {
    if (await WiFiForIoTPlugin.isConnected()) {
      String? ssid = await WiFiForIoTPlugin.getSSID();
      String? bssid = await WiFiForIoTPlugin.getBSSID();
      if (ssid != null && ssid == '<unknown ssid>') ssid = null;
      if (bssid != null && bssid == '<unknown ssid>') bssid = null;
      setState(
        () {
          ssidName = ssid;
          bssidName = bssid;
        },
      );
    } else {
      setState(
        () {
          ssidName = null;
          bssidName = null;
        },
      );
    }
  }

  Future<List<WiFiAccessPoint>> _getWifiAccessPoints() async {
    if (await WiFiForIoTPlugin.isWiFiAPEnabled()) {
      print('isWiFiAPEnabled:\ttrue');
      bool tmp = await WiFiForIoTPlugin.setWiFiAPEnabled(true);
      print('setWiFiAPEnabled:\t$tmp');
    } else {
      print('isWiFiAPEnabled:\tfalse');
      // bool tmp = await WiFiForIoTPlugin.setEnabled(true);
      // print('setEnabled:\t$tmp');
    }
    await Future.delayed(const Duration(seconds: 1));
    await stopKioskMode();
    var canStartScan = await _wifi.canStartScan();
    switch (canStartScan) {
      case CanStartScan.yes:
        if (await _wifi.startScan()) {
          switch (await _wifi.canGetScannedResults()) {
            case CanGetScannedResults.yes:
              return await _wifi.getScannedResults();
            default:
              return accessPoints;
          }
        }
        return accessPoints;
      default:
        // TODO: remove print
        debugPrint(canStartScan.name);
        return accessPoints;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSsidName();

    InternetConnectionCheckerPlus().onStatusChange.listen(
          (status) => setSsidName(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await AndroidFlutterWifi.isWifiEnabled()) {
          showDialog(
            context: context,
            builder: (_) => AccessPointDialog(
              getWifiAccessPoints: _getWifiAccessPoints(),
              bssidName: bssidName,
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (_) => SimpleDialog(
              clipBehavior: Clip.hardEdge,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('False'),
                )
              ],
              // onPressed: () => Navigator.pop(context),
            ),
          );
        }
      },
      child: _iconWidget(
        FontAwesomeIcons.wifi,
        ssidName ?? AppLocalizations.of(context)!.wifi,
        Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _iconWidget(IconData icon, String title, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(
          icon,
          color: color,
          // TODO: const setupIconsSize
          size: 38.0,
        ),
        const SizedBox(height: 6),
        Text(
          title,
          // TODO: textStyle icon setup title
          style: TextStyle(
            fontSize: 14.0,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
