part of 'customer_info_layout.dart';

class PhoneKeyboardDialog extends StatelessWidget {
  const PhoneKeyboardDialog({
    Key? key,
    required this.local,
    required this.numberController,
    required this.onBack,
    required this.onSubmit,
  }) : super(key: key);

  final Local local;
  final TextEditingController numberController;
  final Function() onBack;
  final Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    PhoneNumber number = PhoneNumber(isoCode: 'AE');
    // TODO: audio
    AudioPlayer audio = AudioPlayer();
    final formKey = GlobalKey<FormState>();
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      width: size.width * 0.35,
      decoration: BoxDecoration(
        color: colorScheme.background,
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
            color: colorScheme.surfaceVariant,
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              getContactNumberLocale(local),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 32.0,
              ),
              child: CustomDivider(),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox(
                // TODO: add to const values
                width: size.width * 0.3,
                child: InternationalPhoneNumberInput(
                  autoFocus: true,
                  textFieldController: numberController,
                  onInputChanged: (PhoneNumber value) {},
                  maxLength: 14,
                  locale: Local.ar.name,
                  keyboardType: TextInputType.none,
                  initialValue: number,
                  onSaved: (number) {
                    if (numberController.text.isNotEmpty &&
                        number.phoneNumber != null) {
                      numberController.text =
                          int.parse(numberController.text).toString();
                      numberController.text =
                          '${number.dialCode!} ${numberController.text}';
                    }
                  },
                  inputDecoration: const InputDecoration(
                    hintText: '5* *** ****',
                    border: OutlineInputBorder(),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FaIcon(FontAwesomeIcons.addressCard),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Directionality(
              textDirection: getDirectionally(Local.en),
              child: NumberKeyboard(
                controller: numberController,
                onTextInput: (text) async {
                  BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                  insertText(text, numberController, 10);
                  if (audio.state == PlayerState.playing) {
                    await audio.dispose();
                  }
                  await audio.play(AssetSource('audios/keyboard.mp3'));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                textDirection: getReverseDirectionally(local),
                children: [
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState!.save();
                      onSubmit.call();
                    },
                    child: Text(getOkLocale(local)),
                  ),
                  SizedBox(width: size.width * 0.01,),
                  TextButton(
                    onPressed: onBack,
                    child: Text(getClearLocale(local)),
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

class NumberKeyboard extends StatelessWidget {
  const NumberKeyboard({
    Key? key,
    required this.controller,
    required this.onTextInput,
  }) : super(key: key);

  final TextEditingController controller;
  final Function(String) onTextInput;

  @override
  Widget build(BuildContext context) {
    double numberButtonSize = MediaQuery.of(context).size.aspectRatio * 48;
    // TODO: audio
    AudioPlayer audio = AudioPlayer();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: numberButtonSize,
              width: numberButtonSize,
              child: NumberButton(
                number: 1,
                onTextInput: onTextInput,
              ),
            ),
            SizedBox(
              height: numberButtonSize,
              width: numberButtonSize,
              child: NumberButton(
                number: 2,
                onTextInput: onTextInput,
              ),
            ),
            SizedBox(
              height: numberButtonSize,
              width: numberButtonSize,
              child: NumberButton(
                number: 3,
                onTextInput: onTextInput,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: numberButtonSize,
              width: numberButtonSize,
              child: NumberButton(
                number: 4,
                onTextInput: onTextInput,
              ),
            ),
            SizedBox(
              height: numberButtonSize,
              width: numberButtonSize,
              child: NumberButton(
                number: 5,
                onTextInput: onTextInput,
              ),
            ),
            SizedBox(
              height: numberButtonSize,
              width: numberButtonSize,
              child: NumberButton(
                number: 6,
                onTextInput: onTextInput,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: numberButtonSize,
              width: numberButtonSize,
              child: NumberButton(
                number: 7,
                onTextInput: onTextInput,
              ),
            ),
            SizedBox(
              height: numberButtonSize,
              width: numberButtonSize,
              child: NumberButton(
                number: 8,
                onTextInput: onTextInput,
              ),
            ),
            SizedBox(
              height: numberButtonSize,
              width: numberButtonSize,
              child: NumberButton(
                number: 9,
                onTextInput: onTextInput,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: numberButtonSize,
              width: numberButtonSize,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () async {
                  BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                  backspace(controller);
                  if (audio.state == PlayerState.playing) {
                    await audio.dispose();
                  }
                  await audio.play(AssetSource('audios/keyboard.mp3'));
                },
                child: FaIcon(
                  FontAwesomeIcons.deleteLeft,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28.0,
                ),
              ),
            ),
            SizedBox(
              height: numberButtonSize,
              width: numberButtonSize,
              child: NumberButton(
                number: 0,
                onTextInput: onTextInput,
              ),
            ),
            SizedBox(
              height: numberButtonSize,
              width: numberButtonSize,
            ),
          ],
        ),
      ],
    );
  }
}

class NumberButton extends StatelessWidget {
  const NumberButton({
    Key? key,
    required this.number,
    required this.onTextInput,
  }) : super(key: key);

  final int number;
  final ValueSetter<String> onTextInput;

  @override
  Widget build(BuildContext context) {
    // TODO: const numberButtonMargin
    const double numberButtonMargin = 4.0;
    return GestureDetector(
      onTap: () {
        onTextInput.call(number.toString());
      },
      child: Container(
        margin: const EdgeInsets.all(numberButtonMargin),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.0),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Text(
          number.toString(),
          style: GoogleFonts.montserrat(
            fontSize: Theme.of(context).textTheme.button!.fontSize,
            color: Theme.of(context).colorScheme.onPrimary,
            textBaseline: TextBaseline.alphabetic,
          ),
          locale: const Locale('en'),
        ),
      ),
    );
  }
}
