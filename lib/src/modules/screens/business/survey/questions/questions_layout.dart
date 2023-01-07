import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';

import '../../../../../constants/const_values.dart';
import '../../../../../utils/services/business_locale.dart';
import '/src/utils/services/functions.dart';
import '../../../../../constants/assets_path.dart';
import '../../../../../constants/enums.dart';
import '../../../../../widgets/custom_widgets.dart';
import '../../../../models/device_info.dart';
import '../../../../blocs/survey_cubit/survey_cubit.dart';

part 'question_yes_no_layout.dart';

part 'question_rating_layout.dart';

part 'question_satisfaction_layout.dart';

part 'question_mcq_layout.dart';

part 'question_mcq_pic_layout.dart';

part 'question_checkbox_layout.dart';

part 'question_checkbox_pic_layout.dart';

part 'question_custom_rating_layout.dart';

part 'question_custom_satisfaction_layout.dart';

part 'question_dropdown_layout.dart';

// TODO: const borderWidth = 4
const double borderWidth = 4;

EdgeInsetsGeometry answerPicPadding(double width) => EdgeInsets.symmetric(
  horizontal: width * 0.0375,
);

optionTitle({
  required String title,
  required Local local,
}) =>
    Text(
      title,
      style: TextStyle(
        fontSize: 38.0,
        fontWeight: FontWeight.w600,
        fontFamily: getFontFamily(local),
      ),
      textAlign: TextAlign.center,
    );

optionPicture({
  required String? answerPicUrl,
  required ColorScheme colorScheme,
}) =>
    Container(
      width: 288,
      height: 240,
      margin: const EdgeInsets.symmetric(vertical: 32.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: colorScheme.secondary,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: CachedNetworkImage(
        imageUrl: answerPicUrl ??
            "https://lirp.cdn-website.com/873f309c/dms3rep/multi/opt/Final+Design-126w.png",
        progressIndicatorBuilder: (
          context,
          url,
          downloadProgress,
        ) =>
            Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            value: downloadProgress.progress,
          ),
        ),
        imageBuilder: (context, imageProvider) => Container(
          margin: const EdgeInsets.all(16.0),
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
