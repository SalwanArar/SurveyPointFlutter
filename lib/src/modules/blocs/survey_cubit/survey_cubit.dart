import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../constants/enums.dart';
import '../../../utils/services/local_storage_service.dart';
import '../../models/device_info.dart';
import '../../models/repositories/review_repository.dart';
import '../../models/review.dart';

part 'survey_state.dart';

class SurveyCubit extends Cubit<SurveyState> {
  SurveyCubit(DeviceInfo deviceInfo, Widget dialog)
      : super(
          SurveyInitial(
            business: deviceInfo.business!,
            locals: deviceInfo.locals,
            dialog: dialog,
          ),
        );

  ///
  /// [onTimerVisible]
  /// TODO: add description to the event
  ///
  void onTimerVisible(Widget dialog) => emit(
        state.copyWith(
          timerVisibility: true,
          dialog: dialog,
        ),
      );

  ///
  /// [onTimerDismiss]
  /// TODO: add description to the event
  ///
  void onTimerDismiss() {
    double random = Random().nextDouble();
    while (random == state.refreshValue) {
      random = Random().nextDouble();
    }
    return emit(
      state.copyWith(
        timerVisibility: false,
        refreshValue: random,
      ),
    );
  }

  ///
  /// [onDialogVisible]
  /// TODO: add description to the event
  ///
  void onDialogVisible(Widget dialog) => emit(
        state.copyWith(
          // dialogVisibility: true,
          timerVisibility: true,
          dialog: dialog,
        ),
      );

  ///
  /// [onDialogDismiss]
  /// TODO: add description to the event
  ///
  void onDialogDismiss(Widget dialog) => emit(
        state.copyWith(
            // dialogVisibility: false,
            timerVisibility: false,
            dialog: dialog),
      );

  ///
  /// [onTimerRefresh]
  /// TODO: add description to the event
  ///
  void onTimerRefresh() {
    double random = Random().nextDouble();
    while (random == state.refreshValue) {
      random = Random().nextDouble();
    }
    return emit(
      state.copyWith(
        refreshValue: random,
      ),
    );
  }

  ///
  /// [onStartSurvey]
  /// Start survey by set local, deviceId, and surveyId
  ///
  void onStartSurvey(Local local) async {
    return emit(
      state.copyWith(
        local: local,
        review: Review(
          surveyId: state.business.survey.id,
          // TODO: deviceId problem
          deviceId: await getDeviceId(),
          // name: null,
          // comment: null,
          // contactNumber: null,
          reviewedQuestions: [],
          reviewedCustomerInfo: const ReviewedCustomerInfo(),
        ),
        status: BusinessStatus.form,
      ),
    );
  }

  ///
  /// [onSkip]
  ///
  onSkip() async {
    var questions = state.business.questions;
    int surveyIndex = state.surveyIndex;
    int skipCount = 1;
    try {
      if (questions[surveyIndex + 1].question.conditionalId != null) {
        skipCount++;
      }
    } catch (_) {
      print("FINALLY IT'S OUT OF RANGE!!!!");
    }
    emit(
      state.copyWith(
        surveyIndex: surveyIndex + skipCount,
        answersId: [],
        questionsId: [],
        dialogVisibility: false,
      ),
    );
  }

  ///
  /// [onNextQuestionNewTest]
  ///
  onNextQuestionNewTest() async {
    // Review review = Review.empty;
    List<QuestionElement> questions = List.from(state.business.questions);
    // int surveyLength = questions.length +
    //     state.business.survey.customerInfo.getCustomerInfoCount;
    int surveyIndex = state.surveyIndex;
    // check if question, customerInfo or both
    if (questions.isNotEmpty && surveyIndex < questions.length) {
      var question = questions[surveyIndex].question;
      // to save the review if it's not a custom question
      switch (question.questionType) {
        case QuestionType.customRating:
          if (state.answersId.isNotEmpty) {
            _createNewReview(
              questionId: questions[surveyIndex].answers.first.id,
            );
          }
          break;
        case QuestionType.customSatisfaction:
          if (state.answersId.isNotEmpty) {
            _createNewReview(
              questionId: questions[surveyIndex].answers.first.id,
            );
          }
          break;
        default:
          _createNewReview(
            questionId: question.questionId,
          );
      }
    } else if (state.business.survey.customerInfo.getCustomerInfoCount != 0 &&
        surveyIndex < 0) {}
  }

