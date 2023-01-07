import '/src/constants/colors.dart';
import 'package:flutter/material.dart';

ElevatedButtonThemeData customElevatedButtonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    textStyle: const TextStyle(
      fontSize: 20.0
    ),
    backgroundColor: m3PrimaryLight,
    foregroundColor: m3OnPrimaryLight,
    disabledBackgroundColor: m3SurfaceLight,
    disabledForegroundColor: m3OnSurfaceLight,
    elevation: 8.0,
    padding: const EdgeInsets.symmetric(
      horizontal: 24.0,
      vertical: 10.0,
    ),
  ),
  // style: ElevatedButton.styleFrom(
  //   // elevation: 4.0,
  //   // minimumSize: const Size.fromHeight(64.0),
  //   // padding: const EdgeInsets.symmetric(
  //   //   vertical: 24.0,
  //   //   horizontal: 96.0,
  //   // ),
  //   // primary: m3PrimaryLight,
  //   // onPrimary: m3OnPrimaryLight,
  //   // onSurface: m3OnSurfaceLight,
  // ),
);
