import 'dart:ui';

import 'package:survey_point_05/src/constants/assets_path.dart';

enum Local {
  ar,
  en,
  tl,
  ur,
}

extension LocalConvert on Local {
  Local toLocal(String str) {
    switch (str) {
      case 'en':
        return Local.en;
      case 'ar':
        return Local.ar;
      case 'ur':
        return Local.ur;
      case 'tl':
        return Local.tl;
    }
    return Local.ar;
  }
}

enum SharedPreferencesKeys {
  token,
  deviceId,
  deviceCode,
  lastUpdate,
  wiFiSsd,
  wiFiPassword,
  businessName,
  service,
  surveyId,
  questionId,
  termsAgreed,
  locale,
}

enum AuthenticationStatus {
  unknown,
  unauthenticated,
  authenticated,
  // agreement,
}

enum QuestionType {
  yesOrNo,
  rating,
  satisfaction,
  mcq,
  checkBox,
  picMcq,
  picCheckBox,
  customRating,
  customSatisfaction,
  dropdown,
}

extension QuestionTypeConvert on QuestionType {
  QuestionType toQuestionType(String str) {
    switch (str) {
      case 'yes_no':
        return QuestionType.yesOrNo;
      case 'rating':
        return QuestionType.rating;
      case 'satisfaction':
        return QuestionType.satisfaction;
      case 'mcq':
        return QuestionType.mcq;
      case 'mcq_pic':
        return QuestionType.picMcq;
      case 'checkbox':
        return QuestionType.checkBox;
      case 'checkbox_pic':
        return QuestionType.picCheckBox;
      case 'custom_rating':
        return QuestionType.customRating;
      case 'custom_satisfaction':
        return QuestionType.customSatisfaction;
      case 'dropdown':
        return QuestionType.dropdown;
    }
    return QuestionType.yesOrNo;
  }
}

enum DeviceStatus {
  authenticated,
  unauthenticated,
  unattached,
  attached,
}

enum DeviceAuthenticatedStatus {
  unknown,
  survey,
  registration,
  outOfService,
  settings,
}

enum KeyboardIcon {
  englishNumbers,
  englishAlpha,
  arabicAlpha,
}

extension KeyboardIconValues on KeyboardIcon {
  String get iconValue {
    switch (this) {
      case KeyboardIcon.englishNumbers:
        return '123';
      case KeyboardIcon.englishAlpha:
        return 'ABC';
      case KeyboardIcon.arabicAlpha:
        return 'ا ب ج';
    }
  }
}

enum BusinessStatus {
  setup,
  form,
  save,
  customerInfo, // only for survey
  thanks,
}

enum RatingColor {
  rating1,
  rating2,
  rating3,
  rating4,
  rating5,
}

extension RatingColorValue on RatingColor {
  int get toIndex {
    switch (this) {
      case RatingColor.rating1:
        return 3;
      case RatingColor.rating2:
        return 4;
      case RatingColor.rating3:
        return 5;
      case RatingColor.rating4:
        return 6;
      case RatingColor.rating5:
        return 7;
    }
  }

  Color getRealColor() {
    switch (this) {
      case RatingColor.rating1:
        return const Color(0xFFFF8882);
      case RatingColor.rating2:
        return const Color(0x80FF8882);
      case RatingColor.rating3:
        return const Color(0xFFFFFFFF);
      case RatingColor.rating4:
        return const Color(0x807DFF7D);
      case RatingColor.rating5:
        return const Color(0xFF7DFF7D);
    }
  }
}

enum SatisfactionEmoji { angry, unsatisfied, natural, satisfied, happy }

extension GetStatisfactionEmojiIndex on SatisfactionEmoji {
  int get toIndex {
    switch (this) {
      case SatisfactionEmoji.angry:
        return 8;
      case SatisfactionEmoji.unsatisfied:
        return 9;
      case SatisfactionEmoji.natural:
        return 10;
      case SatisfactionEmoji.satisfied:
        return 11;
      case SatisfactionEmoji.happy:
        return 12;
    }
  }

  String get toEmojiAssets {
    switch (this) {
      case SatisfactionEmoji.angry:
        return assetsVeryUnsatisfied;
      case SatisfactionEmoji.unsatisfied:
        return assetsUnsatisfied;
      case SatisfactionEmoji.natural:
        return assetsNatural;
      case SatisfactionEmoji.satisfied:
        return assetsSatisfied;
      case SatisfactionEmoji.happy:
        return assetsVerySatisfied;
    }
  }
}

enum CustomerInfoType {
  name,
  comment,
  birthday,
  contact,
}

enum CustomerInfoStatus {
  none,
  optional,
  mandatory,
}

extension CustomerInfoStatusMethod on CustomerInfoStatus {
  CustomerInfoStatus fromString(String? customerInfoStatus) {
    switch (customerInfoStatus) {
      case 'optional':
        return CustomerInfoStatus.optional;
      case 'mandatory':
        return CustomerInfoStatus.mandatory;
      case 'none':
      default:
        return CustomerInfoStatus.none;
    }
  }
}

enum ThankYouStatus {
  badRate,
  goodRate,
  noRate,
}