  ///
  /// to create new review
  ///
  _createNewReview({
    required int questionId,
  }) {
    var reviewedQuestions = state.review.reviewedQuestions;
    reviewedQuestions.add(
      ReviewedQuestion(
        questionId: questionId,
        answers: state.answersId,
      ),
    );
  }

  ///
  /// [onNextQuestionNew]
  ///
  onNextQuestionNew() async {
    Review review = Review.empty;
    List<QuestionElement> questions = List.from(
      state.business.questions,
    );
    int surveysLength = questions.length +
        state.business.survey.customerInfo.getCustomerInfoCount;
    int surveyIndex = state.surveyIndex;
    if (surveysLength == surveyIndex) {
      return _submit(review);
    } else if (surveyIndex < questions.length) {
      switch (questions[surveyIndex].question.questionType) {
        case QuestionType.customRating:
        case QuestionType.customSatisfaction:
          break;
        default:
          List<ReviewedQuestion> reviewedQuestions = List.from(
            state.review.reviewedQuestions,
          );
          reviewedQuestions.add(
            ReviewedQuestion(
              questionId: questions[surveyIndex].question.questionId,
              answers: state.answersId,
            ),
          );
          review = state.review.copyWith(
            reviewedQuestions: List.from(reviewedQuestions),
          );
      }
      if (surveyIndex < questions.length - 1) {
        if (questions[surveyIndex].question.conditionalId != null) {
          List<int> conditionalAnswerIds = [];
          for (var answer in questions[surveyIndex].answers) {
            if (answer.conditional) conditionalAnswerIds.add(answer.id);
          }

          if (review.reviewedQuestions.last.answers.any(
            (reviewedAnswer) => conditionalAnswerIds.any(
              (id) => id == reviewedAnswer,
            ),
          )) {
            return emit(
              state.copyWith(
                review: review,
                surveyIndex: surveyIndex + 1,
                answersId: [],
                questionsId: [],
                dialogVisibility: false,
              ),
            );
          }
          if (surveysLength == surveyIndex + 1) {
            return await _submit(review);
          } else {
            return emit(
              state.copyWith(
                review: review,
                surveyIndex: surveyIndex + 2,
                answersId: [],
                questionsId: [],
                dialogVisibility: false,
              ),
            );
          }
        }
      }
    } else {
      // TODO: add info to review
      review.copyWith(
        reviewedCustomerInfo: ReviewedCustomerInfo(
          contact: state.customerJson['contact'],
          comment: state.customerJson['comment'],
          name: state.customerJson['name'],
          birthday: state.customerJson['birthday'],
          // ? null
          // : DateTime.parse(state.customerJson['birthday']!),
        ),
      );
    }
    return emit(
      state.copyWith(
        review: review,
        surveyIndex: surveyIndex + 1,
        answersId: [],
        questionsId: [],
      ),
    );
  }

