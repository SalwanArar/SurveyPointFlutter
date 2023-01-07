part of 'custom_widgets.dart';

class PasscodeDialog extends StatefulWidget {
  const PasscodeDialog({Key? key}) : super(key: key);

  @override
  State<PasscodeDialog> createState() => _PasscodeDialogState();
}

class _PasscodeDialogState extends State<PasscodeDialog> {
  late final TextEditingController _passcodeController;

  bool onError = false;
  bool obscureText = true;

  dialogTimer() {
    Future.delayed(
      const Duration(seconds: 60),
      () {
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _passcodeController = TextEditingController();
    dialogTimer();
  }

  @override
  void dispose() {
    _passcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          AppLocalizations.of(context)!.passcodeTitle,
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(
            color: Theme.of(context).colorScheme.primary,
            thickness: 2,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                constraints: const BoxConstraints(
                  maxWidth: 320,
                  minWidth: 320,
                ),
                child: Directionality(
                  textDirection: getDirectionally(
                    context.read<StatusBarCubit>().state.local,
                  ),
                  child: TextField(
                    controller: _passcodeController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefix: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FaIcon(
                          FontAwesomeIcons.lock,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      suffix: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: FaIcon(
                          obscureText
                              ? FontAwesomeIcons.eyeSlash
                              : FontAwesomeIcons.eye,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      label: Text(AppLocalizations.of(context)!.passcode),
                      errorText: onError
                          ? AppLocalizations.of(context)!.passcodeError
                          : null,
                    ),
                    readOnly: true,
                    autofocus: true,
                    obscureText: obscureText,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _PasscodeButton(
                        num: 1,
                        onTextInput: (text) {
                          insertText(text, _passcodeController, 8);
                        },
                      ),
                      _PasscodeButton(
                        num: 4,
                        onTextInput: (text) {
                          insertText(text, _passcodeController, 8);
                        },
                      ),
                      _PasscodeButton(
                        num: 7,
                        onTextInput: (text) {
                          insertText(text, _passcodeController, 8);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: IconButton(
                          onPressed: () {
                            backspace(_passcodeController);
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
                      _PasscodeButton(
                        num: 2,
                        onTextInput: (text) {
                          insertText(text, _passcodeController, 8);
                        },
                      ),
                      _PasscodeButton(
                        num: 5,
                        onTextInput: (text) {
                          insertText(text, _passcodeController, 8);
                        },
                      ),
                      _PasscodeButton(
                        num: 8,
                        onTextInput: (text) {
                          insertText(text, _passcodeController, 8);
                        },
                      ),
                      _PasscodeButton(
                        num: 0,
                        onTextInput: (text) {
                          insertText(text, _passcodeController, 8);
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _PasscodeButton(
                        num: 3,
                        onTextInput: (text) {
                          insertText(text, _passcodeController, 8);
                        },
                      ),
                      _PasscodeButton(
                        num: 6,
                        onTextInput: (text) {
                          insertText(text, _passcodeController, 8);
                        },
                      ),
                      _PasscodeButton(
                        num: 9,
                        onTextInput: (text) {
                          insertText(text, _passcodeController, 8);
                        },
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            _passcodeController.clear();
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
          label: Text(AppLocalizations.of(context)!.back),
        ),
        ElevatedButton.icon(
          onPressed: () {
            if (_passcodeController.text == '0000') {
              Navigator.of(context).pop();
              // TODO: remove print
              print('password is correct');
              BlocProvider.of<DeviceBloc>(context).add(
                const DeviceStatusChangeEvent(
                  DeviceAuthenticatedStatus.settings,
                  null,
                ),
              );
              // if (widget.fromServiceOut) {
              // Navigator.of(context).pop();
              // } else {
              // Authentication
              // Navigator.of(context)
              // .push(SettingsPage.route(widget.fromServiceOut));
              // }
            } else {
              setState(() {
                onError = true;
              });
            }
          },
          icon: const Icon(Icons.arrow_circle_right_outlined),
          label: Text(AppLocalizations.of(context)!.submit),
        ),
      ],
    );
  }
}

class _PasscodeButton extends StatelessWidget {
  const _PasscodeButton({
    Key? key,
    required this.num,
    required this.onTextInput,
  }) : super(key: key);

  final int num;

  final ValueSetter<String> onTextInput;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        onTextInput.call(num.toString());
      },
      child: Container(
        width: 64.0,
        height: 64.0,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.0),
          color: colorScheme.primary,
        ),
        child: Text(
          num.toString(),
          style: GoogleFonts.montserrat(
              fontSize: 28.0, color: colorScheme.onPrimary),
        ),
      ),
    );
  }
}
