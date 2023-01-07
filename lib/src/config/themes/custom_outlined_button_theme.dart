import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

OutlinedButtonThemeData customOutlinedButtonThemeData = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(
      horizontal: 32.0,
      vertical: 6.0,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
);
