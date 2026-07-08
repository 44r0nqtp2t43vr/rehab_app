import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const Color heatmap1 = Color(0xFF9CFFD8);
const Color heatmap2 = Color(0xFF38FFB0);
const Color heatmap3 = Color(0xFF01B36C);
const Color heatmap4 = Color(0xFF017B4A);
const Color heatmap5 = Color(0xFF013420);

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
      height: 1.2,
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Sailec Light',
      fontSize: 15,
      height: 1.2,
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Sailec Light',
      height: 1.2,
      fontSize: 22,
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Sailec Medium',
      fontSize: 15,
      height: 1.2,
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
      backgroundColor: WidgetStateProperty.all<Color>(
        const Color(0XFF275492),
      ),
      foregroundColor: WidgetStateProperty.all<Color>(
        Colors.white,
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        const TextStyle(
          fontFamily: 'Sailec Bold',
          fontSize: 16,
        ),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
      backgroundColor: WidgetStateProperty.all<Color>(
        Colors.white,
      ),
      foregroundColor: WidgetStateProperty.all<Color>(
        const Color(0xFF128BED),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        const TextStyle(
          fontFamily: 'Sailec Bold',
          fontSize: 16,
        ),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
      foregroundColor: WidgetStateProperty.all<Color>(
        Colors.white,
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
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
      foregroundColor: WidgetStateProperty.all<Color>(
        Colors.white,
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
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
      iconSize: WidgetStateProperty.all<double>(
        40,
      ),
      backgroundColor: WidgetStateProperty.all<Color>(
        Colors.white,
      ),
      foregroundColor: WidgetStateProperty.all<Color>(
        const Color(0XFF275492),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      fixedSize: WidgetStateProperty.all<Size>(
        const Size(60, 60),
      ),
    ),
  ),
);

final ThemeData smallIconButtonTheme = ThemeData(
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconSize: WidgetStateProperty.all<double>(
        20,
      ),
      backgroundColor: WidgetStateProperty.all<Color>(
        Colors.white,
      ),
      foregroundColor: WidgetStateProperty.all<Color>(
        const Color(0XFF275492),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      fixedSize: WidgetStateProperty.all<Size>(
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
    color: Color(0XFFD1D1D1),
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

InputDecoration customDropdownDecoration = InputDecoration(
  labelStyle: const TextStyle(
    overflow: TextOverflow.ellipsis,
    color: Color(0XFFD1D1D1),
  ),
  hintStyle: const TextStyle(
    color: Color(0XFFD1D1D1),
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
  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  floatingLabelBehavior: FloatingLabelBehavior.never,
);

Widget cuButton({
  required BuildContext context,
  required VoidCallback onPressed,
  required String title,
  required String subTitle,
  required String svgPath,
  double borderRadius = 10.0,
}) {
  return Expanded(
    child: LayoutBuilder(builder: (context, constraints) {
      final buttonWidth = constraints.maxWidth;
      final buttonHeight = constraints.maxHeight;

      final svgWidth = buttonWidth * 0.7;
      final svgHeight = buttonHeight * 0.7;

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF128BED),
                      Color(0xFF01FF99),
                    ],
                    stops: [0.3, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Container(
                color: Colors.black.withValues(alpha: 0.2),
              ),
              Positioned(
                left: -20,
                bottom: -10,
                child: SvgPicture.asset(
                  svgPath,
                  width: svgWidth,
                  height: svgHeight,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: onPressed,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontFamily: 'Sailec Bold',
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            subTitle,
                            style: const TextStyle(
                              fontFamily: 'Sailec Light',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }),
  );
}

Widget cuButtonDialog({
  required BuildContext context,
  required VoidCallback onPressed,
  required String title,
  required String svgPath,
  double svgPercentage = 0.6,
}) {
  return Container(
    height: 72,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          spreadRadius: 0,
          blurRadius: 20,
          offset: const Offset(4, 4),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF128BED),
                  Color(0xFF01FF99),
                ],
                stops: [0.3, 1.0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          Container(
            color: Colors.black.withValues(alpha: 0.2),
          ),
          Positioned(
            left: -20,
            bottom: -10,
            child: SvgPicture.asset(
              svgPath,
              width: 100,
              height: 100,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "",
                  style: TextStyle(
                    fontFamily: 'Sailec Bold',
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Sailec Medium',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                highlightColor: Colors.white.withValues(alpha: 0.2),
                onTap: onPressed,
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget cuSelectPlanButtons({
  required BuildContext context,
  required VoidCallback onPressed,
  required String title,
  required String subtitle,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF128BED),
                    Color(0xFF01FF99),
                  ],
                  stops: [0.3, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Container(
              color: Colors.black.withValues(alpha: 0.2),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Sailec Medium',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Sailec Light',
                          fontSize: 12,
                          height: 1.2,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget musicTopButtons({
  required BuildContext context,
  required VoidCallback onPressed,
  required String title,
  bool isActive = false,
  required IconData icon,
}) {
  return Expanded(
    child: LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(4, 4),
            ),
          ],
          color: isActive ? const Color(0xff01FF99) : const Color(0xff128BED),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        icon,
                        color: isActive ? const Color(0xff275492) : Colors.white,
                        size: 28,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Sailec Medium',
                          fontSize: 12,
                          color: isActive ? const Color(0xff275492) : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  highlightColor: Colors.white.withValues(alpha: 0.2),
                  onTap: onPressed,
                  child: Container(),
                ),
              ),
            ),
          ],
        ),
      );
    }),
  );
}
