part of 'customer_info_layout.dart';

class NameKeyboardDialog extends StatelessWidget {
  const NameKeyboardDialog({
    Key? key,
    required this.local,
    required this.nameController,
    required this.onOk,
  }) : super(key: key);
  final Local local;

  final TextEditingController nameController;
  final Function() onOk;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border.all(
          color: Colors.black12,
          width: 4.0,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(28.0),
        ),
        boxShadow: [
          BoxShadow(
            blurStyle: BlurStyle.normal,
            blurRadius: 2,
            spreadRadius: 5,
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            getNameLocale(local),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 64,
              vertical: 32.0,
            ),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                label: Text(
                    '${getNameLocale(local)} (${getOptionalLocale(local)})'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: FaIcon(FontAwesomeIcons.solidComments),
                ),
              ),
              keyboardType: TextInputType.none,
              autofocus: true,
              maxLength: 255,
              maxLines: 1,
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              height: size.height * 0.25,
              width: size.width * 0.8,
              child: CustomKeyboard(
                onTextInput: (String value) {
                  BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                  int length = 255;
                  insertText(value, nameController, length);
                },
                onBackspace: () {
                  BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                  backspace(nameController);
                },
                onDone: () {
                  BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                  // if (nameController.text.allMatches('\n').length < 5) {
                  //   insertText('\n', nameController, 255);
                  // }
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 32.0,
              left: 48.0,
              right: 48.0,
            ),
            alignment: getReverseAlignment(local),
            child: ElevatedButton(
              onPressed: onOk,
              child: Text(
                getOkLocale(local),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
