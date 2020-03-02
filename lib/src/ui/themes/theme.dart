import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData primaryTheme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme().copyWith(
    display4: GoogleFonts.tangerine().copyWith(color: Colors.black87),
    button: TextStyle(color: Colors.white),
  ),
  fontFamily: GoogleFonts.openSans().fontFamily,
  primarySwatch: Colors.blue,
  accentTextTheme: TextTheme(button: TextStyle(color: Colors.white)),
  inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        fontSize: 14,
      ),
      alignLabelWithHint: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
      ), 
      errorStyle: TextStyle(height: 1),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300], width: 0.5),
          borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[800], width: 0.5),
          borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue[700]),
          borderRadius: BorderRadius.circular(10)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[800], width: 0.5),
          borderRadius: BorderRadius.circular(10)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red[800], width: 1),
          borderRadius: BorderRadius.circular(10))),
);
