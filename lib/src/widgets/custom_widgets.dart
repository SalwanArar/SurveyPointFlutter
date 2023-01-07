import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:restart_app/restart_app.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../../main.dart';
import '../constants/const_values.dart';
import '../constants/enums.dart';
import '../modules/blocs/authentication_bloc/authentication_bloc.dart';
import '../utils/services/business_locale.dart';
import '../utils/services/functions.dart';
import '../modules/blocs/device_bloc/device_bloc.dart';
import '../modules/blocs/survey_cubit/survey_cubit.dart';
import '../modules/blocs/status_bar_cubit/status_bar_cubit.dart';
import '../utils/services/local_storage_service.dart';

part 'custom_circular_indicator.dart';

part 'custom_align_text.dart';

part 'custom_choose_lang_dialog.dart';

part 'custom_divider.dart';

part 'custom_passcode_dialog.dart';

part 'custom_question_title.dart';

part 'custom_progress_indicator.dart';

part 'custom_number_text_field.dart';

part 'custom_keyboard.dart';

part 'custom_timer_dialog.dart';

part 'custom_animated_pointer.dart';

part 'custom_wifi_settings.dart';
part 'custom_alert_background.dart';
part 'custom_wifi_button.dart';
