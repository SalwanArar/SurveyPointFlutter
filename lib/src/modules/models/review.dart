// To parse this JSON data, do
//
//     final deviceInfo = deviceInfoFromMap(jsonString);

import 'dart:convert';

class Review {
  const Review({
    required this.surveyId,
    required this.deviceId,
    // required this.comment,
    // required this.contactNumber,
    // required this.name,
    required this.reviewedQuestions,
    required this.reviewedCustomerInfo,
  });

  final int surveyId;
  final int? deviceId;

  // final String? comment;
  // final String? contactNumber;
  // final String? name;
  final List<ReviewedQuestion> reviewedQuestions;
  final ReviewedCustomerInfo reviewedCustomerInfo;

  static const Review empty = Review(
    surveyId: 0,
    deviceId: 0,
    // comment: null,
    // contactNumber: null,
    // name: null,
    reviewedQuestions: [], reviewedCustomerInfo: ReviewedCustomerInfo(),
  );

  Review copyWith({
    int? surveyId,
    int? deviceId,
    // String? comment,
    // String? contactNumber,
    // String? name,
    List<ReviewedQuestion>? reviewedQuestions,
    ReviewedCustomerInfo? reviewedCustomerInfo,
  }) =>
      Review(
        surveyId: surveyId ?? this.surveyId,
        deviceId: deviceId ?? this.deviceId,
        // comment: comment ?? this.comment,
        // contactNumber: contactNumber ?? this.contactNumber,
        // name: name ?? this.name,
        reviewedQuestions: reviewedQuestions ?? this.reviewedQuestions,
        reviewedCustomerInfo: reviewedCustomerInfo ?? this.reviewedCustomerInfo,
      );

  // factory Review.fromJson(String str) => Review.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  // factory Review.fromMap(Map<String, dynamic> json) => Review(
  //       surveyId: json['survey_id'],
  //       deviceId: json['device_id'],
  //       // comment: json['comment'],
  //       // contactNumber: json['contact_number'],
  //       // name: json['name'],
  //       reviewedQuestions: List<ReviewedQuestion>.from(
  //         json["reviewed_questions"].map(
  //           (x) => ReviewedQuestion.fromMap(x),
  //         ),
  //       ), reviewedCustomerInfo: ReviewedCustomerInfo,
  //     );

  Map<String, dynamic> toMap() => {
        'survey_id': surveyId,
        // 'comment': comment,
        // 'contact_number': contactNumber,
        // 'name': name,
        // 'device_id': deviceId,
        'reviewed_questions':
            List<dynamic>.from(reviewedQuestions.map((x) => x.toMap())),
        'reviewed_customer_info': reviewedCustomerInfo.toMap(),
      };
}

class ReviewedCustomerInfo {
  const ReviewedCustomerInfo({
    this.name,
    this.comment,
    this.contact,
    this.birthday,
  });

  final String? name;
  final String? comment;
  final String? contact;
  final String? birthday;

  ReviewedCustomerInfo copyWith({
    String? name,
    String? comment,
    String? contact,
    String? birthday,
  }) =>
      ReviewedCustomerInfo(
        name: name,
        comment: comment,
        contact: contact,
        birthday: birthday,
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "name": name,
        "comment": comment,
        'contact': contact,
        'birthday': birthday,
      };

  factory ReviewedCustomerInfo.fromJson(String str) =>
      ReviewedCustomerInfo.fromMap(json.decode(str));

  factory ReviewedCustomerInfo.fromMap(Map<String, dynamic> json) => ReviewedCustomerInfo(
    comment: json['comment'],
    name: json['name'],
    birthday: json['birthday'],
    contact: json['contact'],
  );
}

class ReviewedQuestion {
  const ReviewedQuestion({
    required this.questionId,
    required this.answers,
  });

  final int questionId;
  final List<int> answers;

  ReviewedQuestion copyWith({
    int? questionId,
    List<int>? answers,
  }) =>
      ReviewedQuestion(
        questionId: questionId ?? this.questionId,
        answers: answers ?? this.answers,
      );

  factory ReviewedQuestion.fromJson(String str) =>
      ReviewedQuestion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReviewedQuestion.fromMap(Map<String, dynamic> json) =>
      ReviewedQuestion(
        questionId: json["question_id"],
        answers: List<int>.from(json["answers"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "question_id": questionId,
        "answers_id": List<dynamic>.from(answers.map((x) => x)),
      };
}
