part of 'custom_widgets.dart';

/// C u s t o m   K e y b o a r d
///
/// [onTextInput]
/// implement insertText function inside the body with the textEditControllers
/// and focusNodes, "SHOULD HAVE THE SAME LENGTH AND MATCH TO EACH OTHER"
///
/// [onBackspace]
/// implement backspace function inside the body with the textEditControllers
/// and focusNodes, "SHOULD HAVE THE SAME LENGTH AND MATCH TO EACH OTHER"

class CustomKeyboard extends StatefulWidget {
  const CustomKeyboard({
    Key? key,
    required this.onTextInput,
    required this.onBackspace,
    required this.onDone,
    this.systemKeyboard = false,
    // required this.controller,
    // required this.onChange,
  }) : super(key: key);

  final Function(String char) onTextInput;
  final Function() onBackspace;
  final void Function()? onDone;
  final bool systemKeyboard;

  // final TextEditingController controller;
  // final Function(String) onChange;
  // final CKController controller;

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  late bool _isArabic;
  late bool _isChanged;
  late bool _isUpper;
  late String _icon;
  late final BoxShadow _boxShadow;
  late final BoxShadow _boardShadow;
  late Color _boardColor;
  late Color _keyColor;
  late Color _optionColor;
  late Color _charColor;
  late Color _optionKeyColor;
  late Color _optionColorDisabled;
  late Color _optionKeyColorDisabled;
  late int _languageIndex;
  late Local _local;
  String inputValue = '';
  AudioPlayer audio = AudioPlayer();

  // onChange(String value) {
  //   widget.controller.text = value;
  // }

  List<Widget> getKeyboardLanguage(int rowNumber) {
    switch (_local) {
      case Local.en:
      case Local.tl:
        if (rowNumber == 1) return _enFirstRow();
        if (rowNumber == 2) return _enSecondRow();
        return _enThirdRow();
      case Local.ar:
        if (rowNumber == 1) return _arFirstRow();
        if (rowNumber == 2) return _arSecondRow();
        return _arThirdRow();
      case Local.ur:
        if (rowNumber == 1) return _urFirstRow();
        if (rowNumber == 2) return _urSecondRow();
        return _urThirdRow();
    }
  }

  String getDoneText() {
    switch (_local) {
      case Local.en:
        return 'Done';
      case Local.ar:
        return 'تم';
      case Local.ur:
        return 'ہو گیا';
      case Local.tl:
        return 'Tapos na';
    }
  }

  String getSpaceText() {
    switch (_local) {
      case Local.en:
      case Local.tl:
        return 'Space';
      case Local.ar:
        return 'مسافة';
      case Local.ur:
        return 'فاصلے';
    }
  }

  // CKController controller = CKController();

