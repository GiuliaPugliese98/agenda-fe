import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;
import '../../../../../generated/assets.dart';
import '../../../../costants/string_constants.dart';
import '../../../../enums/alert_dialog_enum.dart';
import '../../../../enums/text_style_custom_enum.dart';
import '../../../../utils/handle_dismiss_keyboard.dart';
import '../../../theme/app_colors.dart';
import '../../custom_button/custom_button.dart';
import '../../text_label_custom.dart';
import '../cubit/alert_dialog_cubit.dart';

class AlertDialogPage extends StatelessWidget {
  final String title;
  final String message;
  final bool showImage;
  final StateAlert state;
  String image = "";
  final String buttonTextConfirm;
  final bool showIconX;
  final List<AlertDialogPageButton> buttons;
  final VoidCallback? callbackConfirm;
  final VoidCallback? callbackUndo;
  final VoidCallback? callbackBack;

  AlertDialogPage({
    Key? key,
    required this.title,
    required this.message,
    required this.showImage,
    required this.state,
    this.buttonTextConfirm = "",
    this.callbackConfirm,
    this.callbackUndo,
    this.callbackBack,
    this.showIconX = true,
    this.buttons = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: buildAlertDialogWidget(
        context,
        title,
        message,
        showImage,
        state,
        callbackConfirm,
        callbackBack,
        callbackUndo,
      ),
    );
  }

  Widget buildAlertDialogWidget(
    BuildContext context,
    String title,
    String message,
    bool showImage,
    StateAlert state,
    VoidCallback? callbackConfirm,
    VoidCallback? callbackBackButton,
    VoidCallback? callbackUndo,
  ) {
    if (image.isEmpty) {
      if (state == StateAlert.success) {
        image = Assets.imagesCheckMark;
      } else if (state == StateAlert.error) {
        image = Assets.imagesExclamationMarkRed;
      } else {
        image = Assets.imagesExclamationMarkGreen;
      }
    }

    List<AlertDialogPageButton> buttons = [];

    if (callbackUndo != null) {
      buttons.add(AlertDialogPageButton(
        StringConstants.alertDialogButtonCancel,
        AppColors.mainColor,
        callbackUndo,
      ));
    }

    if (callbackConfirm != null) {
      if (buttonTextConfirm.isNotEmpty) {
        buttons.add(AlertDialogPageButton(
          buttonTextConfirm,
          AppColors.mainColor,
          callbackConfirm,
        ));
      } else {
        buttons.add(AlertDialogPageButton(
          StringConstants.ok,
          AppColors.mainColor,
          callbackConfirm,
        ));
      }
    }

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return HandleDismissKeyboard(
      child: BlocBuilder<AlertDialogCubit, AlertDialogState>(
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: screenWidth * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Close Icon
                      if (showIconX)
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            iconSize: 24,
                            onPressed: callbackBackButton ?? () => Get.back(),
                            icon: const Icon(Icons.close),
                            color: AppColors.blackText,
                          ),
                        ),
                      const SizedBox(height: 10),

                      if (showImage)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Image.asset(
                            image,
                            height: screenHeight * 0.1,
                            fit: BoxFit.contain,
                          ),
                        ),

                      // Titolo
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextLabelCustom(
                          title,
                          align: TextAlign.center,
                          styleEnum: TextStyleCustomEnum.bold,
                          size: 20,
                          colorText: AppColors.blackText,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextLabelCustom(
                          message,
                          align: TextAlign.center,
                          styleEnum: TextStyleCustomEnum.medium,
                          size: 16,
                          colorText: AppColors.blackText,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        alignment: WrapAlignment.center,
                        children: buttons
                            .map(
                              (button) => SizedBox(
                                width: (screenWidth * 0.7) / buttons.length,
                                child: CustomButton(
                                  text: button.text,
                                  textColor: Colors.white,
                                  onPressed: button.actionOnPress,
                                  fillColor: button.color,
                                  textSize: 14,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AlertDialogPageButton {
  String text;
  Color color;
  VoidCallback actionOnPress;

  AlertDialogPageButton(this.text, this.color, this.actionOnPress);
}
