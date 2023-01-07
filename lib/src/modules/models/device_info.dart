import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../constants/enums.dart';

class DeviceInfo extends Equatable {
  static const DeviceInfo empty = DeviceInfo(
    business: null,
    registration: null,
    deviceLogo: null,
    updatedAt: '1997-01-01 13:58:46',
    organizationName: 'No Name yet',
  );

  const DeviceInfo({
    required this.organizationName,
    this.outOfService = false,
    required this.updatedAt,
    this.locals = const <Local>[],
    required this.business,
    required this.registration,
    required this.deviceLogo,
  });

  final String organizationName;
  final bool outOfService;
  final String updatedAt;
  final List<Local> locals;
  final Business? business;
  final Registration? registration;
  final String? deviceLogo;

  DeviceInfo copyWith({
    String? organizationName,
    bool? outOfService,
    String? updatedAt,
    List<Local>? locals,
    Business? business,
    Registration? registration,
    String? deviceLogo,
  }) =>
      DeviceInfo(
        organizationName: organizationName ?? this.organizationName,
        outOfService: outOfService ?? this.outOfService,
        updatedAt: updatedAt ?? this.updatedAt,
        locals: locals ?? this.locals,
        business: business ?? this.business,
        registration: registration ?? this.registration,
        deviceLogo: deviceLogo ?? this.deviceLogo,
      );

  factory DeviceInfo.fromJson(String str) =>
      DeviceInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DeviceInfo.fromMap(Map<String, dynamic> json) => DeviceInfo(
        locals: List<Local>.generate(
          json['device_locals'].length,
          (index) => Local.ar.toLocal(
            json['device_locals'][index].toString(),
          ),
        ),
        organizationName: json['organization_name'],
        outOfService: json['out_of_service'],
        business: json['business'] == null
            ? null
            : Business.fromMap(json['business']),
        registration: json['registration'] == null
            ? null
            : Registration.fromMap(json['registration']),
        updatedAt: json['updated_at'],
        deviceLogo: json['device_logo'],
      );

  Map<String, dynamic> toMap() => {
        'device_locals': List<Local>.from(locals.map((x) => x.name)),
        'organization_name': organizationName,
        'updated_at': updatedAt,
        'business': business?.toMap(),
        'registration': registration?.toMap(),
        'device_logo': deviceLogo,
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        organizationName,
        updatedAt,
        business,
        locals,
        registration,
        deviceLogo,
      ];
}

class Registration {
  const Registration({
    required this.name,
    required this.birthdate,
    required this.gender,
    required this.phoneNumber,
    required this.nationality,
    required this.residenceState,
    required this.comment,
    this.logoId,
    required this.translations,
  });

  final bool name;
  final bool birthdate;
  final bool gender;
  final bool phoneNumber;
  final bool nationality;
  final bool residenceState;
  final bool comment;
  final String? logoId;
  final List<RegistrationTranslations> translations;

  static const Registration empty = Registration(
    name: true,
    birthdate: true,
    gender: true,
    phoneNumber: true,
    nationality: true,
    residenceState: true,
    comment: true,
    translations: [],
  );

  Registration copyWith({
    bool? name,
    bool? birthdate,
    bool? gender,
    bool? phoneNumber,
    bool? nationality,
    bool? residenceState,
    bool? comment,
    String? logoId,
    List<RegistrationTranslations>? translations,
  }) =>
      Registration(
        name: name ?? this.name,
        birthdate: birthdate ?? this.birthdate,
        gender: gender ?? this.gender,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        nationality: nationality ?? this.nationality,
        residenceState: residenceState ?? this.residenceState,
        comment: comment ?? this.comment,
        logoId: logoId ?? this.logoId,
        translations: translations ?? this.translations,
      );

  factory Registration.fromJson(String str) =>
      Registration.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Registration.fromMap(Map<String, dynamic> json) => Registration(
        name: json["name"] == null ? false : json["name"] == 1,
        birthdate: json["birthdate"] == null ? false : json["birthdate"] == 1,
        gender: json["gender"] == null ? false : json["gender"] == 1,
        phoneNumber:
            json["phone_number"] == null ? false : json["phone_number"] == 1,
        nationality:
            json["nationality"] == null ? false : json["nationality"] == 1,
        residenceState: json["residence_state"] == null
            ? false
            : json["residence_state"] == 1,
        comment: json["comment"] == null ? false : json["comment"] == 1,
        logoId: json["logo_id"],
        translations: json['translations'] == null
            ? []
            : List<RegistrationTranslations>.from(
                json["translations"].map(
                  (x) => RegistrationTranslations.fromMap(x),
                ),
              ),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "birthdate": birthdate,
        "gender": gender,
        "phone_number": phoneNumber,
        "nationality": nationality,
        "residence_state": residenceState,
        "comment": comment,
        "logo_id": logoId,
      };
}

