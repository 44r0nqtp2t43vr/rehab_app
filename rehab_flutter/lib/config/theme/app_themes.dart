import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: const Color(0XFF275492),
    // fontFamily: 'Muli',
    appBarTheme: appBarTheme(),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: Color(0XFF275492),
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Color(0XFF8B8B8B)),
    titleTextStyle: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
  );
}

TextTheme darkTextTheme() {
  return const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Sailec Bold',
      fontSize: 30,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Sailec Medium',
      fontSize: 22,
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Sailec Light',
      fontSize: 15,
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Sailec Light',
      fontSize: 22,
      color: Colors.white,
    ),
  );
}

TextTheme lightTextTheme() {
  return const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Sailec Bold',
      fontSize: 30,
      color: Color(0XFF275492),
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Sailec Medium',
      fontSize: 22,
      color: Color(0XFF275492),
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Sailec Light',
      fontSize: 15,
      color: Color(0XFF275492),
    ),
  );
}

TextTheme buttonTextTheme() {
  return const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Sailec Bold',
      fontSize: 16,
      color: Colors.white,
    ),
  );
}

final ThemeData darkButtonTheme = ThemeData(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        const Color(0XFF275492),
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        Colors.white,
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          fontFamily: 'Sailec Bold',
          fontSize: 16,
        ),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  ),
);

final ThemeData skipButtonTheme = ThemeData(
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        Colors.white,
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        const Color(0xFF128BED),
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          fontFamily: 'Sailec Bold',
          fontSize: 16,
        ),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  ),
);
