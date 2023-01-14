part of 'custom_widgets.dart';

class WiFiButton extends StatefulWidget {
  const WiFiButton({
    Key? key,
  }) : super(key: key);

  @override
  State<WiFiButton> createState() => _WiFiButtonState();
}

class _WiFiButtonState extends State<WiFiButton> {
  String? _ssid;

  getSsid() async {
    String? ssid = await WiFiForIoTPlugin.getSSID();
    setState(
      () {
        if (ssid == '<unknown ssid>') ssid = null;
        _ssid = ssid;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getSsid();
    InternetConnectionCheckerPlus().onStatusChange.listen((event) {
      getSsid();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (builderContext) => const WiFiButtonDialog(),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.wifi,
            color: color,
            size: 38.0,
          ),
          const SizedBox(height: 6),
          Text(
            _ssid ?? AppLocalizations.of(context)!.wifi,
            style: TextStyle(
              fontSize: 14.0,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class WiFiButtonDialog extends StatefulWidget {
  const WiFiButtonDialog({Key? key}) : super(key: key);

  @override
  State<WiFiButtonDialog> createState() => _WiFiButtonDialogState();
}

class _WiFiButtonDialogState extends State<WiFiButtonDialog> {
  String _bssid = '';

  Future<List<WiFiAccessPoint>?> getNetworks() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!await WiFiForIoTPlugin.isEnabled()) {
      return null;
    }
    if (await WiFiScan.instance.canGetScannedResults() ==
        CanGetScannedResults.yes) {
      return WiFiScan.instance.getScannedResults();
    }
    return null;
  }

  getBssid() async {
    String? bssid;
    try {
      bssid = await WiFiForIoTPlugin.getBSSID();
    } catch (_) {}
    bssid ??= '';
    setState(() {
      _bssid = bssid!.toLowerCase();
    });
  }

  @override
  void initState() {
    super.initState();
    getBssid();
  }

  @override
  Widget build(BuildContext context) {
    Local local = context.select((StatusBarCubit cubit) => cubit.state.local);
    return Directionality(
      textDirection: getDirectionally(local),
      child: FutureBuilder(
        future: getNetworks(),
        builder: (futureContext, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white70,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          if (snapshot.data != null) {
            var availableNetworks = snapshot.data!;
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.availableNetworks),
              content: availableNetworks.isEmpty
                  ? Text(AppLocalizations.of(context)!.noAvailableNetworks)
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ListView.separated(
                        itemBuilder: (itemBuilder, index) {
                          Color? connectedColor =
                              _bssid == availableNetworks[index].bssid
                                  ? Theme.of(context).colorScheme.primary
                                  : null;
                          bool isHidden = availableNetworks[index].ssid.isEmpty;
                          return ListTile(
                            onTap: connectToWiFi(availableNetworks[index].ssid),
                            textColor: connectedColor,
                            title: Text(
                              isHidden
                                  ? '<HIDDEN>'
                                  : availableNetworks[index].ssid,
                              style: TextStyle(
                                fontStyle: isHidden ? FontStyle.italic : null,
                              ),
                            ),
                            leading: FaIcon(
                              _wifiIcon(availableNetworks[index].level),
                              color: connectedColor,
                            ),
                          );
                        },
                        separatorBuilder: (separatorBuilder, index) {
                          return const Divider();
                        },
                        itemCount: snapshot.data!.length,
                      ),
                    ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.ok),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.connectionFailed),
              content: Text(snapshot.error.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.ok),
                ),
              ],
            );
          }
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.wifiSettings),
            content: Text(AppLocalizations.of(context)!.wifiCheckConnection),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          );
        },
      ),
    );
  }

  connectToWiFi(String ssid) {
    return () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => ConnectToWiFiDialog(
          ssid: ssid,
        ),
      ).then(
        (value) => WiFiForIoTPlugin.isConnected().then(
          (value) => value ? Navigator.pop(context) : null,
        ),
      );
    };
  }
}

