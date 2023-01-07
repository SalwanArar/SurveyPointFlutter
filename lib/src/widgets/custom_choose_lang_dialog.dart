part of 'custom_widgets.dart';

Widget languageDialog(BuildContext context) {
  return SimpleDialog(
    title: CustomCenterText(
      AppLocalizations.of(context)!.chooseLanguage,
    ),
    children: [
      ListTile(
        leading: const Icon(FontAwesomeIcons.globe),
        title: const Text('English'),
        onTap: () {
          BlocProvider.of<StatusBarCubit>(context).onLocalChanged(
            Local.en,
          );
          setGlobalLocale(Local.en.name);
          Navigator.pop(context);
          Toast.show(
            'Might take some time to change the language!',
            // TODO: config/consts assetsToastChangeLanguageDuration = 3
            duration: 3,
          );
        },
      ),
      ListTile(
        leading: const Icon(FontAwesomeIcons.globe),
        title: const Text('العربية'),
        onTap: () {
          Navigator.pop(context);
          BlocProvider.of<StatusBarCubit>(context).onLocalChanged(
            Local.ar,
          );
          setGlobalLocale(Local.ar.name);
          Toast.show(
            'قد يستغرق تغيير اللغة بعض الوقت!',
            // TODO: config/consts assetsToastChangeLanguageDuration = 3
            duration: 3,
          );
        },
      ),
    ],
  );
}
