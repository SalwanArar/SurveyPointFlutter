part of '../settings_page.dart';

class _Section3 extends StatefulWidget {
  const _Section3({Key? key}) : super(key: key);

  @override
  State<_Section3> createState() => _Section3State();
}

class _Section3State extends State<_Section3> {
  bool outOfService = _outOfService;

  @override
  Widget build(BuildContext context) {
    // TODO: constant settingIconSize = 18
    const double settingIconSize = 18;
    return Center(
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: () {
              // showDialog(
              //   context: context,
              //   builder: (context) => const Updater(),
              // );
            },
            icon: const FaIcon(
              FontAwesomeIcons.rotate,
              size: settingIconSize,
            ),
            label: Text(AppLocalizations.of(context)!.checkUpdate),
          ),
          const SizedBox(width: 8.0),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const FaIcon(
              FontAwesomeIcons.circleExclamation,
              size: settingIconSize,
            ),
            label: Text(AppLocalizations.of(context)!.log),
          ),
          const Spacer(),
          Text(
            AppLocalizations.of(context)!.outOfService,
            style: Theme.of(context).textTheme.button,
          ),
          const SizedBox(
            width: 4.0,
          ),
          FlutterSwitch(
            value: outOfService,
            height: 32,
            width: 52,
            activeColor: Theme.of(context).primaryColor,
            toggleSize: 24,
            onToggle: (bool value) {
              setState(() {
                outOfService = value;
                _outOfService = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
