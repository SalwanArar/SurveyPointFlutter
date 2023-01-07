part of '../settings_page.dart';

class _Section2 extends StatelessWidget {
  const _Section2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    Local local = context.select<StatusBarCubit, Local>(
      (cubit) => cubit.state.local,
    );
    return Center(
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (builderContext) => BlocProvider.value(
                  value: BlocProvider.of<StatusBarCubit>(context),
                  child: languageDialog(builderContext),
                ),
              );
            },
            icon: const FaIcon(
              FontAwesomeIcons.globe,
              // TODO: constant settingIconSize = 18.0
              size: 18.0,
            ),
            label: Text(AppLocalizations.of(context)!.chooseLanguage),
          ),
          const SizedBox(
            width: 8,
          ),
          OutlinedButton.icon(
            onPressed: () async {
              // TODO: drop reviews
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (builderContext) => Directionality(
                  textDirection: getDirectionally(local),
                  child: AlertDialog(
                    title: Text(
                      AppLocalizations.of(context)!.reviews,
                      style: TextStyle(
                        fontFamily: getFontFamily(local),
                      ),
                    ),
                    content: FutureBuilder(
                      future: DBProvider.db.getReviewsCount(),
                      builder: (context, snapshot) => Text(
                        '${AppLocalizations.of(context)!.reviewsContent}: '
                        '${snapshot.data.toString()}',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(builderContext),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                    ],
                    buttonPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
              );
            },
            // TODO: constant settingIconSize = 18
            icon: const FaIcon(
              FontAwesomeIcons.eye,
              size: 18.0,
            ),
            label: Text(AppLocalizations.of(context)!.viewReviews),
          ),
          const SizedBox(
            width: 8,
          ),
          OutlinedButton.icon(
            onPressed: () async {
              // TODO: drop reviews
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (builderContext) => Directionality(
                  textDirection: getDirectionally(local),
                  child: AlertDialog(
                    title: Text(
                      AppLocalizations.of(context)!.dropTitle,
                      style: TextStyle(
                        fontFamily: getFontFamily(local),
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(AppLocalizations.of(context)!.dropContent),
                        FutureBuilder(
                          future: DBProvider.db.getReviewsCount(),
                          initialData: 0,
                          builder: (context, snapshot) => Text(
                            snapshot.data.toString(),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(builderContext),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await DBProvider.db.emptyDatabase();
                          await DBProvider.db.getReviewsCount().then(
                            (value) {
                              if (value == 0) {
                                Toast.show(
                                  AppLocalizations.of(context)!.dropSuccess,
                                );
                              }
                              Navigator.pop(builderContext);
                            },
                          );
                          // if (await DBProvider.db.getReviewsCount() == 0) {
                          //   Toast.show(
                          //       AppLocalizations.of(context)!.dropSuccess);
                          // }
                          // Navigator.pop(builderContext);
                        },
                        child: Text(AppLocalizations.of(context)!.dropReviews),
                      ),
                    ],
                    buttonPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
              );
            },
            // TODO: constant settingIconSize = 18
            icon: const FaIcon(
              FontAwesomeIcons.trash,
              size: 18.0,
            ),
            label: Text(AppLocalizations.of(context)!.dropReviews),
          ),
        ],
      ),
    );
  }
}
