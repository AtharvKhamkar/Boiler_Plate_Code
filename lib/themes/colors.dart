import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/utils.dart';

const kThird = Color(0xff66cbdf);
const kPrimaryLight = Color.fromARGB(255, 55, 50, 154);
const kPrimaryDark = Color(0xFF007bc1);
const kSecondary = Color.fromARGB(255, 222, 163, 0);
const backgroundColor = Color.fromRGBO(19, 28, 33, 1);
const textColor = Color.fromRGBO(241, 241, 242, 1);
const appBarColor = Color.fromRGBO(31, 44, 52, 1);
const webAppBarColor = Color.fromRGBO(42, 47, 50, 1);
const messageColor = Color.fromRGBO(5, 96, 98, 1);
const senderMessageColor = Color.fromRGBO(37, 45, 49, 1);
const tabColor = Color.fromRGBO(0, 167, 131, 1);
const searchBarColor = Color.fromRGBO(50, 55, 57, 1);
const dividerColor = Color.fromRGBO(37, 45, 50, 1);
const chatBarMessage = Color.fromRGBO(30, 36, 40, 1);
const mobileChatBoxColor = Color.fromRGBO(31, 44, 52, 1);
const greyColor = Colors.grey;
const darkGrey = Color.fromRGBO(93, 93, 93, 1.0);
const darkGrey2 = Color.fromRGBO(51, 51, 51, 1.0);

const blackColor = Colors.black;

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: kPrimaryLight,
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFDCE1FF),
  onPrimaryContainer: Color(0xFF00164F),
  secondary: Color(0xFF595D72),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFDEE1F9),
  onSecondaryContainer: Color(0xFF161B2C),
  tertiary: Color(0xFF75546F),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFD7F6),
  onTertiaryContainer: Color(0xFF2C122A),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFEFBFF),
  onBackground: Color(0xFF1B1B1F),
  surface: Color(0xFFFEFBFF),
  onSurface: Color(0xFF1B1B1F),
  surfaceVariant: Color(0xFFE2E1EC),
  onSurfaceVariant: Color(0xFF45464F),
  outline: Color(0xFF767680),
  onInverseSurface: Color(0xFFF2F0F4),
  inverseSurface: Color(0xFF303034),
  inversePrimary: Color(0xFFB6C4FF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF004FE5),
  outlineVariant: Color(0xFFC6C6D0),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFB6C4FF),
  onPrimary: kPrimaryDark,
  primaryContainer: Color(0xFF003BB0),
  onPrimaryContainer: Color(0xFFDCE1FF),
  secondary: Color(0xFFC2C5DD),
  onSecondary: Color(0xFF2B3042),
  secondaryContainer: Color(0xFF424659),
  onSecondaryContainer: Color(0xFFDEE1F9),
  tertiary: Color(0xFFE3BADA),
  onTertiary: Color(0xFF432740),
  tertiaryContainer: Color(0xFF5B3D57),
  onTertiaryContainer: Color(0xFFFFD7F6),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF1B1B1F),
  onBackground: Color(0xFFE4E1E6),
  surface: Color(0xFF1B1B1F),
  onSurface: Color(0xFFE4E1E6),
  surfaceVariant: Color(0xFF45464F),
  onSurfaceVariant: Color(0xFFC6C6D0),
  outline: Color(0xFF90909A),
  onInverseSurface: Color(0xFF1B1B1F),
  inverseSurface: Color(0xFFE4E1E6),
  inversePrimary: Color(0xFF004FE5),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFB6C4FF),
  outlineVariant: Color(0xFF45464F),
  scrim: Color(0xFF000000),
);

Color get primaryColor {
  return Get.isDarkMode ? kPrimaryLight : kPrimaryDark;
}

Color get darkLight {
  return Get.isDarkMode ? Colors.white : Colors.black87;
}

Color get textPrimaryColor {
  return Get.theme.colorScheme.primary;
}

TextStyle textStyle({
  double size = 14,
  FontWeight weight = FontWeight.normal,
  Color? color,
}) {
  return GoogleFonts.poppins(
    fontSize: size,
    fontWeight: weight,
    color: color ?? textPrimaryColor,
  );
}

TextStyle chatStyle() {
  return GoogleFonts.poppins(
    color: getTextColor(),
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.5,
  );
}
