part of 'custom_widgets.dart';

class AccessPointDialog extends StatelessWidget {
  const AccessPointDialog({
    Key? key,
    required this.getWifiAccessPoints,
    required this.bssidName,
  }) : super(key: key);
  final Future<List<WiFiAccessPoint>> getWifiAccessPoints;
  final String? bssidName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final Local local = context.select(
    //   (StatusBarCubit cubit) => cubit.state.local,
    // );
    // return Directionality(
    //   textDirection: getDirectionally(local),
    //   child:
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.availableNetworks,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      content: FutureBuilder<List<WiFiAccessPoint>>(
        future: getWifiAccessPoints,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                height: size.height * 0.2,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Text(AppLocalizations.of(context)!.tryAgain);
              }
              return SizedBox(
                width: size.width * 0.9,
                height: size.height * 0.9,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) => RawMaterialButton(
                    onPressed: () {
                      debugPrint(snapshot.data![index].ssid);
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (builderContext) => _WifiConnectForm(
                          ssid: snapshot.data![index].ssid,
                        ),
                      );
                    },
                    child: ListTile(
                      leading: FaIcon(
                        _wifiIcon(
                          snapshot.data![index].level,
                        ),
                        size: 32.0,
                        color: snapshot.data![index].bssid == bssidName
                            ? Colors.green
                            : null,
                      ),
                      title: Text(
                        snapshot.data![index].ssid == ''
                            ? 'HIDDEN'
                            : snapshot.data![index].ssid,
                        style: snapshot.data![index].ssid == ''
                            ? const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              );
          }
        },
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // _stopListeningToScanResults();
            Navigator.pop(context);
          },
          child: FaIcon(
            FontAwesomeIcons.circleXmark,
            size: 64.0,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
      // ),
    );
  }
}

IconData _wifiIcon(int level) {
  if (level > -31) return Icons.signal_wifi_4_bar;
  if (level > -68) return Icons.network_wifi_3_bar;
  if (level > -71) return Icons.network_wifi_2_bar;
  if (level > -81) return Icons.network_wifi_1_bar;
  return Icons.signal_wifi_0_bar;
}

class _WifiConnectForm extends StatefulWidget {
  const _WifiConnectForm({Key? key, required this.ssid}) : super(key: key);
  final String ssid;

  @override
  State<_WifiConnectForm> createState() => _WifiConnectFormState();
}

class _WifiConnectFormState extends State<_WifiConnectForm> {
  final TextEditingController _ssidController = TextEditingController();

  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    stopKioskMode();
    super.initState();
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    startKioskMode();
    super.dispose();
  }

  restartApp() async => context.read<AuthenticationBloc>().add(
        const AuthenticationRestart(),
      );

  showToast() => Toast.show(
        AppLocalizations.of(context)!.wifiRegisteredToast,
        duration: 3,
        border: Border.all(
          color: colorScheme.primary,
        ),
        backgroundColor: colorScheme.primaryContainer,
        textStyle: TextStyle(
          color: colorScheme.onPrimaryContainer,
        ),
      );

  popUp() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Local local = context.select(
      (StatusBarCubit cubit) => cubit.state.local,
    );
    WiFiForIoTPlugin();
    ToastContext().init(context);
    return Directionality(
      textDirection: getDirectionally(local),
      child: AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.ssid(
            widget.ssid == '' ? 'Connect to the hidden network' : widget.ssid,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ssid != ''
            //     ?
            _CustomTextField(
              text: AppLocalizations.of(context)!.password,
              controller: _passwordController,
              // )
              // : Column(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       _CustomTextField(
              //         text: 'ssid',
              //         controller: _ssidController,
              //       ),
              //       const SizedBox(height: 16.0),
              //       _CustomTextField(
              //         text: 'password',
              //         controller: _passwordController,
              //       )
              //     ],
            ),
            const SizedBox(height: 24.0),
            Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox(
                height: size.height * 0.3,
                width: size.width * 0.8,
                child: CustomKeyboard(
                  systemKeyboard: true,
                  onTextInput: (String value) {
                    int length = 255;
                    insertText(value, _passwordController, length);
                  },
                  onBackspace: () => backspace(_passwordController),
                  onDone: () {},
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              // try {
              //   debugPrint('ssid');
              await WiFiForIoTPlugin.registerWifiNetwork(
                widget.ssid,
                password: _passwordController.text,
                security: NetworkSecurity.WPA,
              ).then((value) async {
                await WiFiForIoTPlugin.forceWifiUsage(true);
                restartApp();
              });
              // if () {
              //   debugPrint('Wi-Fi Network is connected successfully');
              //   await WiFiForIoTPlugin.forceWifiUsage(true);
              //   restartApp();
              // } else {
              //   showToast();
              //   print('msg');
              // }

              //   popUp();
              // } catch (e) {
              //   popUp();
              //   print('Connecting to wifi failed:\t${e.toString()}');
              // }
            },
            child: Text(
              AppLocalizations.of(context)!.connect,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  const _CustomTextField({
    Key? key,
    required String text,
    required TextEditingController controller,
  })  : _text = text,
        _controller = controller,
        super(key: key);
  final String _text;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      child: TextField(
        autofocus: true,
        controller: _controller,
        keyboardType: TextInputType.none,
        keyboardAppearance: Brightness.light,
        maxLines: 1,
        decoration: InputDecoration(
          labelText: _text,
          enabledBorder: const OutlineInputBorder(),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
