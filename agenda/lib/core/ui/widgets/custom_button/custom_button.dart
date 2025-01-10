import 'package:flutter/material.dart';
import '../../../enums/text_style_custom_enum.dart';
import '../../theme/app_colors.dart';
import '../text_label_custom.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double textSize;
  final GestureTapCallback? onPressed;
  final Color textColor;
  final Color fillColor;
  final Color splashColor;
  final double widthPercent;
  final bool filled;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.fillColor = AppColors.secondaryColor,
    this.splashColor = AppColors.mainColor,
    this.widthPercent = 0.7,
    this.textSize = 18,
    this.filled = true,
    this.textColor = AppColors.blackText,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 5,
      fillColor: filled ? fillColor : AppColors.backgroundColor,
      splashColor: splashColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onPressed: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * widthPercent,
        height: MediaQuery.of(context).size.height * 0.07,
        child: Center(
          child: TextLabelCustom(
            text,
            size: textSize,
            styleEnum: TextStyleCustomEnum.bold,
            colorText: textColor,
          ),
        ),
      ),
    );
  }
}