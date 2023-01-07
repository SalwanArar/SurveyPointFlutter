import 'package:flutter/material.dart';

import '../../constants/enums.dart';
import '../../modules/models/device_info.dart';

double? getPointerPositionRight(Local locale, double position) {
  switch (locale) {
    case Local.ar:
    case Local.ur:
      return null;
    case Local.en:
    case Local.tl:
      return position;
  }
}

double? getPointerPositionLeft(Local locale, double position) {
  switch (locale) {
    case Local.ar:
    case Local.ur:
      return position;
    case Local.en:
    case Local.tl:
      return null;
  }
}

TextDirection getDirectionally(Local local) {
  switch (local) {
    case Local.ar:
    case Local.ur:
      return TextDirection.rtl;
    case Local.en:
    case Local.tl:
      return TextDirection.ltr;
  }
}

TextDirection getReverseDirectionally(Local local) {
  switch (local) {
    case Local.ar:
    case Local.ur:
      return TextDirection.ltr;
    case Local.en:
    case Local.tl:
      return TextDirection.rtl;
  }
}

Alignment getAlignment(Local local) {
  switch (local) {
    case Local.ar:
    case Local.ur:
      return Alignment.centerRight;
    case Local.en:
    case Local.tl:
      return Alignment.centerLeft;
  }
}

bool isDirectionLtr(Local local) {
  switch (local) {
    case Local.ar:
    case Local.ur:
      return false;
    case Local.en:
    case Local.tl:
      return true;
  }
}

Alignment getReverseAlignment(Local local) {
  switch (local) {
    case Local.ar:
    case Local.ur:
      return Alignment.centerLeft;
    case Local.en:
    case Local.tl:
      return Alignment.centerRight;
  }
}

String getFontFamily(Local local) {
  switch (local) {
    case Local.ar:
    case Local.ur:
      return 'Vazirmatn';
    case Local.en:
    case Local.tl:
      return 'Montserrat';
  }
}

// TODO: chose another name
// deviceRepositoryListener(BuildContext context) {
//   DeviceInfo info = BlocProvider.of<DeviceBloc>(context).state.deviceInfo;
//   DeviceAuthenticatedStatus status;
//   if (info.outOfService) {
//     status = DeviceAuthenticatedStatus.outOfService;
//   } else if (info.business != null) {
//     status = DeviceAuthenticatedStatus.survey;
//   } else if (info.registration != null) {
//     status = DeviceAuthenticatedStatus.registration;
//   } else {
//     status = DeviceAuthenticatedStatus.outOfService;
//   }
//   return BlocProvider.of<DeviceBloc>(context).add(
//     DeviceStatusChangeEvent(
//       status,
//       info,
//     ),
//   );
// }

String getQuestionDetails(List<QuestionLanguage> languages, Local local) {
  for (QuestionLanguage language in languages) {
    if (language.questionLocal == local) {
      return language.questionDetails;
    }
  }
  switch (local) {
    case Local.ar:
      return 'تفاضيل السؤال ليست موجودة';
    case Local.en:
      return 'no question details';
    case Local.tl:
      return 'no question details';
    case Local.ur:
      return 'تفاضيل السؤال ليست موجودة';
  }
}

List<String> getAnswersDetails(List<Answer> answer, Local local) {
  List<String> answersDetails = [];
  for (Answer answer in answer) {
    for (AnswerLanguage language in answer.languages) {
      if (language.answerLocal == local) {
        answersDetails.add(language.answerDetails);
        break;
      }
    }
  }
  return answersDetails;
}

Business getQuestionsOrder(Business business) {
  // List<QuestionElement> questions = List.from(business.questions);
  // int questionsLength = questions.length;
  // for (int i = 0; i < questionsLength; i++) {
  //   int? conditionalId = questions[i].question.conditionalId;
  //   if (conditionalId != null) {
  //     for (int j = 0; j < questionsLength; j++) {
  //       if (conditionalId == questions[j].question.questionId) {
  //         int nextIndex = j + 1;
  //         if (nextIndex == i || nextIndex == questionsLength) break;
  //         var temp = questions[nextIndex];
  //         questions[nextIndex] = questions[i];
  //         questions[i] = temp;
  //         break;
  //       }
  //     }
  //   }
  // }

  List<QuestionElement> newQuestions = List.generate(
    business.questions.length,
    (index) => QuestionElement.empty,
  );
  for (QuestionElement question in business.questions) {
    newQuestions[question.question.questionOrder - 1] = question;
  }

  return Business(
    survey: business.survey,
    questions: newQuestions,
  );
}

void insertText(
  String insertedText,
  TextEditingController textEditingController,
  int limit,
) {
  if (limit == textEditingController.text.length) return;
  final text = textEditingController.text;
  final textSelection = textEditingController.selection;
  final newText = text.replaceRange(
    textSelection.start,
    textSelection.end,
    insertedText,
  );
  final myTextLength = insertedText.length;
  textEditingController.text = newText;
  textEditingController.selection = textSelection.copyWith(
    baseOffset: textSelection.start + myTextLength,
    extentOffset: textSelection.start + myTextLength,
  );
}

void backspace(TextEditingController textEditingController) {
  final text = textEditingController.text;
  final textSelection = textEditingController.selection;
  final selectionLength = textSelection.end - textSelection.start;

  // There is a selection.
  if (selectionLength > 0) {
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      '',
    );
    textEditingController.text = newText;
    textEditingController.selection = textSelection.copyWith(
      baseOffset: textSelection.start,
      extentOffset: textSelection.start,
    );
    return;
  }

  // The cursor is at the beginning.
  if (textSelection.start == 0) {
    return;
  }

  // Delete the previous character
  final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
  final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
  final newStart = textSelection.start - offset;
  final newEnd = textSelection.start;
  final newText = text.replaceRange(
    newStart,
    newEnd,
    '',
  );
  textEditingController.text = newText;
  textEditingController.selection = textSelection.copyWith(
    baseOffset: newStart,
    extentOffset: newStart,
  );
}

bool _isUtf16Surrogate(int value) {
  return value & 0xF800 == 0xD800;
}
