part of '../settings_page.dart';

class _Section5 extends StatefulWidget {
  const _Section5({Key? key}) : super(key: key);

  @override
  State<_Section5> createState() => _Section5State();
}

class _Section5State extends State<_Section5> {
  deviceRepositoryListener() {
    DeviceInfo info = BlocProvider.of<DeviceBloc>(context).state.deviceInfo;
    DeviceAuthenticatedStatus status;
    if (info.outOfService) {
      status = DeviceAuthenticatedStatus.outOfService;
    } else if (info.business != null) {
      status = DeviceAuthenticatedStatus.survey;
    } else if (info.registration != null) {
      status = DeviceAuthenticatedStatus.registration;
    } else {
      status = DeviceAuthenticatedStatus.outOfService;
    }
    return BlocProvider.of<DeviceBloc>(context).add(
      DeviceStatusChangeEvent(
        status,
        info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool oldInService = context.select(
      (DeviceBloc bloc) => bloc.state.deviceInfo.outOfService,
    );
    const double textButtonFontSize = 16.0;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.visitSiteMsg,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const _TermsAndConditionsSettings(),
                      );
                    },
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: textButtonFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child:
                        Text(AppLocalizations.of(context)!.termsAndCondition),
                  ),
                  const SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const _ContactUsSettings(),
                      );
                    },
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: textButtonFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.aboutUs),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: () => deviceRepositoryListener(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          const SizedBox(width: 16.0),
          ElevatedButton(
            onPressed: () async {
              // showDialog(
              //   context: context,
              //   builder: (_) => BlocProvider.value(
              //     value: BlocProvider.of<DeviceBloc>(context),
              //     child: SimpleDialog(
              //       children: [
              //         CustomCircularIndicator(
              //           title: AppLocalizations.of(context)!.pleaseWait,
              //           isSystem: true,
              //           isSurvey: false,
              //         ),
              //       ],
              //     ),
              //   ),
              // );
              // bool oldInService =
              //     context.read<DeviceBloc>().state.deviceInfo.outOfService;
              if (_outOfService != oldInService) {
                // TODO: add out of service event to device bloc
                print("outOfServiceChanged!!!!!");
                BlocProvider.of<DeviceBloc>(context).add(
                  DeviceOutOfServiceEvent(_outOfService),
                );
              }
              if ((await getKioskMode() == KioskMode.enabled) != _kioskMode) {
                if (_kioskMode) {
                  await startKioskMode();
                } else {
                  await stopKioskMode();
                }
              }
              deviceRepositoryListener();
            },
            child: Text(AppLocalizations.of(context)!.saveSettings),
          ),
        ],
      ),
    );
  }
}

class _TermsAndConditionsSettings extends StatelessWidget {
  const _TermsAndConditionsSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Local local = context.select(
      (StatusBarCubit cubit) => cubit.state.local,
    );
    return Directionality(
      textDirection: getDirectionally(local),
      child: AlertDialog(
        title: Text(AppLocalizations.of(context)!.termsTitle),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            // TODO: const set dialog constraints
            maxWidth: MediaQuery.of(context).size.width * 0.35,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                // TODO: const paddingBottomDividerDialog
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 2,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.terms,
                // TODO: set headline dialog content
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.ok,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactUsSettings extends StatefulWidget {
  const _ContactUsSettings({Key? key}) : super(key: key);

  @override
  State<_ContactUsSettings> createState() => _ContactUsSettingsState();
}

class _ContactUsSettingsState extends State<_ContactUsSettings> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    Local local = context.select(
      (StatusBarCubit cubit) => cubit.state.local,
    );
    // TODO: delete card theme
    const EdgeInsets cardMargin = EdgeInsets.symmetric(vertical: 8.0);
    final Color cardColor = Theme.of(context).colorScheme.primaryContainer;
    // TODO: delete ListTile theme
    final Color iconColor = Theme.of(context).colorScheme.primary;
    return Directionality(
      textDirection: getDirectionally(local),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          // TODO: const set dialog constraints
          maxWidth: MediaQuery.of(context).size.width * 0.35,
        ),
        child: AlertDialog(
          // TODO: AlertDialog title theme
          title: Text(AppLocalizations.of(context)!.aboutUs),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                // TODO: const paddingBottomDividerDialog
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 2,
                ),
              ),
              Card(
                // TODO: add card theme
                color: cardColor,
                margin: cardMargin,
                child: ListTile(
                  // TODO: add ListTile theme
                  iconColor: iconColor,
                  leading: const FaIcon(FontAwesomeIcons.buildingUser),
                  title: Text(AppLocalizations.of(context)!.companyName),
                  subtitle: const Text('NetCore IT Solutions'),
                ),
              ),
              Card(
                // TODO: add card theme
                color: cardColor,
                margin: cardMargin,
                child: ListTile(
                  // TODO: add ListTile theme
                  iconColor: iconColor,
                  leading: const FaIcon(FontAwesomeIcons.android),
                  title: Text(AppLocalizations.of(context)!.appName),
                  subtitle: Text(_packageInfo.appName.isEmpty
                      ? 'Not set'
                      : _packageInfo.appName),
                ),
              ),
              Card(
                // TODO: add card theme
                color: cardColor,
                margin: cardMargin,
                child: ListTile(
                  // TODO: add ListTile theme
                  iconColor: iconColor,
                  leading: const FaIcon(FontAwesomeIcons.hashtag),
                  title: Text(AppLocalizations.of(context)!.appVersion),
                  subtitle: Text(_packageInfo.version.isEmpty
                      ? 'Not set'
                      : _packageInfo.version),
                ),
              ),
              Card(
                // TODO: add card theme
                color: cardColor,
                margin: cardMargin,
                child: const Padding(
                  padding: cardMargin,
                  child: _ContactsField(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.ok),
            )
          ],
        ),
      ),
    );
  }
}

class _ContactsField extends StatelessWidget {
  const _ContactsField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // TODO: delete ListTile theme
    Color iconColor = Theme.of(context).colorScheme.primary;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: size.width * 0.45,
        maxHeight: size.height * 0.4,
      ),
      child: ListTile(
        // TODO: add ListTile theme
        iconColor: iconColor,
        leading: const FaIcon(FontAwesomeIcons.solidAddressCard),
        title: Text(AppLocalizations.of(context)!.contacts),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    // TODO: add ListTile theme
                    iconColor: iconColor,
                    leading: const FaIcon(
                      FontAwesomeIcons.phone,
                    ),
                    title: Text(AppLocalizations.of(context)!.phoneNumber),
                    subtitle: const Text('+971 54 321 4321'),
                  ),
                  ListTile(
                    // TODO: add ListTile theme
                    iconColor: iconColor,
                    leading: const FaIcon(
                      FontAwesomeIcons.mobile,
                    ),
                    title: Text(AppLocalizations.of(context)!.mobileNumber),
                    subtitle: const Text('+971 54 321 4321'),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    // TODO: add ListTile theme
                    iconColor: iconColor,
                    leading: const FaIcon(
                      FontAwesomeIcons.wallet,
                    ),
                    title: Text(AppLocalizations.of(context)!.salesEmail),
                    subtitle: const Text('info@netcore.ae'),
                  ),
                  ListTile(
                    // TODO: add ListTile theme
                    iconColor: iconColor,
                    leading: const FaIcon(
                      FontAwesomeIcons.headset,
                    ),
                    title: Text(AppLocalizations.of(context)!.supportEmail),
                    subtitle: const Text('support@netcore.ae'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
