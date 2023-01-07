import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../../constants/const_values.dart';
import '../../../../blocs/survey_cubit/survey_cubit.dart';
import '../../../../../constants/enums.dart';
import '../../../../../widgets/custom_widgets.dart';
import '../../../../../utils/services/business_locale.dart';
import '../../../../../utils/services/functions.dart';

part 'phone_keyboard_dialog.dart';

part 'comment_keyboard_dialog.dart';

part 'name_keyboard_dialog.dart';

class CustomerInfoLayout extends StatefulWidget {
  const CustomerInfoLayout({
    Key? key,
  }) : super(key: key);

  static Route<void> route() => MaterialPageRoute(
        builder: (_) => const CustomerInfoLayout(),
      );

  @override
  State<CustomerInfoLayout> createState() => _CustomerInfoLayoutState();
}

class _CustomerInfoLayoutState extends State<CustomerInfoLayout> {
  final TextEditingController numberController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final customerInfo = _CustomerInfo();

  final _formKey = GlobalKey<FormState>();

  Timer? countDownTimer;
  bool animatedPointer = false;

  late Duration duration;

  void startTimer() {
    duration = const Duration(seconds: timerDuration);
    setState(() {
      animatedPointer = false;
    });
    countDownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setCountDown(),
    );
  }

  // TODO: convert Survey Page to stateless widget
  void stopTimer() => countDownTimer!.cancel();

  void setCountDown() {
    const reduceSecondsBy = 1;
    final seconds = duration.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      countDownTimer!.cancel();
      BlocProvider.of<SurveyCubit>(context).onTimerVisible(const TimerDialog());
    } else {
      duration = Duration(seconds: seconds);
      if (timerDuration - seconds == 6) {
        setState(() {
          animatedPointer = true;
        });
      }
      //TODO: remove print
      if (kDebugMode) {
        print('Seconds:\t$seconds');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();

  }

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    commentController.dispose();
    if (countDownTimer != null) countDownTimer!.cancel();
    super.dispose();
  }

  bool showNumbers = false;
  bool showComment = false;

  // bool showNumbers = false;

  // TODO: add audio skeleton
  AudioPlayer audio = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    final local = context.select<SurveyCubit, Local>(
      (cubit) => cubit.state.local,
    );
    final bool contactMandatory = context.select(
      (SurveyCubit cubit) => cubit.state.business.survey.contact,
    );
    final bool commentMandatory = context.select(
      (SurveyCubit cubit) => cubit.state.business.survey.comment,
    );
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    bool buttonActive = !(contactMandatory && numberController.text.isEmpty) &&
        !(commentMandatory && commentController.text.isEmpty);
    bool pointerVisibility = context.select(
          (SurveyCubit cubit) =>
              !cubit.state.timerVisibility && !cubit.state.dialogVisibility,
        ) &&
        buttonActive;
    //!context.watch<SurveyCubit>().state.dialogVisibility &&
    //                       !context.watch<SurveyCubit>().state.timerVisibility
    return Directionality(
      textDirection: getDirectionally(local),
      child: BlocListener<SurveyCubit, SurveyState>(
        listenWhen: (previous, current) =>
            previous.refreshValue != current.refreshValue,
        listener: (context, state) {
          if (countDownTimer != null) stopTimer();
          startTimer();
        },
        child: Form(
          key: _formKey,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Flexible(
                    flex: 6,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.1,
                        vertical: size.height * 0.05,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getCustomerInfoTitleLocale(local),
                            // TODO: add to style
                            style: TextStyle(
                              fontSize: 42.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: getFontFamily(local),
                            ),
                          ),
                          // TODO: add to const values
                          const SizedBox(height: 32.0),
                          SizedBox(
                            width: size.width * 0.25,
                            child: TextFormField(
                              readOnly: true,
                              controller: nameController,
                              decoration: InputDecoration(
                                label: Text('${getNameLocale(local)} '
                                    '${commentMandatory ? '' : '(${getOptionalLocale(local)})'}'),
                                border: const OutlineInputBorder(),
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: FaIcon(FontAwesomeIcons.circleUser),
                                ),
                              ),
                              validator: (val) {
                                if (!commentMandatory) return null;
                                if (val == null || val.isEmpty) {
                                  return getFieldErrorLocale(local);
                                }
                                return null;
                              },
                              onSaved: (val) {
                                customerInfo.name = val;
                              },
                              onTap: () {
                                BlocProvider.of<SurveyCubit>(context)
                                    .onTimerRefresh();
                                BlocProvider.of<SurveyCubit>(context)
                                    .onDialogVisible(
                                  NameKeyboardDialog(
                                    local: local,
                                    nameController: nameController,
                                    onOk: () {
                                      BlocProvider.of<SurveyCubit>(context)
                                          .onTimerRefresh();
                                      BlocProvider.of<SurveyCubit>(context)
                                          .onDialogDismiss(
                                        const TimerDialog(),
                                      );
                                      nameController.text.trim();
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          // TODO: add to const values
                          const SizedBox(height: 28.0),
                          SizedBox(
                            width: size.width * 0.25,
                            child: TextFormField(
                              readOnly: true,
                              controller: numberController,
                              textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                label: Text(
                                  '${getContactNumberLocale(local)} '
                                  '${contactMandatory ? '' : '(${getOptionalLocale(local)})'}',
                                ),
                                border: const OutlineInputBorder(),
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: FaIcon(FontAwesomeIcons.addressCard),
                                ),
                              ),
                              onSaved: (val) {
                                customerInfo.contactNumber = val;
                              },
                              validator: (val) {
                                if (!contactMandatory) return null;
                                if (val == null || val.isEmpty) {
                                  return getFieldErrorLocale(local);
                                }
                                return null;
                              },
                              onTap: () {
                                if (numberController.text.isNotEmpty) {
                                  numberController.clear();
                                }
                                BlocProvider.of<SurveyCubit>(context)
                                    .onTimerRefresh();
                                BlocProvider.of<SurveyCubit>(context)
                                    .onDialogVisible(
                                  PhoneKeyboardDialog(
                                    local: local,
                                    numberController: numberController,
                                    onBack: () {
                                      numberController.clear();
                                    },
                                    onSubmit: () {
                                      BlocProvider.of<SurveyCubit>(context)
                                          .onTimerRefresh();
                                      BlocProvider.of<SurveyCubit>(context)
                                          .onDialogDismiss(
                                        const TimerDialog(),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 28.0),
                          TextFormField(
                            // TODO: add to const value
                            maxLines: 5,
                            readOnly: true,
                            controller: commentController,
                            decoration: InputDecoration(
                              label: Text(
                                '${getCommentLabelLocale(local)} '
                                '${commentMandatory ? '' : '(${getOptionalLocale(local)})'}',
                              ),
                              border: const OutlineInputBorder(),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: FaIcon(FontAwesomeIcons.comments),
                              ),
                            ),
                            validator: (val) {
                              if (!commentMandatory) return null;
                              if (val == null || val.isEmpty) {
                                return getFieldErrorLocale(local);
                              }
                              return null;
                            },
                            onSaved: (val) {
                              customerInfo.comment = val;
                            },
                            onTap: () {
                              BlocProvider.of<SurveyCubit>(context)
                                  .onDialogVisible(
                                CommentKeyboardDialog(
                                  local: local,
                                  commentController: commentController,
                                  onOk: () {
                                    BlocProvider.of<SurveyCubit>(context)
                                        .onTimerRefresh();
                                    BlocProvider.of<SurveyCubit>(context)
                                        .onDialogDismiss(
                                      const TimerDialog(),
                                    );
                                    commentController.text.trim();
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Row(
                      children: [
                        const Spacer(flex: 1),
                        Flexible(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            alignment: Alignment.bottomCenter,
                            child: const CustomProgressIndicator(),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: InkWell(
                              enableFeedback: false,
                              borderRadius: BorderRadius.circular(24.0),
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  // BlocProvider.of<SurveyCubit>(context)
                                  //     .onSubmitReview(
                                  //   comment: customerInfo.comment,
                                  //   contactNumber: customerInfo.contactNumber,
                                  //   name: customerInfo.name,
                                  // );
                                  if (audio.state == PlayerState.playing) {
                                    await audio.dispose();
                                  }
                                  await audio.play(
                                    AssetSource('audios/click1.mp3'),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 10.0,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: buttonActive
                                        ? colorScheme.primary
                                        : colorScheme.secondary,
                                    width: buttonActive ? 3 : 0,
                                  ),
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: Text(
                                  getFinishButtonLocale(local),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32.0,
                                    fontFamily: getFontFamily(local),
                                    color: buttonActive
                                        ? colorScheme.primary
                                        : colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: size.height * pointerPositionBottomRatio,
                left: getPointerPositionLeft(
                  local,
                  size.width * pointerPositionSideRatio,
                ),
                right: getPointerPositionRight(
                  local,
                  size.width * pointerPositionSideRatio,
                ),
                child: Visibility(
                  visible: animatedPointer && pointerVisibility,
                  child: const AnimatedPointer(),
                ),
              ),
              Visibility(
                visible: context.watch<SurveyCubit>().state.timerVisibility,
                child: const CustomAlertBackground(),
              ),
              Visibility(
                visible: context.watch<SurveyCubit>().state.timerVisibility,
                child: context.watch<SurveyCubit>().state.dialog,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerInfo {
  _CustomerInfo();

  String? comment;
  String? contactNumber;
  String? name;
}

// class PhoneNumberField extends StatelessWidget {
//   const PhoneNumberField({
//     Key? key,
//     required this.controller,
//     required this.local,
//     required this.onTap,
//     required this.onSave,
//   }) : super(key: key);
//
//   final TextEditingController controller;
//   final Local local;
//   final Function() onTap;
//   final Function(String?) onSave;
//
//   @override
//   Widget build(BuildContext context) {
//     String label = getLabelLocale(local);
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: Theme.of(context)
//               .textTheme
//               .headline5!
//               .copyWith(color: Colors.black),
//         ),
//         const SizedBox(height: 16.0),
//         TextFormField(
//           readOnly: true,
//           controller: controller,
//           keyboardType: TextInputType.none,
//           decoration: InputDecoration(
//             label: Text('$label (${getOptionalLocale(local)})'),
//             border: const OutlineInputBorder(),
//           ),
//           onSaved: onSave,
//           onTap: onTap,
//         ),
//       ],
//     );
//   }
// }
