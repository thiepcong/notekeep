import 'package:flutter/material.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    colorScheme: ColorScheme.dark(),
    iconTheme: IconThemeData(
      color: Colors.blueAccent,
    ),
    primaryColor: Colors.blueAccent,
    
  );

  final dartTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.light(),
    primaryColor: Colors.blueGrey,
    iconTheme: IconThemeData(
      color: Colors.blueGrey,
    ),
  );
}
