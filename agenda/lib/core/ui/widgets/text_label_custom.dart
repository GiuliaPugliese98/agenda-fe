import 'package:flutter/material.dart';

import '../../enums/text_style_custom_enum.dart';
import '../theme/app_colors.dart';

class TextLabelCustom extends Text {
  TextLabelCustom(String data,
      {TextStyleCustomEnum styleEnum = TextStyleCustomEnum.normal,
      double size = 20,
      Color colorText = AppColors.blackText,
      int? maxLines,
      TextAlign? align,
      TextOverflow? overflow,
      decorationText = TextDecoration.none})
      : super(data,
            maxLines: maxLines,
            overflow: overflow,
            style: getStyle(styleEnum, size, colorText, decorationText),
            textAlign: align);

  static TextStyle getStyle(TextStyleCustomEnum arg, double sizeText,
      Color colorText, TextDecoration decorationText) {
    switch (arg) {
      case TextStyleCustomEnum.normal:
        return TextStyle(
            fontFamily: 'Helvetica',
            fontSize: sizeText,
            color: colorText,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
            decoration: decorationText);
      case TextStyleCustomEnum.bold:
        return TextStyle(
            fontFamily: 'Helvetica',
            fontSize: sizeText,
            color: colorText,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            decoration: decorationText);
      case TextStyleCustomEnum.italicNormal:
        return TextStyle(
            fontFamily: 'Helvetica',
            fontSize: sizeText,
            color: colorText,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.normal,
            decoration: decorationText);
      case TextStyleCustomEnum.italicBold:
        return TextStyle(
            fontFamily: 'Helvetica',
            fontSize: sizeText,
            color: colorText,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            decoration: decorationText);
      case TextStyleCustomEnum.medium:
        return TextStyle(
            fontFamily: 'Helvetica',
            fontSize: sizeText,
            color: colorText,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            decoration: decorationText);
      case TextStyleCustomEnum.italicMedium:
        return TextStyle(
            fontFamily: 'Helvetica',
            fontSize: sizeText,
            color: colorText,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
            decoration: decorationText);
      case TextStyleCustomEnum.none:
        return TextStyle(
            fontFamily: 'Helvetica',
            fontSize: sizeText,
            color: colorText,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
            decoration: decorationText);
    }
  }
}
