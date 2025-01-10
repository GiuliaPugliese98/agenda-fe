import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../enums/text_style_custom_enum.dart';
import '../../../theme/app_colors.dart';
import '../../custom_button/custom_button.dart';
import '../../text_label_custom.dart';
import '../state/thank_you_page_cubit.dart';
import '../thank_you_page_model.dart';

class ThankYouPage extends StatelessWidget {
  final ThankYouPageModel model;

  const ThankYouPage({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<ThankYouPageCubit, ThankYouPageState>(
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Material(
                  borderRadius: BorderRadius.circular(15.0),
                  elevation: 5.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Close Button
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            iconSize: 24,
                            onPressed: model.callbackIconBack ?? () => Get.back(),
                            icon: Icon(Icons.close),
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Title
                        if (model.thankYouPageTitle != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextLabelCustom(
                              model.thankYouPageTitle!,
                              styleEnum: TextStyleCustomEnum.bold,
                              size: 22,
                              colorText: AppColors.blackText,
                              align: TextAlign.center,
                            ),
                          ),
                        const SizedBox(height: 8),

                        // Message
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextLabelCustom(
                            model.thankYouPageMessage,
                            styleEnum: TextStyleCustomEnum.italicNormal,
                            size: 18,
                            colorText: AppColors.blackText,
                            align: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Image
                        if (model.image != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Image.asset(
                              model.image!,
                              height: MediaQuery.of(context).size.width * 0.4,
                              fit: BoxFit.contain,
                            ),
                          ),
                        const SizedBox(height: 10),

                        // Question
                        if (model.thankYouPageQuestion != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextLabelCustom(
                              model.thankYouPageQuestion!,
                              styleEnum: TextStyleCustomEnum.italicNormal,
                              size: 16,
                              colorText: AppColors.blackText,
                              align: TextAlign.center,
                            ),
                          ),

                        // Response
                        if (model.thankYouPageResponse != null)
                          TextButton(
                            onPressed: () {},
                            child: TextLabelCustom(
                              model.thankYouPageResponse!,
                              styleEnum: TextStyleCustomEnum.italicNormal,
                              size: 16,
                              colorText: AppColors.mainColor,
                              align: TextAlign.center,
                            ),
                          ),
                        const SizedBox(height: 20),

                        // Confirm Button
                        if (model.callbackConfirm != null &&
                            model.thankYouPageButton != null)
                          CustomButton(
                            text: model.thankYouPageButton!,
                            onPressed: model.callbackConfirm,
                          ),
                      ],
                    ),
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