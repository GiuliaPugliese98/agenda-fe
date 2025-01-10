import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../enums/form_field_custom_type_enum.dart';
import '../../../theme/app_colors.dart';
import '../../text_form_custom/state/text_form_custom_cubit.dart';
import '../../text_form_custom/state/text_form_custom_state.dart';

abstract class FormFieldAbstract extends StatefulWidget {
  final FormFieldCustomTypeEnum? formFieldType;
  final String? labelText;
  final String? hintText;
  final TextEditingController? checkEditingControllerPassword;

  const FormFieldAbstract(
      {Key? key,
      required this.labelText,
      required this.formFieldType,
      required this.hintText,
      this.checkEditingControllerPassword})
      : super(key: key);

  @override
  FormFieldAbstractState createState() => getConcreteState();

  FormFieldAbstractState getConcreteState();

}

abstract class FormFieldAbstractState<T extends FormFieldAbstract>
    extends State<T> {
  bool isError = false;

  TextStyle getInputDecorationTextStyle() {
    return TextStyle(
      fontStyle: FontStyle.italic,
      color: isError ? Colors.red : AppColors.blackText,
      fontWeight: FontWeight.w800,
    );
  }

  TextStyle getTextStyle() {
    return TextStyle(
      color: isError ? Colors.red : AppColors.blackText,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w300,
    );
  }

  TextStyle getTextHintStyle() {
    return const TextStyle(
      fontStyle: FontStyle.italic,
      color: AppColors.blackText,
      fontWeight: FontWeight.w100,
    );
  }

  InputDecoration getInputDecorationPassword(
      BuildContext context, TextFormFieldCustomState state) {
    return InputDecoration(
      errorMaxLines: 10,
      labelText: widget.labelText,
      labelStyle: getInputDecorationTextStyle(),
      hintText: widget.hintText,
      hintStyle: getTextHintStyle(),
      suffixIcon: widget.formFieldType == FormFieldCustomTypeEnum.password ||
              widget.formFieldType == FormFieldCustomTypeEnum.confirmPassword
          ? IconButton(
              icon: Icon(
                state.passwordVisibility
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColors.blackText,
              ),
              onPressed: () {
                context
                    .read<TextFormFieldCustomCubit>()
                    .togglePasswordVisibility();
              },
            )
          : null,
    );
  }

  TextInputType? getKeyboardType() {
    switch (widget.formFieldType) {
      case FormFieldCustomTypeEnum.text:
        return TextInputType.text;
      case FormFieldCustomTypeEnum.password:
        return TextInputType.text;
      case FormFieldCustomTypeEnum.confirmPassword:
        return TextInputType.text;
      case FormFieldCustomTypeEnum.email:
        return TextInputType.emailAddress;
      default:
        return TextInputType.none;
    }
  }

  void validate(String? value) {
    String? result = getValidator(value);
    setState(() {
      isError = result != null;
    });
  }

  String? getValidator(String? value);
}
