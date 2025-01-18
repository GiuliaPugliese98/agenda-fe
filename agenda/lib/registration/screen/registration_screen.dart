import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../core/base_widgets/base_widget.dart';
import '../../core/costants/string_constants.dart';
import '../../core/data/models/user_model/user_model.dart';
import '../../core/data/repository/user_repository.dart';
import '../../core/enums/form_field_custom_type_enum.dart';
import '../../core/ui/app_routes/routes.dart';
import '../../core/ui/app_routes/routes_constants.dart';
import '../../core/ui/widgets/custom_button/custom_button.dart';
import '../../core/ui/widgets/text_form_custom/screen/text_form_custom_screen.dart';
import '../../core/ui/widgets/text_label_custom.dart';
import '../../core/ui/widgets/thank_you_page/screen/thank_you_page.dart';
import '../../core/ui/widgets/thank_you_page/thank_you_page_model.dart';
import '../../core/utils/handle_dismiss_keyboard.dart';
import '../../generated/assets.dart';
import '../state/registration_cubit.dart';
import '../state/registration_state.dart';

class Registration extends StatelessWidget {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isRegistrationButtonEnable = false;
  bool isValidFieldName = false;
  bool isValidFieldEmail = false;
  bool isValidFieldPassword = false;
  bool isValidFieldPasswordConfirm = false;

  @override
  Widget build(BuildContext context) {
    return HandleDismissKeyboard(child: _buildUserRegistration(context));
  }

  Widget _buildUserRegistration(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          RegistrationCubit(Get.find<UserRepository>(), Get.arguments),
      child: BlocListener<RegistrationCubit, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            AppRoutes.showThankYouPage(
                context,
                ThankYouPage(
                  model: ThankYouPageModel(
                    callbackIconBack: () {
                      AppRoutes.popUntilPrelogin();
                    },
                    thankYouPageTitle:
                        StringConstants.registrationThankYouPageTitle,
                    thankYouPageMessage:
                        StringConstants.registrationThankYouPageMessage,
                    image: Assets.imagesAppLogo,
                    thankYouPageButton: StringConstants.loginButton,
                    callbackConfirm: () {
                      AppRoutes.pushNamed(Routes.login);
                    },
                  ),
                ));
          } else if (state is RegistrationFailure) {
            context
                .read<RegistrationCubit>()
                .showErrorDialog(context, state.error);
          } else if (state is RegistrationLockSignUp) {
            isRegistrationButtonEnable = false;
          } else if (state is RegistrationUnlockSignUp) {
            isRegistrationButtonEnable = true;
          }
        },
        child: BlocBuilder<RegistrationCubit, RegistrationState>(
          builder: (context, state) {
            return _buildRegistrationWidget(context);
          },
        ),
      ),
    );
  }

  Widget _buildRegistrationWidget(BuildContext context) {
    return BaseWidget(
      navBarTitle: StringConstants.registrationTitle,
      navigationTitleColor: Colors.white,
      body: Listener(
        onPointerDown: (_) => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
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
                  StringConstants.registrationSubtitle,
                  align: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      TextFormFieldCustom(
                        labelText: StringConstants.fieldNameLabelText,
                        formFieldType: FormFieldCustomTypeEnum.text,
                        textEditingController: name,
                        hintText: StringConstants.fieldNameHintText,
                        onChanged: (isValid) =>
                            {isValidFieldName = isValid, checkForm(context)},
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextFormFieldCustom(
                        labelText: StringConstants.fieldEmailLabelText,
                        formFieldType: FormFieldCustomTypeEnum.email,
                        textEditingController: email,
                        hintText: StringConstants.fieldEmailHintText,
                        onChanged: (isValid) =>
                            {isValidFieldEmail = isValid, checkForm(context)},
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextFormFieldCustom(
                        labelText: StringConstants.fieldPasswordLabelText,
                        formFieldType: FormFieldCustomTypeEnum.password,
                        textEditingController: password,
                        hintText: StringConstants.fieldPasswordHintText,
                        onChanged: (isValid) => {
                          isValidFieldPassword = isValid,
                          checkForm(context)
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextFormFieldCustom(
                        labelText:
                            StringConstants.fieldConfirmPasswordLabelText,
                        formFieldType: FormFieldCustomTypeEnum.confirmPassword,
                        textEditingController: confirmPassword,
                        hintText: StringConstants.fieldConfirmPasswordHintText,
                        checkEditingControllerPassword: password,
                        onChanged: (isValid) => {
                          isValidFieldPasswordConfirm = isValid,
                          checkForm(context)
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                CustomButton(
                  text: StringConstants.registrationButtonText,
                  filled: isRegistrationButtonEnable,
                  onPressed: isRegistrationButtonEnable
                      ? () {
                          context.read<RegistrationCubit>().createUser(
                                UserModel(
                                  name: name.text.toString(),
                                  email: email.text.toString().toLowerCase(),
                                  password: password.text.toString(),
                                ),
                              );
                        }
                      : null,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ],
            ),
          ),
        ),
      ),
      isBackGestureEnabled: true,
      customBackAction: () async {
        AppRoutes.popUntilPrelogin();
      },
    );
  }

  void checkForm(BuildContext context) {
    if (name.text.isNotEmpty &&
        email.text.isNotEmpty &&
        password.text.isNotEmpty &&
        confirmPassword.text.isNotEmpty &&
        password.text == confirmPassword.text) {
      context.read<RegistrationCubit>().setButtonState(isValidFieldName &&
          isValidFieldEmail &&
          isValidFieldPassword &&
          isValidFieldPasswordConfirm);
    } else {
      context.read<RegistrationCubit>().lockSignUp();
    }
  }
}
