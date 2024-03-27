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
      height: 1.2,
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
    displaySmall: TextStyle(
      fontFamily: 'Sailec Medium',
      fontSize: 15,
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

final ThemeData textButtonTheme = ThemeData(
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(
        Colors.white,
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          fontFamily: 'Sailec Medium',
          fontSize: 12,
        ),
      ),
    ),
  ),
);

final ThemeData signupButtonTheme = ThemeData(
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(
        Colors.white,
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          fontFamily: 'Sailec Medium',
          fontSize: 15,
        ),
      ),
    ),
  ),
);

final ThemeData loginButtonTheme = ThemeData(
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconSize: MaterialStateProperty.all<double>(
        40,
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
        Colors.white,
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        const Color(0XFF275492),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      fixedSize: MaterialStateProperty.all<Size>(
        const Size(60, 60),
      ),
    ),
  ),
);

final ThemeData smallIconButtonTheme = ThemeData(
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconSize: MaterialStateProperty.all<double>(
        20,
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
        Colors.white,
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        const Color(0XFF275492),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      fixedSize: MaterialStateProperty.all<Size>(
        const Size(40, 40),
      ),
    ),
  ),
);

InputDecoration customInputDecoration = InputDecoration(
  labelStyle: const TextStyle(
    color: Color(0XFFD1D1D1),
  ),
  floatingLabelStyle: const TextStyle(
    color: Color(0XFF275492),
    backgroundColor: Colors.white,
  ),
  hintStyle: const TextStyle(
    color: Colors.white,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Color(0XFFd1d1d1), width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Color(0XFF275492), width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: Colors.red,
      width: 2,
    ),
  ),
  errorStyle: const TextStyle(
    color: Colors.red,
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: Colors.red,
      width: 2,
    ),
  ),
  filled: true,
  fillColor: Colors.white,
  contentPadding: const EdgeInsets.all(15.0),
);