  ///
  /// [onNextQuestionOld]
  /// TODO: add description to the event
  ///
  Future<void> onNextQuestionOld({bool isCustom = false}) async {
    Review review = Review.empty;
    int questionIndex = state.surveyIndex;
    List<QuestionElement> questions = List.from(state.business.questions);
    if (!isCustom) {
      /*** Add New Review ***/
      List<ReviewedQuestion> reviewedQuestions = List.from(
        state.review.reviewedQuestions,
      );
      // reviewedQuestions.addAll(state.review.reviewedQuestions);
      reviewedQuestions.add(
        ReviewedQuestion(
          questionId: questions[questionIndex].question.questionId,
          answers: state.answersId,
        ),
      );
      review = state.review.copyWith(
        reviewedQuestions: reviewedQuestions,
      );
    }

    /*** Check if it's not out of range ***/
    int questionsLength = questions.length - 1;
    if (questionsLength == questionIndex) {
      return await _submit(review);
    }

    if (questions[questionIndex + 1].question.conditionalId != null) {
      List<int> conditionalAnswers = [];
      for (var answer in questions[questionIndex].answers) {
        if (answer.conditional) conditionalAnswers.add(answer.id);
      }

      if (review.reviewedQuestions.last.answers.any(
        (reviewedAnswer) => conditionalAnswers.any(
          (element) => element == reviewedAnswer,
        ),
      )) {
        return emit(
          state.copyWith(
            review: review,
            surveyIndex: questionIndex + 1,
            answersId: [],
            questionsId: [],
            dialogVisibility: false,
          ),
        );
      }
      if (questionsLength == questionIndex + 1) {
        return await _submit(review);
      } else {
        return emit(
          state.copyWith(
            review: review,
            surveyIndex: questionIndex + 2,
            answersId: [],
            questionsId: [],
            dialogVisibility: false,
          ),
        );
      }
    }

    return emit(
      state.copyWith(
        review: review,
        surveyIndex: questionIndex + 1,
        answersId: [],
        questionsId: [],
      ),
    );
  }

  Future<void> onAddingInfo(String info, CustomerInfoType type) async {
    Map<String, String> customerJson = Map.from(state.customerJson);
    switch (type) {
      case CustomerInfoType.name:
        customerJson['name'] = info;
        break;
      case CustomerInfoType.comment:
        customerJson['comment'] = info;
        break;
      case CustomerInfoType.contact:
        customerJson['contact'] = info;
        break;
      case CustomerInfoType.birthday:
        customerJson['birthday'] = info;
        break;
    }
    return emit(state.copyWith(
      customerJson: customerJson,
    ));
  }