  @override
  void initState() {
    super.initState();
    _isArabic = false;
    _isChanged = false;
    _isUpper = false;
    _icon = '123';
    if (widget.systemKeyboard) {
      _local = Local.en;
    } else {
      _local = context.read<SurveyCubit>().state.local;
    }
    _languageIndex = _local.index;
    _boxShadow = const BoxShadow(
      spreadRadius: -10.0,
      blurRadius: 10.0,
      offset: Offset(1.0, 2.0),
    );
    _boardShadow = const BoxShadow(
      spreadRadius: -10.0,
      blurRadius: 10.0,
      offset: Offset(1.0, -2.0),
    );
    // widget.controller.addListener(() {
    //   setState(() {
    //     inputValue = widget.controller.initialValue;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    _boardColor = const Color(0xFFF6FAFF);
    // _boardColor = const Color(0xFFCABFDC);
    // _boardColor = const Color(0xFFFDDCD7);
    _keyColor = colorScheme.secondaryContainer.withRed(180);
    _charColor = colorScheme.onSecondaryContainer;
    _optionColor = colorScheme.primary;
    _optionKeyColor = colorScheme.onPrimary;
    _optionKeyColorDisabled = colorScheme.onSecondaryContainer;
    _optionColorDisabled = colorScheme.secondaryContainer;
    final double paddingKeyboard = MediaQuery.of(context).size.width * 0.0375;
    return Container(
      constraints: const BoxConstraints.tightForFinite(),
      // decoration: BoxDecoration(
      //   color: _boardColor,
      //   boxShadow: [_boardShadow],
      // ),
      padding: EdgeInsets.symmetric(horizontal: paddingKeyboard),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _firstRow(),
          ),
          Row(
            mainAxisAlignment: _isChanged
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: _secondRow(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _capslockButton(),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _thirdRow(),
                  ),
                ),
              ),
              _backspaceKey(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _changeInput(),
              _languageButton(),
              _spaceButton(),
              _dotChar(),
              _emailChar(),
              _submitButton(),
            ],
          ),
        ],
      ),
    );
  }

  Flexible _textKey({
    required String text,
  }) =>
      Flexible(
        fit: _isChanged ? FlexFit.tight : FlexFit.loose,
        child: Container(
          height: 42,
          constraints: const BoxConstraints(maxWidth: 99.2),
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            shape: BoxShape.rectangle,
            color: _keyColor,
            boxShadow: [
              _boxShadow,
            ],
          ),
          child: InkWell(
            enableFeedback: false,
            onTap: () async {
              widget.onTextInput.call(_isUpper ? text.toUpperCase() : text);
              if (audio.state == PlayerState.playing) {
                await audio.dispose();
              }
              await audio.play(AssetSource('audios/keyboard.mp3'));
              if (_isUpper) {
                setState(() {
                  _isUpper = false;
                });
              }
            },
            // splashColor: Colors.red,
            child: Center(
              child: Text(
                _isUpper ? text.toUpperCase() : text,
                style: TextStyle(
                  fontSize: 21.0,
                  color: _charColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: _isArabic ? 'Vazirmatn' : 'Montserrat',
                ),
              ),
            ),
          ),
        ),
      );

  Flexible _textOptionKey({
    required String text1,
    required String text2,
  }) =>
      Flexible(
        fit: _isChanged ? FlexFit.tight : FlexFit.loose,
        child: InkWell(
          enableFeedback: false,
          onTap: () async {
            if (audio.state == PlayerState.playing) {
              await audio.dispose();
            }
            await audio.play(AssetSource('audios/keyboard.mp3'));

            widget.onTextInput.call(_isUpper ? text2 : text1);
            if (_isUpper) {
              setState(() {
                _isUpper = false;
              });
            }
          },
          child: Container(
            height: 42,
            constraints: const BoxConstraints(maxWidth: 99.2),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              shape: BoxShape.rectangle,
              color: _keyColor,
              boxShadow: [
                _boxShadow,
              ],
            ),
            child: Center(
              child: Text(
                _isUpper ? text2 : text1,
                style: TextStyle(
                  fontSize: 21.0,
                  color: _charColor,
                  fontFamily: _isArabic ? 'Vazirmatn' : 'Montserrat',
                ),
              ),
            ),
          ),
        ),
      );

  Widget _capslockButton() {
    Widget child = _isChanged
        ? Text(
            _isUpper ? '123' : '#+=',
            style: const TextStyle(
              fontSize: 21.0,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.0,
            ),
          )
        : Icon(
            Icons.keyboard_capslock,
            size: 32.0,
            color: _isUpper ? _boardColor : _optionKeyColor,
          );
    return Material(
      child: InkWell(
        enableFeedback: false,
        onTap: () async {
          if (audio.state == PlayerState.playing) {
            await audio.dispose();
          }
          await audio.play(AssetSource('audios/keyboard.mp3'));
          setState(() {
            _isUpper = !_isUpper;
          });
        },
        child: Container(
          height: 44.0,
          width: 128.0,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            shape: BoxShape.rectangle,
            color: _isUpper && !_isChanged ? _keyColor : _optionColor,
            boxShadow: [
              _boxShadow,
            ],
          ),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _changeInput() {
    _isChanged
        ? _isArabic
            ? _icon = 'ا ب ج'
            : _icon = 'ABC'
        : _icon = '123';
    return InkWell(
      enableFeedback: false,
      onTap: () async {
        if (audio.state == PlayerState.playing) {
          await audio.dispose();
        }
        await audio.play(AssetSource('audios/keyboard.mp3'));
        setState(() {
          _isChanged = !_isChanged;
          _isUpper = false;
        });
      },
      child: Container(
        height: 44.0,
        width: 128.0,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          shape: BoxShape.rectangle,
          color: _optionColor,
          boxShadow: [
            _boxShadow,
          ],
        ),
        child: Center(
          child: Text(
            _icon,
            style: TextStyle(
              fontSize: 21.0,
              fontWeight: FontWeight.w400,
              letterSpacing: _isArabic && _isChanged ? -3.0 : 0.0,
              color: _optionKeyColor,
              fontFamily: _isArabic && _isChanged ? 'Vazirmatn' : 'Montserrat',
            ),
          ),
        ),
      ),
    );
  }

  Widget _backspaceKey() => InkWell(
        enableFeedback: false,
        onTap: () async {
          if (audio.state == PlayerState.playing) {
            await audio.dispose();
          }
          await audio.play(AssetSource('audios/keyboard.mp3'));
          widget.onBackspace();
        },
        child: Container(
          height: 44.0,
          width: 128.0,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            shape: BoxShape.rectangle,
            color: _optionColor,
            boxShadow: [
              _boxShadow,
            ],
          ),
          child: Center(
            child: Icon(
              Icons.backspace_outlined,
              size: 32.0,
              color: _optionKeyColor,
            ),
          ),
        ),
      );

  Widget _languageButton() {
    return InkWell(
      enableFeedback: false,
      onTap: () async {
        if (audio.state == PlayerState.playing) {
          await audio.dispose();
        }
        await audio.play(AssetSource('audios/keyboard.mp3'));

        if (!widget.systemKeyboard) {
          setState(() {
            _languageIndex++;
            _languageIndex %= 3;
            _local = Local.values[_languageIndex];
            switch (_local) {
              case Local.en:
              case Local.tl:
                _isArabic = false;
                break;
              case Local.ar:
              case Local.ur:
                _isArabic = true;
                break;
            }
            // _isArabic = !_isArabic;
            _isChanged = false;
            _isUpper = false;
          });
        }
      },
      child: Container(
        height: 44.0,
        width: 128.0,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          shape: BoxShape.rectangle,
          color: _optionColor,
          boxShadow: [
            _boxShadow,
          ],
        ),
        child: Center(
          child: Icon(
            Icons.language,
            size: 32.0,
            color: _optionKeyColor,
          ),
        ),
      ),
    );
  }

  Widget _spaceButton() => Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: InkWell(
          enableFeedback: false,
          onTap: () async {
            if (audio.state == PlayerState.playing) {
              await audio.dispose();
            }
            await audio.play(AssetSource('audios/keyboard.mp3'));
            widget.onTextInput.call(' ');
          },
          child: Container(
            height: 42.0,
            margin: const EdgeInsets.symmetric(horizontal: 2.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              shape: BoxShape.rectangle,
              color: _keyColor,
              boxShadow: [
                _boxShadow,
              ],
            ),
            child: Center(
              child: Text(
                getSpaceText(),
                style: TextStyle(
                  fontSize: 21.0,
                  letterSpacing: 1.3,
                  color: _charColor,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _dotChar() => InkWell(
        enableFeedback: false,
        onTap: () async {
          if (audio.state == PlayerState.playing) {
            await audio.dispose();
          }
          await audio.play(AssetSource('audios/keyboard.mp3'));
          widget.onTextInput.call('.');
        },
        child: Container(
          height: 42.0,
          width: 96.0,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            shape: BoxShape.rectangle,
            color: _keyColor,
            boxShadow: [
              _boxShadow,
            ],
          ),
          child: Center(
            child: Text(
              '.',
              style: TextStyle(fontSize: 21.0, color: _charColor),
            ),
          ),
        ),
      );

  Widget _emailChar() => InkWell(
        enableFeedback: false,
        onTap: () async {
          if (audio.state == PlayerState.playing) {
            await audio.dispose();
          }
          await audio.play(AssetSource('audios/keyboard.mp3'));
          widget.onTextInput.call('@');
        },
        child: Container(
          height: 42.0,
          width: 96.0,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            shape: BoxShape.rectangle,
            color: _keyColor,
            boxShadow: [
              _boxShadow,
            ],
          ),
          child: Center(
            child: Icon(
              Icons.alternate_email,
              size: 24.0,
              color: _charColor,
            ),
          ),
        ),
      );

  // Future<bool> simulateKeyDownEvent(
  //     LogicalKeyboardKey key, {
  //       String? platform,
  //       PhysicalKeyboardKey? physicalKey,
  //       String? character,
  //     }) {
  //   return KeyEventSimulator.simulateKeyDownEvent(key, platform: platform, physicalKey: physicalKey, character: character);
  // }

  Widget _submitButton() => InkWell(
        enableFeedback: false,
        onTap: () async {
          if (widget.onDone != null) widget.onDone!();

          if (audio.state == PlayerState.playing) {
            await audio.dispose();
          }
          await audio.play(AssetSource('audios/keyboard.mp3'));
        },
        child: Container(
          height: 48,
          width: 128.0,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            shape: BoxShape.rectangle,
            color: widget.onDone != null ? _optionColor : _optionColorDisabled,
            boxShadow: [
              _boxShadow,
            ],
          ),
          child: Center(
            child: Baseline(
              baselineType: TextBaseline.ideographic,
              baseline: 20,
              child: Text(
                '↵',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  // textBaseline: TextBaseline.alphabetic,
                  height: -1,
                  color: widget.onDone != null
                      ? _optionKeyColor
                      : _optionKeyColorDisabled,
                  fontFamily: getFontFamily(Local.en),
                ),
              ),
            ),
            // child: FaIcon(
            //   FontAwesomeIcons.turnDown,
            //   color: widget.onDone != null
            //       ? _optionKeyColor
            //       : _optionKeyColorDisabled,
            // ),
          ),
        ),
      );

  List<Widget> _firstRow() => _isChanged
      ? _isUpper
          ? [
              _textKey(text: '['),
              _textKey(text: ']'),
              _textKey(text: '{'),
              _textKey(text: '}'),
              _textKey(text: '#'),
              _textKey(text: '%'),
              _textKey(text: '^'),
              _textKey(text: '*'),
              _textKey(text: '+'),
              _textKey(text: '='),
            ]
          : [
              _textKey(text: '1'),
              _textKey(text: '2'),
              _textKey(text: '3'),
              _textKey(text: '4'),
              _textKey(text: '5'),
              _textKey(text: '6'),
              _textKey(text: '7'),
              _textKey(text: '8'),
              _textKey(text: '9'),
              _textKey(text: '0'),
            ]
      : getKeyboardLanguage(1);

  // : _isArabic
  //     ? _arFirstRow()
  //     : _urFirstRow();

  List<Widget> _secondRow() => _isChanged
      ? _isUpper
          ? [
              _textKey(text: '_'),
              _textKey(text: '\\'),
              _textKey(text: '|'),
              _textKey(text: '~'),
              _textKey(text: '<'),
              _textKey(text: '>'),
              _textKey(text: '€'),
              _textKey(text: '£'),
              _textKey(text: '¥'),
              _textKey(text: '•'),
            ]
          : [
              _textKey(text: '-'),
              _textKey(text: '/'),
              _textKey(text: ':'),
              _textKey(text: ';'),
              _textKey(text: '('),
              _textKey(text: ')'),
              _textKey(text: '\$'),
              _textKey(text: '&'),
              _textKey(text: '@'),
              _textKey(text: '"'),
            ]
      : getKeyboardLanguage(2);

  // : _isArabic
  //     ? _arSecondRow()
  //     : _urSecondRow();

  List<Widget> _thirdRow() => _isChanged
      ? [
          _textKey(text: '.'),
          _textKey(text: ','),
          _textKey(text: '?'),
          _textKey(text: '!'),
          _textKey(text: '\''),
        ]
      : getKeyboardLanguage(3);

  // : _isArabic
  //     ? _arThirdRow()
  //     : _urThirdRow();

  List<Widget> _arFirstRow() => [
        _textKey(text: 'ض'),
        _textKey(text: 'ص'),
        _textKey(text: 'ث'),
        _textKey(text: 'ق'),
        _textOptionKey(text1: 'غ', text2: 'إ'),
        _textKey(text: 'ع'),
        _textKey(text: 'ه'),
        _textKey(text: 'خ'),
        _textKey(text: 'ح'),
        _textKey(text: 'ج'),
      ];

  List<Widget> _arSecondRow() => [
        _textKey(text: 'ش'),
        _textKey(text: 'س'),
        _textKey(text: 'ي'),
        _textKey(text: 'ب'),
        _textKey(text: 'ل'),
        _textOptionKey(text1: 'ا', text2: 'أ'),
        _textKey(text: 'ت'),
        _textKey(text: 'ن'),
        _textKey(text: 'م'),
        _textKey(text: 'ك'),
        _textKey(text: 'ة'),
      ];

  List<Widget> _arThirdRow() => [
        _textKey(text: 'ء'),
        _textKey(text: 'ظ'),
        _textKey(text: 'ط'),
        _textKey(text: 'ذ'),
        _textKey(text: 'د'),
        _textKey(text: 'ز'),
        _textKey(text: 'ر'),
        _textOptionKey(text1: 'و', text2: 'ؤ'),
        _textOptionKey(text1: 'ى', text2: 'ئ'),
      ];

  List<Widget> _enFirstRow() => [
        _textKey(text: 'q'),
        _textKey(text: 'w'),
        _textKey(text: 'e'),
        _textKey(text: 'r'),
        _textKey(text: 't'),
        _textKey(text: 'y'),
        _textKey(text: 'u'),
        _textKey(text: 'i'),
        _textKey(text: 'o'),
        _textKey(text: 'p'),
      ];

  List<Widget> _enSecondRow() => [
        _textKey(text: 'a'),
        _textKey(text: 's'),
        _textKey(text: 'd'),
        _textKey(text: 'f'),
        _textKey(text: 'g'),
        _textKey(text: 'h'),
        _textKey(text: 'j'),
        _textKey(text: 'k'),
        _textKey(text: 'l'),
      ];

  List<Widget> _enThirdRow() => [
        _textKey(text: 'z'),
        _textKey(text: 'x'),
        _textKey(text: 'c'),
        _textKey(text: 'v'),
        _textKey(text: 'b'),
        _textKey(text: 'n'),
        _textKey(text: 'm'),
      ];

  List<Widget> _urFirstRow() => [
        _textKey(text: 'ح'),
        _textKey(text: 'ج'),
        _textKey(text: 'ب'),
        _textKey(text: 'ت'),
        _textKey(text: 'پ'),
        _textKey(text: 'ٹ'),
        _textKey(text: 'د'),
        _textKey(text: 'ھ'),
        _textKey(text: 'ص'),
        _textKey(text: 'ط'),
      ];

  List<Widget> _urSecondRow() => [
        _textKey(text: 'ی'),
        _textKey(text: 'ک'),
        _textKey(text: 'ا'),
        _textKey(text: 'ہ'),
        _textKey(text: 'ل'),
        _textKey(text: 'ن'),
        _textKey(text: 'ر'),
        _textKey(text: 'و'),
        _textKey(text: 'م'),
      ];

  List<Widget> _urThirdRow() => [
        _textKey(text: 'ع'),
        _textKey(text: 'غ'),
        _textKey(text: 'ش'),
        _textKey(text: 'س'),
        _textKey(text: 'ے'),
        _textKey(text: 'ف'),
        _textKey(text: 'ق'),
      ];
}
