import 'package:flutter/material.dart';

abstract class AppStyles {
  static const double textSizeFormFiel = 14.0;
  static const double textSizeParagraph = 19.0;
  static const double textSizeTitle = 24.0;
  static const double borderRadiusButton = 30.0;

  static const String fontTitlesHighlight = 'TitlesHighlight';
  static const String fontTextsParagraphs = 'TextsParagraphs';

  static const Color colorBluePrimary = Color(0xff2B5178);
  static const Color colorBlueSecundary = Color(0xff273456);
  static const Color colorRedPrimary = Color(0xffD84835);
  static const Color colorRedSecundary = Color(0xffF96352);
  static const Color colorBeige = Color(0xffE3D3B2);
  static const Color colorBlack = Color(0xff1C1C1C);
  static const Color colorWhite = Color(0xffFFFFFF);
  static const Color colorGray = Color(0xff8E8E8E);
  static const Color colorError = Color(0xffbb2124);
  static const Color colorWarning = Color(0xfff0ad4e);
  static const Color colorSuccess = Color(0xff22bb33);

  static const TextStyle textFormField = TextStyle(
      color: colorWhite,
      fontSize: textSizeParagraph,
      fontFamily: fontTitlesHighlight);
  static const TextStyle textFormFieldError = TextStyle(
      color: colorError,
      fontSize: textSizeFormFiel,
      fontFamily: fontTextsParagraphs);
  static const TextStyle textStyleRadioButton = TextStyle(
      color: colorWhite,
      fontSize: textSizeParagraph,
      fontFamily: fontTitlesHighlight);
  static const TextStyle textStylePrimaryButton = TextStyle(
      fontSize: textSizeParagraph,
      color: colorBlack,
      fontFamily: fontTitlesHighlight,
      fontWeight: FontWeight.bold);
  static const TextStyle textStyleSecundaryButton = TextStyle(
      fontSize: textSizeParagraph,
      color: colorWhite,
      fontFamily: fontTitlesHighlight,
      fontWeight: FontWeight.bold);
  static const TextStyle textStyleLink = TextStyle(
      fontSize: textSizeParagraph,
      color: colorWhite,
      fontWeight: FontWeight.bold,
      fontFamily: fontTitlesHighlight,
      letterSpacing: 1.5);
  static const TextStyle textStyletermsAndConditions = TextStyle(
      fontFamily: fontTitlesHighlight,
      fontSize: textSizeParagraph,
      color: colorWhite,
      letterSpacing: 1.0);
  static const TextStyle textStyletermsAndConditionsLink = TextStyle(
      fontFamily: fontTitlesHighlight,
      fontSize: textSizeParagraph,
      color: colorRedPrimary,
      decoration: TextDecoration.underline,
      letterSpacing: 1.0);
  static const TextStyle textFormFieldCounter = TextStyle(
      color: colorWhite,
      fontSize: textSizeFormFiel,
      fontFamily: fontTextsParagraphs);
  static const TextStyle textStyleButton = TextStyle(
      fontSize: textSizeParagraph,
      color: colorWhite,
      fontFamily: fontTitlesHighlight,
      fontWeight: FontWeight.bold);
  static const TextStyle textStyleAppBarTitle = TextStyle(
      fontSize: textSizeParagraph,
      fontFamily: fontTitlesHighlight,
      fontWeight: FontWeight.bold);
  static const TextStyle textStyleOnlineDoctor = TextStyle(
      fontSize: textSizeParagraph,
      color: Colors.black,
      fontFamily: fontTitlesHighlight,
      fontWeight: FontWeight.bold);
  static const TextStyle textStyleMenuUser =
      TextStyle(fontSize: textSizeParagraph, fontFamily: fontTitlesHighlight);
  static const TextStyle textStyleMenuDynamic =
      TextStyle(fontSize: textSizeTitle, fontFamily: fontTitlesHighlight);
  static const TextStyle textStyleMenuStatic =
      TextStyle(fontSize: textSizeTitle, fontFamily: fontTitlesHighlight);
  static const TextStyle textStyleLoading = TextStyle(
      fontSize: textSizeParagraph,
      fontFamily: fontTitlesHighlight,
      color: colorWhite,
      fontWeight: FontWeight.bold);
  static const TextStyle textStyleService24 = TextStyle(
      color: colorWhite,
      fontFamily: fontTextsParagraphs,
      fontSize: 38.0,
      height: -0.2);
  static const TextStyle textStyleService365 = TextStyle(
    color: colorWhite,
    fontFamily: fontTextsParagraphs,
    fontSize: 29.0,
  );
  static const TextStyle textStyleTitle = TextStyle(
      fontSize: textSizeTitle,
      fontFamily: fontTitlesHighlight,
      color: colorWhite);
  static const TextStyle textStyleSelect = TextStyle(
      fontSize: 28.0, color: Colors.black, fontFamily: fontTitlesHighlight);
  static const TextStyle textStyleOptionSelect = TextStyle(
      fontSize: 18.0, color: Colors.black, fontFamily: fontTextsParagraphs);

  static const EdgeInsets paddingBody = EdgeInsets.all(16.0);
  static const EdgeInsets paddingFormField =
      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0);
  static const EdgeInsets paddingButton =
      EdgeInsets.symmetric(vertical: 12.0, horizontal: 160.0);
  static const EdgeInsets paddingButtonEmergency =
      EdgeInsets.symmetric(vertical: 12.0, horizontal: 110.0);

  static OutlineInputBorder textFormFieldBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: colorWhite, width: 2),
      borderRadius: BorderRadius.circular(borderRadiusButton));
  static OutlineInputBorder textFormFieldBorderActive = OutlineInputBorder(
      borderSide: const BorderSide(color: colorWhite, width: 3),
      borderRadius: BorderRadius.circular(borderRadiusButton));

  static ButtonStyle buttonStylePrimaryButton = ButtonStyle(
    padding: MaterialStateProperty.all(paddingButton),
    //minimumSize: MaterialStateProperty.all(const Size(200, 12)),
    backgroundColor: MaterialStateProperty.all(colorWhite.withAlpha(50)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusButton),
          side: BorderSide(color: colorBeige.withOpacity(0.4))),
    ),
  );
  static ButtonStyle buttonStyleSecundaryButton = ButtonStyle(
    padding: MaterialStateProperty.all(paddingButton),
    backgroundColor: MaterialStateProperty.all(colorRedPrimary),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusButton),
          side: BorderSide(color: colorRedPrimary.withOpacity(1))),
    ),
  );
  static ButtonStyle buttonStyleEmergencyButton = ButtonStyle(
    padding: MaterialStateProperty.all(paddingButtonEmergency),
    elevation: MaterialStateProperty.all(30.0),
    backgroundColor: MaterialStateProperty.all(colorRedPrimary),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusButton),
          side: BorderSide(color: colorRedPrimary.withOpacity(1))),
    ),
  );

  static const RoundedRectangleBorder buttonCallOnlineDoctor =
      RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
    topRight: Radius.circular(60),
    bottomRight: Radius.circular(30),
  ));
  static const RoundedRectangleBorder buttonVideoOnlineDoctor =
      RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
    topLeft: Radius.circular(60),
    bottomLeft: Radius.circular(30),
  ));

  static const BoxDecoration boxDecorationOnlineDoctor =
      BoxDecoration(boxShadow: [
    BoxShadow(color: colorBlack, blurRadius: 15.0, offset: Offset(0.0, 0.75))
  ], color: Color(0xFFECF3F9));
}
