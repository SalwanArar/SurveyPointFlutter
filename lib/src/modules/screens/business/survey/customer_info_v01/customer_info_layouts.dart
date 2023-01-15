import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:toast/toast.dart';

import '../../../../../constants/enums.dart';
import '../../../../../utils/services/business_locale.dart';
import '../../../../../utils/services/functions.dart';
import '../../../../../widgets/custom_widgets.dart';
import '../../../../blocs/survey_cubit/survey_cubit.dart';

part 'customer_info_name_layout.dart';

part 'customer_info_comment_layout.dart';

part 'customer_info_birthdate_layout.dart';

part 'customer_info_contact_layout.dart';

decoration({
  required Function(Local) label,
  required Local local,
  required bool isOptional,
  required Color color,
}) =>
    InputDecoration(
      label: Text.rich(
        TextSpan(
          text: label(local),
          children: isOptional
              ? [
                  TextSpan(
                    text: ' (${getOptionalLocale(local)})',
                  ),
                ]
              : [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: color,
                    ),
                  ),
                ],
        ),
      ),
      border: const OutlineInputBorder(),
      prefixIcon: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: FaIcon(FontAwesomeIcons.solidComments),
      ),
    );

class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown({
    Key? key,
    required this.local,
    required this.items,
    required this.dropdownItem,
    required this.label,
    required this.colorScheme,
    this.onTap,
    this.onChange,
  }) : super(key: key);

  final Local local;
  final List<T> items;
  final T? dropdownItem;
  final Function(Local) label;
  final ColorScheme colorScheme;
  final Function()? onTap;
  final Function(T?)? onChange;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.5,
              color: dropdownItem == null
                  ? colorScheme.secondary
                  : colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 22.0,
            vertical: 2.0,
          ),
          clipBehavior: Clip.none,
          child: DropdownButton<T>(
            value: dropdownItem,
            underline: const SizedBox(),
            enableFeedback: false,
            hint: Text(
              getChooseLocale(local),
            ),
            icon: FaIcon(
              FontAwesomeIcons.circleChevronDown,
              color: dropdownItem == null
                  ? colorScheme.secondary
                  : colorScheme.primary,
            ),
            isExpanded: true,
            dropdownColor: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8.0),
            menuMaxHeight: 256.0,
            style: TextStyle(
              fontSize: 24.0,
              color: colorScheme.secondary,
            ),
            items: items
                .map(
                  (e) => DropdownMenuItem<T>(
                    value: e,
                    alignment: getAlignment(local),
                    child: Text(
                      e.toString(),
                      style: TextStyle(
                        fontFamily:
                            T is String ? getFontFamily(local) : 'Montserrat',
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
            onTap: onTap,
            onChanged: onChange,
          ),
        ),
        Positioned(
          top: 0,
          child: Baseline(
            baseline: 0,
            baselineType: TextBaseline.alphabetic,
            child: Container(
              color: colorScheme.background,
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                label(local),
                style: TextStyle(
                  fontSize: 22,
                  color: dropdownItem == null?colorScheme.secondary:colorScheme.primary,
                  fontFamily: getFontFamily(local),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
