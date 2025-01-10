import 'package:flutter/material.dart';

class ThankYouPageModel extends StatelessWidget {
  final VoidCallback? callbackIconBack;
  final String? thankYouPageTitle;
  final String thankYouPageMessage;
  final String? image;
  final String? thankYouPageQuestion;
  final String? thankYouPageResponse;
  final String? thankYouPageButton;
  final VoidCallback? callbackConfirm;

  ThankYouPageModel({
    Key? key,
    this.callbackIconBack,
    this.thankYouPageTitle,
    required this.thankYouPageMessage,
    this.image,
    this.thankYouPageQuestion,
    this.thankYouPageResponse,
    this.thankYouPageButton,
    this.callbackConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
