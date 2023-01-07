part of 'customer_info_layouts.dart';

class CustomerInfoContactLayout extends StatelessWidget {
  const CustomerInfoContactLayout({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final Local local = context.select(
      (SurveyCubit cubit) => cubit.state.local,
    );
    final AudioPlayer audio = AudioPlayer();
    PhoneNumber number = PhoneNumber(isoCode: 'AE', dialCode: '+971');
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          child: CustomQuestionWidget(
            questionDetails: getContactNumberLabelLocale(local),
          ),
        ),
        Flexible(
          flex: 2,
          child: Center(
            // alignment: getAlignment(local),
            // padding: const EdgeInsets.symmetric(horizontal: 128.0),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: InternationalPhoneNumberInput(
                  autoFocus: true,
                  textFieldController: controller,
                  selectorTextStyle:
                      GoogleFonts.montserrat(fontWeight: FontWeight.w500),
                  onInputChanged: (PhoneNumber value) {
                    number = value;
                  },
                  maxLength: 10,
                  locale: Local.en.name,
                  keyboardType: TextInputType.none,
                  initialValue: number,
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
          ),
        ),
        Flexible(
          flex: 9,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: NumberKeyboard(
              onTextInput: (value) async {
                BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                if (controller.text.isEmpty && value.toString() == '0') {
                  Toast.show(
                    getContactZeroErrorLocale(local),
                    duration: 3,
                    border: Border.all(
                      color: colorScheme.error,
                    ),
                    backgroundColor: colorScheme.errorContainer,
                    textStyle: TextStyle(
                      color: colorScheme.onErrorContainer,
                      fontFamily: getFontFamily(local),
                    ),
                    rootNavigator: true,
                    gravity: Toast.top,
                  );
                } else if (controller.text.length == 10) {
                  Toast.show(
                    getContactExceededErrorLocale(local),
                    duration: 3,
                    border: Border.all(
                      color: colorScheme.error,
                    ),
                    backgroundColor: colorScheme.errorContainer,
                    textStyle: TextStyle(
                      color: colorScheme.onErrorContainer,
                      fontFamily: getFontFamily(local),
                    ),
                    rootNavigator: true,
                    gravity: Toast.top,
                  );
                } else {
                  insertText(value, controller, 10);
                  if (controller.text.length > 8 && controller.text.length < 11) {
                    context.read<SurveyCubit>().onAddingInfo(
                          '${number.dialCode!} ${controller.text}',
                          CustomerInfoType.contact,
                        );
                  }
                }
                if (audio.state == PlayerState.playing) {
                  await audio.dispose();
                }
                await audio.play(AssetSource('audios/keyboard.mp3'));
              },
              controller: controller,
            ),
          ),
        ),
      ],
    );
  }

  bool numberValidate(TextEditingController controller) {
    int length = controller.text.length;
    if (length < 10 && length > 8) {}
    return false;
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
                  if (controller.text.length < 9) {
                    context.read<SurveyCubit>().onAddingInfo(
                          '',
                          CustomerInfoType.contact,
                        );
                  }
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
            fontSize: 28,
            color: Theme.of(context).colorScheme.onPrimary,
            textBaseline: TextBaseline.alphabetic,
          ),
          locale: const Locale('en'),
        ),
      ),
    );
  }
}
