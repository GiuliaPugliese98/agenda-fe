import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/base_widgets/base_widget.dart';
import '../../core/costants/string_constants.dart';
import '../../core/enums/text_style_custom_enum.dart';
import '../../core/ui/app_routes/routes.dart';
import '../../core/ui/app_routes/routes_constants.dart';
import '../../core/ui/widgets/custom_button/custom_button.dart';
import '../../core/ui/widgets/text_label_custom.dart';
import '../../generated/assets.dart';
import '../state/pre_login_cubit.dart';

class PreLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      navBarTitle: "",
      withOutNavigationBar: true,
      isBackGestureEnabled: false,
      body: Scaffold(body: _buildPreLoginWidget(context)),
    );
  }

  Widget _buildPreLoginWidget(BuildContext context) {
    return BlocBuilder<PreLoginCubit, PreLoginState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth;
            double logoSize = maxWidth * 0.2;
            double buttonSpacing = maxWidth * 0.03;
            double padding = maxWidth * 0.05;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: maxWidth * 0.1),
                      Image.asset(
                        Assets.imagesAppLogo,
                        height: logoSize,
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(height: buttonSpacing),
                      TextLabelCustom(
                        StringConstants.appName,
                        styleEnum: TextStyleCustomEnum.bold,
                        maxLines: 1,
                        size: 24,
                      ),
                      SizedBox(height: buttonSpacing),
                      CustomButton(
                        text: StringConstants.loginButton,
                        onPressed: () {
                          AppRoutes.pushNamed(Routes.login);
                        },
                      ),
                      SizedBox(height: buttonSpacing),
                      TextLabelCustom(StringConstants.accountQuestion),
                      SizedBox(height: buttonSpacing),
                      CustomButton(
                        text: StringConstants.createAccount,
                        filled: false,
                        onPressed: () {
                          AppRoutes.pushNamed(Routes.registration);
                        },
                      ),
                      SizedBox(height: maxWidth * 0.1),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}