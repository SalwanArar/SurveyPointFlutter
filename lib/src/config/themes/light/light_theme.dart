import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/src/modules/blocs/status_bar_cubit/status_bar_cubit.dart';

import '../../../constants/colors.dart';
import '../../../utils/services/functions.dart';
import '../custom_elevated_button_theme.dart';

// import '../custom_outlined_button_theme.dart';
import '../custom_outlined_button_theme.dart';
import '../custom_text_theme.dart';
import 'light_card_theme.dart';

class LightThemeSettings {
  static ThemeData baseLight(BuildContext context) => ThemeData(
        useMaterial3: true,
        fontFamily:
            getDirectionally(context.read<StatusBarCubit>().state.local) ==
                    TextDirection.ltr
                ? 'Montserrat'
                : 'Vazirmatn',
        colorSchemeSeed: m3PrimaryLight,
        brightness: Brightness.light,
        // shadowColor: m3OnPrimaryContainerLight,
        // scaffoldBackgroundColor: m3BackgroundLight,
        outlinedButtonTheme: customOutlinedButtonThemeData,
        elevatedButtonTheme: customElevatedButtonThemeData,
        textTheme: customTextTheme,
        cardTheme: lightCardTheme,
        // colorScheme: const ColorScheme(
        //   primary: Color(0xff3854c4),
        //   primaryContainer: Color(0xffdde1ff),
        //   onPrimary: Color(0xffffffff),
        //   onPrimaryContainer: Color(0xff001355),
        //   inversePrimary: Color(0xffb8c3ff),
        //   secondary: Color(0xff5a5d72),
        //   secondaryContainer: Color(0xffdfe1f9),
        //   onSecondary: Color(0xffffffff),
        //   onSecondaryContainer: Color(0xff171b2c),
        //   tertiary: Color(0xff76546e),
        //   tertiaryContainer: Color(0xffffd7f3),
        //   onTertiary: Color(0xffffffff),
        //   onTertiaryContainer: Color(0xff2c1229),
        //   error: Color(0xffba1a1a),
        //   errorContainer: Color(0xffffdad6),
        //   onError: Color(0xffffffff),
        //   onErrorContainer: Color(0xff410002),
        //   background: Color(0xfffefbff),
        //   onBackground: Color(0xff1b1b1f),
        //   surface: Color(0xfffefbff),
        //   surfaceTint: Color(0xff3854c4),
        //   // surfaceVariant: Color(0xffe2e1ec),
        //   surfaceVariant: Color(0xFF5B5A5A),
        //   // surfaceVariant: Color.alphaBlend(Color(0xffe2e1ec), Color(0xff1e05ff)),
        //   onSurface: Color(0xff1b1b1f),
        //   onSurfaceVariant: Color(0xff45464f),
        //   inverseSurface: Color(0xff303034),
        //   onInverseSurface: Color(0xfff2f0f4),
        //   outline: Color(0xff767680),
        //   shadow: Color(0xff000000),
        //   brightness: Brightness.light,
        // ),
      );

  static ThemeData baseDark(BuildContext context) => ThemeData(
        useMaterial3: true,
        fontFamily:
            getDirectionally(context.read<StatusBarCubit>().state.local) ==
                    TextDirection.ltr
                ? 'Montserrat'
                : 'Vazirmatn',
        colorSchemeSeed: m3PrimaryDark,
        brightness: Brightness.light,
        shadowColor: m3OnPrimaryContainerLight,
        scaffoldBackgroundColor: m3BackgroundLight,
        // outlinedButtonTheme: customOutlinedButtonThemeData,
        elevatedButtonTheme: customElevatedButtonThemeData,
        textTheme: customTextTheme,
        cardTheme: lightCardTheme,
      );
}
