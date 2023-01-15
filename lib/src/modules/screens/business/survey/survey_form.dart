import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_point_05/src/modules/models/device_info.dart';
import 'package:toast/toast.dart';

import 'customer_info_v01/customer_info_layouts.dart';
import 'questions/questions_layout.dart';
import '../../../blocs/survey_cubit/survey_cubit.dart';
import '../../../../constants/enums.dart';
import '../../../../constants/const_values.dart';
import '../../../../widgets/custom_widgets.dart';
import '../../../../utils/services/functions.dart';
import '../../../../utils/services/business_locale.dart';

class SurveyForm extends StatefulWidget {
  const SurveyForm({Key? key}) : super(key: key);

  static Route<void> route() => MaterialPageRoute(
        builder: (_) => const SurveyForm(),
      );

  @override
  State<SurveyForm> createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  Timer? countDownTimer;
  bool animatedPointer = false;

  late Duration duration;

  late TextEditingController controller;

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
      if (timerDuration - seconds == 5) {
        setState(() {
          animatedPointer = true;
        });
      }
      //TODO: remove print
      // if (kDebugMode) {
      //   print('Seconds:\t$seconds');
      // }
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    if (countDownTimer != null) countDownTimer!.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Local local = context.select((SurveyCubit cubit) => cubit.state.local);
    final Size size = MediaQuery.of(context).size;
    // bool pointerVisibility = context.select((SurveyCubit cubit) {
    //   var state = cubit.state;
    //   var surveyIndex = state.questionIndex;
    //   var questionsLength = state.business.questions.length;
    //   return !state.dialogVisibility &&
    //       !state.timerVisibility &&
    //       (state.answersId.isNotEmpty ||
    //           state.questionsId.isNotEmpty ||
    //           surveyIndex >= questionsLength);
    // });