class RegistrationTranslations {
  const RegistrationTranslations({
    required this.registrationDetails,
    required this.registrationLocals,
  });

  final String registrationDetails;
  final Local registrationLocals;

  factory RegistrationTranslations.fromMap(Map<String, dynamic> json) =>
      RegistrationTranslations(
        registrationDetails: json['registration_details'],
        registrationLocals: Local.ar.toLocal(json['registration_local']),
      );
}

class Business {
  const Business({
    required this.survey,
    required this.questions,
  });

  Business copyWith({
    Survey? survey,
    List<QuestionElement>? questions,
  }) =>
      Business(
        survey: survey ?? this.survey,
        questions: questions ?? this.questions,
      );

  static const Business empty = Business(
    survey: Survey.empty,
    questions: [],
  );

  final Survey survey;
  final List<QuestionElement> questions;

  factory Business.fromJson(String str) => Business.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Business.fromMap(Map<String, dynamic> json) => Business(
        survey: Survey.fromMap(json["survey"]),
        questions: List<QuestionElement>.from(
          json["questions"].map(
            (x) => QuestionElement.fromMap(x),
          ),
        ),
      );

  Map<String, dynamic> toMap() => {
        'survey': survey.toMap(),
        "questions": List<dynamic>.from(questions.map((x) => x.toMap())),
      };
}

class QuestionElement {
  const QuestionElement({
    required this.question,
    required this.answers,
  });

  final QuestionQuestion question;
  final List<Answer> answers;

  factory QuestionElement.fromJson(String str) =>
      QuestionElement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  static const QuestionElement empty = QuestionElement(
    question: QuestionQuestion(
      questionId: 0,
      conditionalId: 1,
      language: [],
      optional: false,
      questionOrder: 0,
      questionType: QuestionType.yesOrNo,
    ),
    answers: [],
  );

