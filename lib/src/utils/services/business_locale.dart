import '../../constants/enums.dart';

String getSkipLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'تخطي';
    case Local.en:
      return 'SKIP';
    case Local.tl:
      return 'Laktawan';
    case Local.ur:
      return 'چھوڑ دو';
  }
}

String getContactExceededErrorLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'الرقم تجاوز الحد المسموح';
    case Local.en:
      return 'The number exceeded the limit';
    case Local.tl:
      return 'Ang bilang ay lumampas sa limitasyon';
    case Local.ur:
      return 'تعداد حد سے بڑھ گئی۔';
  }
}

String getContactZeroErrorLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'لا يمكن البدأ بصفر';
    case Local.en:
      return "You can't begin with zero";
    case Local.tl:
      return 'Hindi ka maaaring magsimula sa zero';
    case Local.ur:
      return 'آپ صفر سے شروع نہیں کر سکتے';
  }
}

String getChooseLocale(Local local) {
  switch (local) {
    case Local.ar:
      return '- إختر -';
    case Local.en:
      return '- Choose -';
    case Local.tl:
      return '- pumili -';
    case Local.ur:
      return '- منتخب کریں -';
  }
}

String getYearLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'السنة';
    case Local.en:
      return 'Year';
    case Local.tl:
      return 'taon';
    case Local.ur:
      return 'سال';
  }
}

String getMonthLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'الشهر';
    case Local.en:
      return 'Month';
    case Local.tl:
      return 'buwan';
    case Local.ur:
      return 'مہینہ';
  }
}

String getDayLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'اليوم';
    case Local.en:
      return 'Day';
    case Local.tl:
      return 'araw';
    case Local.ur:
      return 'دن';
  }
}

List<String> getMonthsLocale(Local local) {
  switch (local) {
    case Local.ar:
      return [
        'كانون الثاني (1)',
        'شباط (2)',
        'آذار (3)',
        'نيسان (4)',
        'أيار (5)',
        'حزيران(6)',
        'تموز(7)',
        'آب (8)',
        'أيلول (9)',
        'تشرين أول (10)',
        'تشرين تاني (11)',
        'كانون أول (12)',
      ];
    case Local.en:
      return [
        'January (1)',
        'February (2)',
        'March (3)',
        'April (4)',
        'May (5)',
        'June (6)',
        'July (7)',
        'August (8)',
        'September (9)',
        'October (10)',
        'November (11)',
        'December (12)',
      ];
    case Local.tl:
      return [
        'Enero (1)',
        'Pebrero (2)',
        'Marso (3)',
        'Abril (4)',
        'Mayo (5)',
        'Hunyo (6)',
        'Hulyo (7)',
        'Agosto (8)',
        'Setyembre (9)',
        'Oktubre (10)',
        'Nobyembre (11)',
        'Disyembre (12)',
      ];
    case Local.ur:
      return [
        'جنوری (1)',
        'فروری (2)',
        'مارچ (3)',
        'اپریل (4)',
        'مئی (5)',
        'جون (6)',
        'جولائی (7)',
        'اگست (8)',
        'ستمبر (9)',
        'کتوبر (10)',
        'نومبر (11)',
        'دسمبر (12)',
      ];
  }
}

String getBirthdateLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'الرجاء إدخال تاريخ الميلاد';
    case Local.en:
      return 'Please enter your birthday';
    case Local.tl:
      return 'Pakilagay ang iyong kaarawan';
    case Local.ur:
      return 'براہ کرم اپنی سالگرہ درج کریں۔';
  }
}

String getNameTitleLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'الرجاء إدخال إسمك';
    case Local.en:
      return 'Please enter your name';
    case Local.tl:
      return 'Pakilagay ang iyong pangalan';
    case Local.ur:
      return 'براہ مہربانی اپنا نام درج کریں';
  }
}

String getNameLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'الاسم';
    case Local.en:
      return 'Name';
    case Local.tl:
      return 'Pangalan';
    case Local.ur:
      return 'نام';
  }
}

String getFieldErrorLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'يرجى ملئ الحقل';
    case Local.en:
      return 'Field can not be empty';
    case Local.tl:
      return 'Hindi maaaring walang laman ang field';
    case Local.ur:
      return 'میدان خالی نہیں ہو سکتا';
  }
}

String getCustomerInfoTitleLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'أضف معلومات أخرى';
    case Local.en:
      return 'Add more details';
    case Local.tl:
      return 'Magdagdag ng higit pang mga detalye';
    case Local.ur:
      return 'مزید تفصیلات شامل کریں۔';
  }
}

String getContactNumberLabelLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'أدخل رقم التواصل';
    case Local.en:
      return 'Enter your contact number';
    case Local.tl:
      return 'Ilagay ang iyong contact number';
    case Local.ur:
      return 'اپنا رابطہ نمبر درج کریں۔';
  }
}

String getContactNumberLocale(Local local) {
  switch (local) {
    case Local.en:
      return 'Contact Number';
    case Local.ar:
      return 'رقم التواصل';
    case Local.tl:
      return 'Contact Number';
    case Local.ur:
      return 'رابطہ نمبر';
  }
}

