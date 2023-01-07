part of 'survey_cubit.dart';

abstract class SurveyState extends Equatable {
  const SurveyState({
    required this.business,
    required this.locals,
    required this.dialog,
    this.local = Local.en,
    this.status = BusinessStatus.setup,
    this.review = Review.empty,
    this.surveyIndex = 0,
    this.answersId = const [],
    this.questionsId = const [],
    this.timerVisibility = false,
    this.dialogVisibility = false,
    this.refreshValue = 0.0,
    this.customerJson = const {},
  });

  final Business business;
  final List<Local> locals;
  final Local local;
  final BusinessStatus status;
  final Review review;
  final int surveyIndex;
  final List<int> answersId;
  final List<int> questionsId;
  final bool timerVisibility;
  final bool dialogVisibility;
  final double refreshValue;
  final Map<String, String> customerJson;
  final Widget dialog;

  @override
  List<Object> get props => [
        business,
        locals,
        local,
        status,
        review,
    surveyIndex,
        answersId,
        questionsId,
        timerVisibility,
        dialogVisibility,
        refreshValue,
        dialog,
        customerJson,
      ];

  SurveyState copyWith({
    Business? business,
    List<Local>? locals,
    Local? local,
    BusinessStatus? status,
    Review? review,
    int? surveyIndex,
    List<int>? answersId,
    List<int>? questionsId,
    bool? timerVisibility,
    bool? dialogVisibility,
    double? refreshValue,
    Map<String, String>? customerJson,
    Widget? dialog,
  });
}

class SurveyInitial extends SurveyState {
  const SurveyInitial({
    required super.business,
    required super.locals,
    required super.dialog,
    super.local = Local.en,
    super.status = BusinessStatus.setup,
    super.review = Review.empty,
    super.surveyIndex = 0,
    super.answersId = const [],
    super.questionsId = const [],
    super.timerVisibility = false,
    super.dialogVisibility = false,
    super.refreshValue = 0.0,
    super.customerJson = const {
      'name': '',
      'comment': '',
      'birthday': '',
      'contact': '',
    },
  });

  @override
  SurveyState copyWith({
    Business? business,
    List<Local>? locals,
    Local? local,
    BusinessStatus? status,
    Review? review,
    int? surveyIndex,
    List<int>? answersId,
    List<int>? questionsId,
    bool? timerVisibility,
    bool? dialogVisibility,
    double? refreshValue,
    Map<String, String>? customerJson,
    Widget? dialog,
  }) =>
      SurveyInitial(
        business: business ?? this.business,
        locals: locals ?? this.locals,
        local: local ?? this.local,
        status: status ?? this.status,
        review: review ?? this.review,
        surveyIndex: surveyIndex ?? this.surveyIndex,
        answersId: answersId ?? this.answersId,
        questionsId: questionsId ?? this.questionsId,
        timerVisibility: timerVisibility ?? this.timerVisibility,
        dialogVisibility: dialogVisibility ?? this.dialogVisibility,
        refreshValue: refreshValue ?? this.refreshValue,
        customerJson: customerJson ?? this.customerJson,
        dialog: dialog ?? this.dialog,
      );
}
