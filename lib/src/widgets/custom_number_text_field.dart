part of 'custom_widgets.dart';

class PhoneNumberWidget extends StatelessWidget {
  const PhoneNumberWidget({
    Key? key,
    required this.controller,
    // required this.parentContext,
    this.validator,
    required this.textDirection,
    required this.onSaved,
  }) : super(key: key);
  final TextEditingController controller;

  // final BuildContext parentContext;
  final String? Function(String?)? validator;
  final TextDirection textDirection;
  final Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    var title = Text(
      '${AppLocalizations.of(context)!.phone}:',
      style: Theme.of(context).textTheme.headline5!.copyWith(
            color: Colors.black,
          ),
    );
    String initialCountry = 'AE';
    PhoneNumber number = PhoneNumber(isoCode: initialCountry);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 8.0),
        TextFormField(
          onSaved: onSaved,
          controller: controller,
          keyboardType: TextInputType.none,
          readOnly: true,
          decoration: InputDecoration(
            label: Text(
              '${AppLocalizations.of(context)!.phone} '
              '(${AppLocalizations.of(context)!.optional})',
            ),
            border: const OutlineInputBorder(),
            prefixIcon: const Padding(
              padding: EdgeInsets.all(8.0),
              child: FaIcon(FontAwesomeIcons.mobileScreen),
            ),
          ),
          onTap: () {
            final formKey = GlobalKey<FormState>();

            // BlocProvider.of<SurveyCubit>(parentContext)
            //     .onChangePopUpStatus(true);
            // BlocProvider.of<SurveyCubit>(parentContext)
            //     .changeTimerStatus(BusinessTimer.restart);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return BlocProvider.value(
                  value: BlocProvider.of<SurveyCubit>(context),
                  child: Form(
                    key: formKey,
                    child: AlertDialog(
                      title: title,
                      content: SizedBox(
                        width: 400,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Directionality(
                              textDirection: textDirection,
                              child: InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {},
                                formatInput: true,
                                onSaved: (number) {
                                  if (controller.text.isNotEmpty &&
                                      number.phoneNumber != null) {
                                    controller.text =
                                        int.parse(controller.text).toString();
                                    controller.text =
                                        ' ${number.dialCode!} ${controller.text}';
                                  }
                                },
                                keyboardType: TextInputType.none,
                                initialValue: number,
                                inputDecoration: const InputDecoration(
                                  hintText: '5* *** ****',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child:
                                        FaIcon(FontAwesomeIcons.mobileScreen),
                                  ),
                                ),
                                maxLength: 10,
                                textFieldController: controller,
                                validator: validator,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            _NumbersKeyboard(
                              controller: controller,
                              // parentContext: parentContext,
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            controller.clear();
                          },
                          child: Text(AppLocalizations.of(context)!.clear),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                            }
                            // BlocProvider.of<BusinessCubit>(parentContext)
                            //     .changePopUpStatus(false);
                            Navigator.of(context).pop();
                          },
                          child: Text(AppLocalizations.of(context)!.ok),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _NumberButton extends StatelessWidget {
  const _NumberButton({
    Key? key,
    required this.num,
    required this.onTextInput,
    // required this.parentContext,
  }) : super(key: key);

  final int num;

  // final BuildContext parentContext;
  final ValueSetter<String> onTextInput;

  @override
  Widget build(BuildContext context) {
    AudioPlayer audio = AudioPlayer();
    return GestureDetector(
      onTap: () async {
        // BlocProvider.of<SurveyCubit>(parentContext).changeTimerStatus(
        //   BusinessTimer.restart,
        // );
        if (audio.state == PlayerState.playing) {
          await audio.dispose();
        }
        await audio.play(AssetSource('audios/keyboard.mp3'));
        onTextInput.call(num.toString());
      },
      child: Container(
        width: 64.0,
        height: 64.0,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.0),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Text(
          num.toString(),
          style: Theme.of(context).textTheme.button!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ),
    );
  }
}

class _NumbersKeyboard extends StatelessWidget {
  const _NumbersKeyboard({
    Key? key,
    required this.controller,
    // required this.parentContext,
  }) : super(key: key);

  final TextEditingController controller;

  // final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NumberButton(
              num: 1,
              onTextInput: (text) => insertText(text, controller, 10),
              // parentContext: parentContext,
            ),
            _NumberButton(
              num: 4,
              onTextInput: (text) => insertText(text, controller, 10),
              // parentContext: parentContext,
            ),
            _NumberButton(
              num: 7,
              onTextInput: (text) => insertText(text, controller, 10),
              // parentContext: parentContext,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: IconButton(
                onPressed: () {
                  backspace(controller);
                },
                icon: Icon(
                  Icons.backspace,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32.0,
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NumberButton(
              num: 2,
              onTextInput: (text) => insertText(text, controller, 10),
              // parentContext: parentContext,
            ),
            _NumberButton(
              num: 5,
              onTextInput: (text) => insertText(text, controller, 10),
              // parentContext: parentContext,
            ),
            _NumberButton(
              num: 8,
              onTextInput: (text) => insertText(text, controller, 10),
              // parentContext: parentContext,
            ),
            _NumberButton(
              num: 0,
              onTextInput: (text) => insertText(text, controller, 10),
              // parentContext: parentContext,
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NumberButton(
              num: 3,
              onTextInput: (text) => insertText(text, controller, 10),
              // parentContext: parentContext,
            ),
            _NumberButton(
              num: 6,
              onTextInput: (text) => insertText(text, controller, 10),
              // parentContext: parentContext,
            ),
            _NumberButton(
              num: 9,
              onTextInput: (text) => insertText(text, controller, 10),
              // parentContext: parentContext,
            ),
            // const Spacer(flex: 1),
          ],
        ),
      ],
    );
  }
}