  factory QuestionElement.fromMap(Map<String, dynamic> json) => QuestionElement(
        question: QuestionQuestion.fromMap(json["question"]),
        answers:
            List<Answer>.from(json["answers"].map((x) => Answer.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "question": question.toMap(),
        "answers": List<dynamic>.from(answers.map((x) => x.toMap())),
      };
}

class Answer {
  Answer({
    required this.id,
    required this.conditional,
    required this.pictureId,
    required this.languages,
  });

  final int id;
  final bool conditional;
  final String? pictureId;
  final List<AnswerLanguage> languages;

  factory Answer.fromJson(String str) => Answer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Answer.fromMap(Map<String, dynamic> json) => Answer(
        id: json["id"],
        conditional: json['conditional'] ?? false,
        pictureId: json["picture_id"],
        languages: List<AnswerLanguage>.from(
            json["languages"].map((x) => AnswerLanguage.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "picture_id": pictureId,
        'conditional': conditional,
        "languages": List<dynamic>.from(languages.map((x) => x.toMap())),
      };
}

class AnswerLanguage {
  AnswerLanguage({
    required this.answerDetails,
    required this.answerLocal,
  });

  final String answerDetails;
  final Local answerLocal;

  factory AnswerLanguage.fromJson(String str) =>
      AnswerLanguage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AnswerLanguage.fromMap(Map<String, dynamic> json) => AnswerLanguage(
        answerDetails: json["answer_details"],
        answerLocal: Local.ar.toLocal(json["answer_local"]),
      );

  Map<String, dynamic> toMap() => {
        "answer_details": answerDetails,
        "answer_local": answerLocal.name,
      };
}

class QuestionQuestion {
  const QuestionQuestion({
    required this.questionId,
    required this.conditionalId,
    required this.questionType,
    required this.questionOrder,
    required this.optional,
    required this.language,
  });

  final int questionId;
  final int? conditionalId;
  final QuestionType questionType;
  final int questionOrder;
  final bool optional;
  final List<QuestionLanguage> language;

  factory QuestionQuestion.fromJson(String str) =>
      QuestionQuestion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QuestionQuestion.fromMap(Map<String, dynamic> json) =>
      QuestionQuestion(
        questionId: json["question_id"],
        conditionalId: json['conditional_id'],
        questionType: QuestionType.yesOrNo.toQuestionType(
          json["question_type"].toString(),
        ),
        questionOrder: json['question_order'],
        optional: json['optional'],
        language: List<QuestionLanguage>.from(
          json["language"].map(
            (x) => QuestionLanguage.fromMap(x),
          ),
        ),
      );

  Map<String, dynamic> toMap() => {
        "question_id": questionId,
        'conditional_id': conditionalId,
        "question_type": questionType.name,
        'question_order': questionOrder,
        'optional': optional,
        "language": List<dynamic>.from(language.map((x) => x.toMap())),
      };
}

class QuestionLanguage {
  QuestionLanguage({
    required this.questionDetails,
    required this.questionLocal,
  });

  final String questionDetails;
  final Local questionLocal;

  factory QuestionLanguage.fromJson(String str) =>
      QuestionLanguage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QuestionLanguage.fromMap(Map<String, dynamic> json) =>
      QuestionLanguage(
        questionDetails: json["question_details"],
        questionLocal: Local.ar.toLocal(json["question_local"]),
      );

  Map<String, dynamic> toMap() => {
        "question_details": questionDetails,
        "question_local": questionLocal.name,
      };
}

class Survey {
  final int id;

  const Survey({
    required this.id,
    required this.surveyName,
    required this.customerInfo,
    required this.contact,
    required this.comment,
    required this.userId,
    required this.logoId,
    required this.updatedAt,
  });

  final String surveyName;
  final CustomerInfo customerInfo;

  // final bool customerInfo;
  final bool contact;
  final bool comment;
  final int userId;
  final String? logoId;
  final String updatedAt;

  static const Survey empty = Survey(
    id: 0,
    surveyName: 'surveyName',
    customerInfo: CustomerInfo.empty,
    // customerInfo: false,
    contact: false,
    comment: false,
    userId: 0,
    logoId: null,
    updatedAt: 'updatedAt',
  );

  factory Survey.fromJson(String str) => Survey.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Survey.fromMap(Map<String, dynamic> json) => Survey(
        id: json["id"],
        surveyName: json["survey_name"],
        // customerInfo: false,
        customerInfo: json["customer_info"] == null
            ? CustomerInfo.empty
            : CustomerInfo.fromJson(json["customer_info"]),
        contact: json['contact_number'] == 1,
        comment: json['comment'] == 1,
        userId: json["user_id"],
        logoId: json["logo_id"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "survey_name": surveyName,
        'customer_info': customerInfo,
        'contact_number': contact,
        'comment': comment,
        "user_id": userId,
        "logo_id": logoId,
        "updated_at": updatedAt,
      };
}

class CustomerInfo {
  const CustomerInfo({
    required CustomerInfoStatus name,
    required CustomerInfoStatus comment,
    required CustomerInfoStatus contact,
    required CustomerInfoStatus birthday,
  })  : _name = name,
        _comment = comment,
        _contact = contact,
        _birthday = birthday;

  final CustomerInfoStatus _name;
  final CustomerInfoStatus _comment;
  final CustomerInfoStatus _birthday;
  final CustomerInfoStatus _contact;

  int get getCustomerInfoCount {
    return getInfoTypes.length;
  }

  List<CustomerInfoType> get getInfoTypes {
    List<CustomerInfoType> customerInfoTypes = [];
    if (_name != CustomerInfoStatus.none) {
      customerInfoTypes.add(CustomerInfoType.name);
    }
    if (_comment != CustomerInfoStatus.none) {
      customerInfoTypes.add(CustomerInfoType.comment);
    }
    if (_birthday != CustomerInfoStatus.none) {
      customerInfoTypes.add(CustomerInfoType.birthday);
    }
    if (_contact != CustomerInfoStatus.none) {
      customerInfoTypes.add(CustomerInfoType.contact);
    }
    return customerInfoTypes;
  }

  bool getInfoOptional(int index) {
    var infoTypes = getInfoTypes;
    CustomerInfoStatus status;
    switch (infoTypes[index]) {
      case CustomerInfoType.name:
        status = _name;
        break;
      case CustomerInfoType.comment:
        status = _comment;
        break;
      case CustomerInfoType.birthday:
        status = _birthday;
        break;
      case CustomerInfoType.contact:
        status = _contact;
        break;
    }
    print('${status.name}\t ${status == CustomerInfoStatus.optional}');
    return status == CustomerInfoStatus.optional;
  }

  static const CustomerInfo empty = CustomerInfo(
    name: CustomerInfoStatus.none,
    comment: CustomerInfoStatus.none,
    birthday: CustomerInfoStatus.none,
    contact: CustomerInfoStatus.none,
  );

  factory CustomerInfo.fromRawJson(String str) =>
      CustomerInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerInfo.fromJson(Map<String, dynamic> json) => CustomerInfo(
        name: CustomerInfoStatus.none.fromString(json["name"]),
        comment: CustomerInfoStatus.none.fromString(json["comment"]),
        birthday: CustomerInfoStatus.none.fromString(json["birthday"]),
        contact: CustomerInfoStatus.none.fromString(json["contact"]),
      );

  Map<String, dynamic> toJson() => {
        "name": _name,
        "comment": _comment,
        "birthday": _birthday,
        "contact": _contact,
      };
}