  Future<void> _submit(Review review) async {
    // TODO: check the condition
    // if (state.business.survey.customerInfo) {
    //   return emit(state.copyWith(status: BusinessStatus.customerInfo));
    // }
    emit(
      state.copyWith(
        status: BusinessStatus.save,
      ),
    );
    // TODO: remove print
    if (kDebugMode) {
      print(review.toJson());
    }
    print('*' * 88);
    try {
      switch (await ReviewRepository.submitReview(review)) {
        case true:
        case false:
        case null:
      }
    } catch (e) {
      // TODO: remove print
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return emit(
      SurveyInitial(
        business: state.business,
        locals: state.locals,
        dialog: state.dialog,
        status: BusinessStatus.thanks,
      ),
    );
  }

  ///
  /// [onReplaceAnswer]
  /// Mainly used for Yes/No type of question
  /// it will replace the existing answerId with new one
  ///
  void onReplaceAnswer(int id) {
    return emit(
      state.copyWith(answersId: [id]),
    );
  }

  ///
  /// [onRemoveAnswers]
  /// Used for custom question when navigator pop to choose another option
  /// Purpose: remove all the answers
  ///
  void onRemoveAnswers() {
    return emit(
      state.copyWith(answersId: []),
    );
  }

  ///
  /// [onRemoveReview]
  /// Remove review for custom question
  ///
  void onRemoveReview(int questionId) {
    final Review review = state.review;
    review.reviewedQuestions.removeWhere(
      (element) => element.questionId == questionId,
    );
    final List<int> questionsId = List.from(state.questionsId);
    // TODO: remove print
    if (kDebugMode) {
      print('old Remove Question:${questionsId.isEmpty}');
      print('old State Question:${state.questionsId.isEmpty}');
    }
    questionsId.remove(questionId);
    // TODO: remove print
    if (kDebugMode) {
      print('new Remove Question:${questionsId.isEmpty}');
      print('new State Question:${state.questionsId.isEmpty}');
    }
    return emit(
      state.copyWith(
        review: review,
        answersId: [],
        questionsId: questionsId,
      ),
    );
  }

  ///
  /// [onAddReview]
  /// Remove review for custom question
  ///
  void onAddReview(int questionId) {
    List<ReviewedQuestion> reviewedQuestions = List.from(
      state.review.reviewedQuestions,
    );
    // List<ReviewedQuestion> reviewedQuestions = [];
    // reviewedQuestions.addAll(state.review.reviewedQuestions);
    reviewedQuestions.add(
      ReviewedQuestion(
        questionId: questionId,
        answers: state.answersId,
      ),
    );
    Review review = state.review.copyWith(
      reviewedQuestions: reviewedQuestions,
    );
    List<int> questionsId = List.from(state.questionsId);

    // List<int> questionsId = [];
    // questionsId.addAll(state.questionsId);
    questionsId.add(questionId);
    return emit(
      state.copyWith(
        review: review,
        answersId: [],
        questionsId: questionsId,
      ),
    );
  }

  ///
  /// [onAddAnswerToReview]
  /// Used each time an answer been selected
  /// if the answer exists it will remove it
  /// else new answerId will be added to the reviewed question
  ///
  void onAddAnswerToReview(int id) {
    List<int> answersId = [];
    answersId.addAll(state.answersId);
    if (answersId.contains(id)) {
      answersId.remove(id);
    } else {
      answersId.add(id);
    }
    return emit(
      state.copyWith(answersId: answersId),
    );
  }

  ///
  /// [onSubmitReview]
  /// "FOR NON NORMAL QUESTIONS"
  /// Move to the next question and add a new review to the survey
  ///
  Future<void> onSubmitReview(// String? comment,
      // String? contactNumber,
      // String? name,
      ) async {
    Review review = state.review.copyWith(
      // comment: comment,
      // contactNumber: contactNumber,
      // name: name,
      surveyId: state.review.surveyId,
      deviceId: await getDeviceId(),
      reviewedCustomerInfo: ReviewedCustomerInfo.fromMap(
        state.customerJson,
      ),
    );

    emit(
      state.copyWith(
        review: review,
        thankYouStatus: _checkForBadReview(review),
        status: BusinessStatus.save,
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    // if (state.review.reviewedQuestions.isNotEmpty) {
    try {
      await ReviewRepository.submitReview(state.review
          // state.review.copyWith(
          //   // comment: comment,
          //   // contactNumber: contactNumber,
          //   // name: name,
          //   deviceId: await getDeviceId(),
          //   reviewedCustomerInfo: ReviewedCustomerInfo.fromMap(
          //     state.customerJson,
          //   ),
          // ),
          );
    } catch (e) {
      // TODO: remove print
      if (kDebugMode) {
        print(e.toString());
        print('*' * 88);
        print(state.review.toJson());
        print('*' * 88);
      }
    }
    // }
    emit(state.copyWith(status: BusinessStatus.thanks));
    // TODO: const delayTime for thanks layout 6 seconds
    await Future.delayed(const Duration(seconds: 6));
    return emit(
      SurveyInitial(
        business: state.business,
        locals: state.locals,
        dialog: state.dialog,
      ),
    );
  }

  ThankYouStatus _checkForBadReview(Review review) {
    for (ReviewedQuestion reviewedQuestion in review.reviewedQuestions) {
      if (reviewedQuestion.answers.any(
        (element) =>
            element == 3 || element == 4 || element == 8 || element == 9,
      )) {
        return ThankYouStatus.badRate;
      }
      if (reviewedQuestion.answers.any(
        (element) =>
            element == 5 ||
            element == 6 ||
            element == 7 ||
            element == 10 ||
            element == 11 ||
            element == 12,
      )) {
        return ThankYouStatus.goodRate;
      }
    }
    return ThankYouStatus.noRate;
  }
}
