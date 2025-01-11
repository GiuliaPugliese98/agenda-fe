import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../core/base_widgets/base_widget.dart';
import '../../../core/costants/string_constants.dart';
import '../../../core/data/models/user_credentials_model/user_credentials_model.dart';
import '../../../core/enums/form_field_custom_type_enum.dart';
import '../../../core/enums/text_style_custom_enum.dart';
import '../../../core/ui/app_routes/routes.dart';
import '../../../core/ui/app_routes/routes_constants.dart';
import '../../../core/ui/widgets/custom_button/custom_button.dart';
import '../../../core/ui/widgets/text_form_custom/screen/text_form_custom_screen.dart';
import '../../../core/ui/widgets/text_label_custom.dart';
import '../../../core/utils/handle_dismiss_keyboard.dart';
import '../../../generated/assets.dart';
import '../state/login_cubit.dart';
import '../user_controller.dart';

class Login extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isValidFieldEmail = false;
  bool isValidFieldPassword = false;
  bool isLoginButtonEnable = false;

  @override
  Widget build(BuildContext context) {
    return HandleDismissKeyboard(child: _buildLogin(context));
  }

  Widget _buildLogin(BuildContext context) {
    return BlocProvider(
        create: (_) => LoginCubit(),
        child: BlocListener<LoginCubit, LoginState>(listener: (context, state) {
          if (state is LoginInitial) {
          } else if (state is LoginSuccess) {
            final userController = Get.find<UserController>();
            userController.setUser(state.user);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppRoutes.pushNamed(Routes.calendar);
            });
          } else if (state is LoginLockSignIn) {
            isLoginButtonEnable = false;
          } else if (state is LoginUnlockSignIn) {
            isLoginButtonEnable = true;
          } else if (state is LoginError) {
            context.read<LoginCubit>().showErrorDialog(state.error);
          } else if (state is LoginErrorUserNotAuthorized) {
            context.read<LoginCubit>().showErrorDialog(state.error);
          }
        }, child:
            BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
          return _buildLoginWidget(context);
        })));
  }

  Widget _buildLoginWidget(BuildContext context) {
    return BaseWidget(
      isBackGestureEnabled: true,
      navBarTitle: StringConstants.loginTitle,
      navigationTitleColor: Colors.white,
      body: Listener(
        onPointerDown: (_) => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Image.asset(
                    Assets.imagesAppLogo,
                    height: MediaQuery.of(context).size.width * 0.2,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  TextLabelCustom(
                    StringConstants.loginSubtitle,
                    styleEnum: TextStyleCustomEnum.medium,
                    maxLines: 1,
                    size: 18,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      children: <Widget>[
                        TextFormFieldCustom(
                          onChanged: (isValid) =>
                          {isValidFieldEmail = isValid, checkForm(context)},
                          labelText: StringConstants.loginEmail,
                          formFieldType: FormFieldCustomTypeEnum.email,
                          textEditingController: emailController,
                          hintText: StringConstants.loginEmailHintText,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        TextFormFieldCustom(
                          onChanged: (isValid) =>
                          {isValidFieldPassword = isValid, checkForm(context)},
                          labelText: StringConstants.loginPassword,
                          formFieldType: FormFieldCustomTypeEnum.password,
                          textEditingController: passwordController,
                          hintText: StringConstants.loginPasswordHintText,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  CustomButton(
                    text: StringConstants.loginButton,
                    filled: isLoginButtonEnable,
                    onPressed: isLoginButtonEnable
                        ? () {
                      context.read<LoginCubit>().login(UserCredentialsModel(
                          email: emailController.text.toString(),
                          password: passwordController.text.toString()));
                    }
                        : null,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkForm(BuildContext context) {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      context
          .read<LoginCubit>()
          .setButtonState(isValidFieldEmail && isValidFieldPassword);
    } else {
      context.read<LoginCubit>().lockSignIn();
    }
  }
}
