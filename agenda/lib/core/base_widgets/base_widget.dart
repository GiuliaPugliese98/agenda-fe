import 'package:flutter/material.dart';
import '../enums/text_style_custom_enum.dart';
import '../ui/theme/app_colors.dart';
import '../ui/widgets/text_label_custom.dart';

class BaseWidget extends StatelessWidget {
  final bool withOutNavigationBar;
  final String navBarTitle;
  final Color navigationBackgroundColor;
  final Color navigationTitleColor;
  final bool navigationWithShadow;
  final Widget? body;
  final bool isBackGestureEnabled;
  final VoidCallback? customBackAction;
  final List<Widget>? actions;

  BaseWidget({
    Key? key,
    this.withOutNavigationBar = false,
    required this.navBarTitle,
    this.navigationBackgroundColor = AppColors.mainColor,
    this.navigationTitleColor = Colors.white,
    this.navigationWithShadow = false,
    required this.body,
    this.isBackGestureEnabled = false,
    this.customBackAction,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isBackGestureEnabled,
      onPopInvoked: (bool didPop) {
        if (!didPop && customBackAction != null) {
          customBackAction!();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: withOutNavigationBar
            ? null
            : PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            backgroundColor: navigationBackgroundColor,
            elevation: navigationWithShadow ? 4.0 : 0.0,
            automaticallyImplyLeading: false,
            actions: actions,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: EdgeInsets.only(left: 16.0, bottom: 16.0),
              title: TextLabelCustom(navBarTitle, colorText: navigationTitleColor, styleEnum: TextStyleCustomEnum.bold),
            ),
          ),
        ),
        body: body,
      ),
    );
  }
}