    bool pointerVisibility = context.select((SurveyCubit cubit) {
      SurveyState state = cubit.state;
      int questionsLength = state.business.questions.length;
      int customerIndex = state.surveyIndex - questionsLength;
      var customerInfo = state.business.survey.customerInfo;
      bool customerType = customerIndex < 0
          ? false
          :
          // customerInfo.getInfoOptional(customerIndex) ||
          state.customerJson[customerInfo.getInfoTypes[customerIndex].name]!
              .isNotEmpty;
      return !state.dialogVisibility &&
          !state.timerVisibility &&
          (state.answersId.isNotEmpty ||
              state.questionsId.isNotEmpty ||
              customerType);
    });
    return MultiBlocListener(
      listeners: [
        BlocListener<SurveyCubit, SurveyState>(
          listenWhen: (previous, current) =>
              previous.refreshValue != current.refreshValue,
          listener: (context, state) {
            if (countDownTimer != null) stopTimer();
            startTimer();
          },
        ),
        BlocListener<SurveyCubit, SurveyState>(
          listenWhen: (previous, current) =>
              previous.surveyIndex != current.surveyIndex,
          listener: (context, state) {
            controller.clear();
          },
        ),
        // BlocListener<SurveyCubit, SurveyState>(
        //   listenWhen: (previous, current) =>
        //       (current.questionsId.isEmpty && current.answersId.isEmpty) ||
        //       previous.answersId != current.answersId ||
        //       previous.questionsId != current.questionsId,
        //   listener: (context, state) {
        //     animatedPointer = false;
        //   },
        // ),
      ],
      child: Directionality(
        textDirection: getDirectionally(local),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Flexible(
                  flex: 6,
                  child: BlocBuilder<SurveyCubit, SurveyState>(
                    builder: (context, state) {
                      var questions = state.business.questions;
                      int surveyIndex = state.surveyIndex;
                      Local local = state.local;
                      if (surveyIndex < questions.length) {
                        // TODO: implement questions
                        var currentQuestion =
                            state.business.questions[surveyIndex];
                        var currentAnswers = currentQuestion.answers;
                        var languages = currentQuestion.question.language;
                        switch (currentQuestion.question.questionType) {
                          case QuestionType.yesOrNo:
                            return QuestionYesNoLayout(
                              questionDetails: getQuestionDetails(
                                languages,
                                local,
                              ),
                            );
                          case QuestionType.rating:
                            return QuestionRatingLayout(
                              questionDetails: getQuestionDetails(
                                languages,
                                local,
                              ),
                            );
                          case QuestionType.satisfaction:
                            return Container(
                              alignment: Alignment.center,
                              child: QuestionSatisfactionLayout(
                                questionDetails: getQuestionDetails(
                                  languages,
                                  local,
                                ),
                              ),
                            );
                          case QuestionType.mcq:
                            return QuestionMcqLayout(
                              questionDetails: getQuestionDetails(
                                languages,
                                local,
                              ),
                              answersDetails: getAnswersDetails(
                                currentAnswers,
                                local,
                              ),
                            );
                          case QuestionType.checkBox:
                            return QuestionCheckboxLayout(
                              questionDetails: getQuestionDetails(
                                languages,
                                local,
                              ),
                              answersDetails: getAnswersDetails(
                                currentAnswers,
                                local,
                              ),
                            );
                          case QuestionType.picMcq:
                            return QuestionMcqPicLayout(
                              questionDetails: getQuestionDetails(
                                languages,
                                local,
                              ),
                              answers: currentAnswers,
                              answersDetails: getAnswersDetails(
                                currentAnswers,
                                local,
                              ),
                            );
                          case QuestionType.picCheckBox:
                            return QuestionCheckboxPicLayout(
                              questionDetails: getQuestionDetails(
                                languages,
                                local,
                              ),
                              answers: currentAnswers,
                              answersDetails: getAnswersDetails(
                                currentAnswers,
                                local,
                              ),
                            );
                          case QuestionType.customRating:
                            return QuestionCustomRatingLayout(
                              questionDetails: getQuestionDetails(
                                languages,
                                local,
                              ),
                              answers: currentAnswers,
                              answersDetails: getAnswersDetails(
                                currentAnswers,
                                local,
                              ),
                            );
                          case QuestionType.customSatisfaction:
                            return QuestionCustomSatisfactionLayout(
                              questionDetails: getQuestionDetails(
                                languages,
                                local,
                              ),
                              answers: currentAnswers,
                              answersDetails: getAnswersDetails(
                                currentAnswers,
                                local,
                              ),
                            );
                          case QuestionType.dropdown:
                            return QuestionDropdownLayout(
                              questionDetails: getQuestionDetails(
                                languages,
                                local,
                              ),
                              answers: currentAnswers,
                              answersDetails: getAnswersDetails(
                                currentAnswers,
                                local,
                              ),
                            );
                        }
                      } else {
                        // TODO: implement customer info
                        var customerInfo = context.select(
                          (SurveyCubit cubit) =>
                              cubit.state.business.survey.customerInfo,
                        );
                        var customerIndex = surveyIndex - questions.length;
                        switch (customerInfo.getInfoTypes[customerIndex]) {
                          case CustomerInfoType.name:
                            return CustomerInfoNameLayout(
                              controller: controller,
                            );
                          case CustomerInfoType.comment:
                            return CustomerInfoCommentLayout(
                              controller: controller,
                            );
                          case CustomerInfoType.birthday:
                            return CustomerInfoBirthdateLayout(
                              controller: controller,
                            );
                          case CustomerInfoType.contact:
                            return CustomerInfoContactLayout(
                              controller: controller,
                            );
                        }
                      }
                      // return Container();
                    },
                  ),
                ),
                const Flexible(
                  flex: 1,
                  child: _ControlSection(),
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
    );
  }
}

class _ControlSection extends StatelessWidget {
  const _ControlSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    final Local local = context.select<SurveyCubit, Local>(
      (cubit) => cubit.state.local,
    );
    final isLastQuestion = context.select(
      (SurveyCubit cubit) {
        SurveyState state = cubit.state;
        return state.surveyIndex ==
            state.business.questions.length -
                1 +
                state.business.survey.customerInfo.getCustomerInfoCount;
      },
    );
    // final questionType = context.select((SurveyCubit cubit) => cubit.state
    //     .business.questions[cubit.state.questionIndex].question.questionType);
    // final bool isCustom = questionType == QuestionType.customRating;
    final CustomerInfoType? customerInfoType = context.select(
      (SurveyCubit cubit) {
        final SurveyState state = cubit.state;
        final int questionsLength = state.business.questions.length;
        final int surveyIndex = state.surveyIndex;
        if (surveyIndex < questionsLength) {
          return null;
        }
        return state.business.survey.customerInfo
            .getInfoTypes[surveyIndex - questionsLength];
      },
    );
    final bool isClickable = context.select((SurveyCubit cubit) {
      SurveyState state = cubit.state;
      int questionsLength = state.business.questions.length;
      int customerIndex = state.surveyIndex - questionsLength;
      var customerInfo = state.business.survey.customerInfo;
      // print(state.customerJson[
      // customerInfo.getInfoTypes[customerIndex].name]);
      bool customerType = customerIndex < 0
          ? false
          :
          // customerInfo.getInfoOptional(customerIndex) ||
          state.customerJson[customerInfo.getInfoTypes[customerIndex].name]!
              .isNotEmpty;
      return state.answersId.isNotEmpty ||
          state.questionsId.isNotEmpty ||
          customerType;
    });
    final bool isOptional = context.select(
      (SurveyCubit cubit) {
        SurveyState state = cubit.state;
        int surveyIndex = state.surveyIndex;
        List<QuestionElement> questions = state.business.questions;
        CustomerInfo customerInfo = state.business.survey.customerInfo;
        if (questions.isNotEmpty && surveyIndex < questions.length) {
          return questions[surveyIndex].question.optional;
        }
        if (customerInfo.getCustomerInfoCount != 0 &&
            surveyIndex - questions.length <
                customerInfo.getCustomerInfoCount) {
          return customerInfo.getInfoOptional(
            surveyIndex - questions.length,
          );
        }
        return false;
      },
    );
    final colorScheme = Theme.of(context).colorScheme;
    print('Is Optional:\t$isOptional');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 16.0),
            alignment: Alignment.bottomCenter,
            child: const CustomProgressIndicator(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Visibility(
              visible: isOptional,
              child: TextButton(
                onPressed: () {
                  print('skip');
                  context.read<SurveyCubit>().onSkip();
                },
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  textStyle: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: getFontFamily(local),
                  ),
                ),
                child: Text(getSkipLocale(local)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: InkWell(
              enableFeedback: false,
              borderRadius: BorderRadius.circular(24.0),
              onTap: isClickable
                  ? () {
                      BlocProvider.of<SurveyCubit>(context).onTimerDismiss();

                      // if (isLastQuestion) {
                      //   BlocProvider.of<SurveyCubit>(context).onSubmitReview();
                      // } else {
                        BlocProvider.of<SurveyCubit>(context).onNextQuestionNew();
                      // }
                      // TODO: implement audio
                      AudioPlayer().play(AssetSource('audios/click1.mp3'));
                    }
                  : () {
                      AudioPlayer().play(AssetSource('audios/click1.mp3'));
                      String toastMsg;
                      switch (customerInfoType) {
                        case CustomerInfoType.name:
                          toastMsg = getToastNameMsgLocale(local);
                          break;
                        case CustomerInfoType.comment:
                          toastMsg = getToastCommentMsgLocale(local);
                          break;
                        case CustomerInfoType.birthday:
                          toastMsg = getToastBirthdateMsgLocale(local);
                          break;
                        case CustomerInfoType.contact:
                          toastMsg = getToastContactMsgLocale(local);
                          break;
                        default:
                          toastMsg = getChooseAnswerLocale(local);
                      }
                      Toast.show(
                        toastMsg,
                        duration: 3,
                        border: Border.all(
                          color: colorScheme.primary,
                        ),
                        backgroundColor: colorScheme.primaryContainer,
                        textStyle: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          locale: Locale(local.name),
                        ),
                        rootNavigator: true,
                        gravity: Toast.top,
                      );
                    },
              child: Container(
                width: 220,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        isClickable ? colorScheme.primary : colorScheme.secondary,
                    width: isClickable ? 3 : 0,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Text(
                  isLastQuestion
                      ? getFinishButtonLocale(local)
                      : getNextButtonLocale(local),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0,
                    fontFamily: getFontFamily(local),
                    color:
                        isClickable ? colorScheme.primary : colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