class ConnectToWiFiDialog extends StatefulWidget {
  const ConnectToWiFiDialog({
    Key? key,
    required this.ssid,
  }) : super(key: key);
  final String ssid;

  @override
  State<ConnectToWiFiDialog> createState() => _ConnectToWiFiDialogState();
}

class _ConnectToWiFiDialogState extends State<ConnectToWiFiDialog> {
  late final TextEditingController ssidController;
  late final FocusNode ssidNode;

  late final TextEditingController passwordController;
  late final FocusNode passwordNode;

  late final String _ssid;

  bool obscureText = false;

  @override
  void initState() {
    _ssid = widget.ssid;
    ssidController = TextEditingController();
    ssidNode = FocusNode();
    passwordNode = FocusNode();
    passwordController = TextEditingController();
    super.initState();
    stopKioskMode();
    InternetConnectionCheckerPlus().onStatusChange.listen((event) {
      if (event == InternetConnectionStatus.connected) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    ssidController.dispose();
    ssidNode.dispose();
    passwordController.dispose();
    passwordNode.dispose();
    startKioskMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Local local = context.select(
      (StatusBarCubit cubit) => cubit.state.local,
    );
    double width = MediaQuery.of(context).size.width * 0.8;
    return Directionality(
      textDirection: getDirectionally(local),
      child: AlertDialog(
        title: Text(
          AppLocalizations.of(context)!
              .connectToWiFiDialogTitle(_ssid.isEmpty ? 'Wi-Fi' : '"$_ssid"'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_ssid.isEmpty) ...[
              textFormField(
                ssidController,
                ssidNode,
                AppLocalizations.of(context)!.ssid(''),
                autoFocus: true,
              ),
              const SizedBox(height: 16.0),
            ],
            textFormField(
              passwordController,
              passwordNode,
              AppLocalizations.of(context)!.password,
              autoFocus: _ssid.isNotEmpty,
              obscureText: obscureText,
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              child: CheckboxListTile(
                value: obscureText,
                enableFeedback: false,
                activeColor: Theme.of(context).colorScheme.primary,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(
                    () => obscureText = value!,
                  );
                },
                title: Text(AppLocalizations.of(context)!.showPassword),
              ),
            ),
            const SizedBox(height: 32.0),
            Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox(
                height: 224.0,
                width: width,
                child: CustomKeyboard(
                  systemKeyboard: true,
                  onTextInput: (val) {
                    if (passwordNode.hasFocus) {
                      insertText(val, passwordController, 64);
                    }
                    if (ssidNode.hasFocus) {
                      insertText(val, ssidController, 32);
                    }
                  },
                  onBackspace: () {
                    if (passwordNode.hasFocus) {
                      backspace(passwordController);
                    }
                    if (ssidNode.hasFocus) {
                      backspace(ssidController);
                    }
                  },
                  onDone: null,
                ),
              ),
            ),
            const SizedBox(height: 32.0),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              String ssid = _ssid.isEmpty ? ssidController.text : _ssid;
              print(ssid);
              print(passwordController.text);
              await WiFiForIoTPlugin.registerWifiNetwork(
                ssid,
                password: passwordController.text,
                isHidden: _ssid.isEmpty,
                security: passwordController.text.isEmpty
                    ? NetworkSecurity.NONE
                    : NetworkSecurity.WPA,
              ).then(
                (value) async {
                  print(value);
                  if (value) {
                    Navigator.pop(context);
                  }
                },
              );
            },
            child: Text(
              AppLocalizations.of(context)!.connect,
            ),
          ),
        ],
      ),
    );
  }

  textFormField(
    TextEditingController controller,
    FocusNode focusNode,
    String label, {
    bool autoFocus = false,
    bool? obscureText,
  }) =>
      TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autoFocus,
        keyboardType: TextInputType.none,
        textDirection: TextDirection.ltr,
        obscureText: obscureText == null ? false : !obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(label),
        ),
      );
}