String getOptionalLocale(Local local) {
  switch (local) {
    case Local.en:
      return 'Optional';
    case Local.ar:
      return 'اختياري';
    case Local.tl:
      return 'Opsyonal';
    case Local.ur:
      return 'اختیاری';
  }
}

String getOkLocale(Local local) {
  switch (local) {
    case Local.en:
      return 'Ok';
    case Local.ar:
      return 'موافق';
    case Local.tl:
      return 'Ok';
    case Local.ur:
      return 'موافق';
  }
}

String getCancelLocale(Local local) {
  switch (local) {
    case Local.en:
      return 'Cancel';
    case Local.ar:
      return 'إلغاء';
    case Local.tl:
      return 'Kanselahin';
    case Local.ur:
      return 'منسوخی';
  }
}

String getClearLocale(Local local) {
  switch (local) {
    case Local.en:
      return 'Clear';
    case Local.ar:
      return 'مسح';
    case Local.tl:
      return 'Clear';
    case Local.ur:
      return 'مسح';
  }
}

String getFeedbackLabelLocal(Local local) {
  switch (local) {
    case Local.ar:
      return 'يسعدنا معرفة رأيك, هل لديك أي ملاحظات؟';
    case Local.en:
      return 'We would like to hear from you, do you have any feedback?';
    case Local.tl:
      return 'Nais naming marinig mula sa iyo, mayroon ka bang anumang puna?';
    case Local.ur:
      return 'ہم آپ سے سننا چاہیں گے، کیا آپ کے پاس کوئی رائے ہے؟';
  }
}

String getCommentLabelLocale(Local local) {
  // TODO: instead Noin note => suggestion
  // TODO:
  switch (local) {
    case Local.ar:
      return 'شكوى / إقتراح / إطراء';
    case Local.en:
      return 'Complaint / Suggestion / Compliment';
    case Local.tl:
      return 'Reklam / Mungkahi / Papuri';
    case Local.ur:
      return 'شکایت / مشورہ / تعریف';
  }
}

String getFinishButtonLocale(Local local) {
  switch (local) {
    case Local.en:
      return 'FINISH >>';
    case Local.ar:
      return 'انهاء >>';
    case Local.tl:
      return 'TAPOS >>';
    case Local.ur:
      return 'اختتام >>';
  }
}

String getSaveLocale(Local local) {
  switch (local) {
    case Local.en:
      return 'Please Wait!';
    case Local.ar:
      return 'الرجاء الانتظار!';
    case Local.tl:
      return 'Mangyaring Maghintay!';
    case Local.ur:
      return 'برائے مہربانی انتظار کریں!';
  }
}

String getDoneMsgLocal(Local local) {
  switch (local) {
    case Local.ar:
      return 'تمت العملية بنجاح';
    case Local.en:
      return 'Process is done successfully';
    case Local.tl:
      return 'Matagumpay na nagagawa ang proseso';
    case Local.ur:
      return 'آپریشن کامیابی سے مکمل ہوا';
  }
}

String getThankYouLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'شكراً على وقتك';
    case Local.en:
      return 'Thank you for your time';
    case Local.tl:
      return 'Salamat sa iyong oras';
    case Local.ur:
      return 'آپ کے وقت دینے کا شکریہ';
  }
}

String getGoodbyeLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'مع السلامة!';
    case Local.en:
      return 'Goodbye!';
    case Local.tl:
      return 'paalam na!';
    case Local.ur:
      return 'خدا حافظ!';
  }
}

String getNoLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'لا';
    case Local.en:
      return 'No';
    case Local.tl:
      return 'No';
    case Local.ur:
      return 'لا';
  }
}

String getToastNameMsgLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'الرجاء إدخال ثلاثة أحرف على الأقل';
    case Local.en:
      return 'Please type three letters at least';
    case Local.tl:
      return 'Mangyaring mag-type ng tatlong titik man lang';
    case Local.ur:
      return 'براہ کرم کم از کم تین حروف ٹائپ کریں';
  }
}

String getToastCommentMsgLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'الرجاء إدخال عشرة أحرف على الأقل';
    case Local.en:
      return 'Please type ten letters at least';
    case Local.tl:
      return 'Mag-type ng sampung letra man lang';
    case Local.ur:
      return 'براہ کرم کم از کم دس حروف ٹائپ کریں';
  }
}

String getToastContactMsgLocale(Local local) {
  switch (local) {
    case Local.ar:
      return ' "5* *** ****" الرجاء كتابة رقم اتصال صحيح مثال';
    case Local.en:
      return 'Please type a correct contact number e.g. "5* *** ****"';
    case Local.tl:
      return 'Mangyaring mag-type ng tamang contact number hal. "5* *** ****"';
    case Local.ur:
      return '"5* *** ****" براہ کرم ایک درست رابطہ نمبر ٹائپ کریں جیسے';
  }
}

String getToastBirthdateMsgLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'الرجاء إدخال تاريخ الميلاد';
    case Local.en:
      return 'Please enter birthdate';
    case Local.tl:
      return 'Pakilagay ang petsa ng kapanganakan';
    case Local.ur:
      return 'براہ کرم تاریخ پیدائش درج کریں۔';
  }
}

String getChooseAnswerLocale(Local local) {
  switch (local) {
    case Local.en:
      return 'Please choose at least one answer!';
    case Local.ar:
      return 'الرجاء اختيار إجابة واحدة على الأقل';
    case Local.tl:
      return 'Mangyaring pumili ng hindi bababa sa isang sagot!';
    case Local.ur:
      return 'براہ کرم کم از کم ایک جواب منتخب کریں!';
  }
}

String getYesLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'نعم';
    case Local.en:
      return 'Yes';
    case Local.tl:
      return 'Oho';
    case Local.ur:
      return 'جی ہاں';
  }
}

String getTimerMsgLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'هل تريد المزيد من الوقت؟';
    case Local.en:
      return 'Do you need more time?';
    case Local.tl:
      return 'Kailangan mo ba ng mas maraming oras?';
    case Local.ur:
      return 'کیا آپ مزید وقت چاہتے ہیں؟';
  }
}

String getNextButtonLocale(Local local) {
  switch (local) {
    case Local.en:
      return 'NEXT >>';
    case Local.ar:
      return 'التالي >>';
    case Local.tl:
      return 'SUSUNOD >>';
    case Local.ur:
      return 'اگلا >>';
  }
}

String getAngryLocale(Local local) {
  switch (local) {
    case Local.en:
      return 'Disappointed';
    case Local.ar:
      return 'منزعج';
    case Local.tl:
      return 'Nabigo';
    case Local.ur:
      return 'ناراض';
  }
}

String getUnsatisfiedLocale(Local local) {
  switch (local) {
    case Local.en:
      return 'Unsatisfied';
    case Local.ar:
      return 'غير راضي';
    case Local.tl:
      return 'Hindi nasisiyahan';
    case Local.ur:
      return 'غیر مطمئن';
  }
}

String getNaturalLocale(Local local) {
  switch (local) {
    case Local.en:
      return 'Natural';
    case Local.ar:
      return 'محايد';
    case Local.tl:
      return 'Natural';
    case Local.ur:
      return 'قدرتی';
  }
}

String getSatisfiedLocale(Local local) {
  switch (local) {
    case Local.en:
      return 'Satisfied';
    case Local.ar:
      return 'راضي';
    case Local.tl:
      return 'Nasiyahan';
    case Local.ur:
      return 'مطمئن';
  }
}

String getHappyLocale(Local local) {
  switch (local) {
    case Local.en:
      return 'Happy';
    case Local.ar:
      return 'سعيد';
    case Local.tl:
      return 'Masaya';
    case Local.ur:
      return 'خوش';
  }
}

String getVeryPoorLocale(Local local) {
  switch (local) {
    case Local.en:
      return 'Very Poor';
    case Local.ar:
      return 'ضعيف';
    case Local.tl:
      return 'Maralita';
    case Local.ur:
      return 'بہت برا';
  }
}

String getVeryGoodLocale(Local local) {
  switch (local) {
    case Local.en:
      return 'Very Good';
    case Local.ar:
      return 'جيد جداً';
    case Local.tl:
      return 'Napakahusay';
    case Local.ur:
      return 'بہت اچھے';
  }
}

String getOutOfServiceMsgLocale(Local local) {
  switch (local) {
    case Local.ar:
      return 'نعتذر, هذا الجهاز خارج الخدمة حالياً\n\nالرجاء المعاودة لاحقاً';
    case Local.en:
      return 'Sorry, This device is currently out of service!\n\nCome back later';
    case Local.tl:
      return 'Paumanhin, Kasalukuyang wala sa serbisyo ang device na ito!\n\nBalik ka mamaya';
    case Local.ur:
      return 'معذرت، یہ آلہ فی الحال سروس سے باہر ہے۔\n\nبعد میں واپس آئیں';
  }
}

String getSetupFeedbackLocale(Local locale) {
  switch (locale) {
    case Local.ar:
      return 'هل لديك ملاحظات؟';
    case Local.en:
      return 'Got Feedback?';
    case Local.tl:
      return 'May Feedback?';
    case Local.ur:
      return 'کیا آپ کی رائے ہے؟';
  }
}

String getSetupStartSurveyLocale(Local locale) {
  switch (locale) {
    case Local.ar:
      return 'شارك باستطلاع الرأي\n'
          'اضغط للبدء';
    case Local.en:
      return 'Take 1 minute survey\n'
          'Click to Start';
    case Local.tl:
      return 'Kumuha ng 1 minutong survey\n'
          'I-click upang Magsimula';
    case Local.ur:
      return 'رائے شماری کا اشتراک کریں۔\n'
          'شروع کرنے کے لیے کلک کریں۔';
  }
}
