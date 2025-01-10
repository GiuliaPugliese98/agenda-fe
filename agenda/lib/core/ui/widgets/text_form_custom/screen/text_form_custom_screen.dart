import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../enums/form_field_custom_type_enum.dart';
import '../../form_field_abstract/view/form_field_abstract.dart';
import '../state/text_form_custom_cubit.dart';
import '../state/text_form_custom_state.dart';
import '../../../../utils/validator_utils.dart';

class TextFormFieldCustom extends FormFieldAbstract {
  TextEditingController? textEditingController;
  ValueChanged<bool>? onChanged;

  TextFormFieldCustom({
    Key? key,
    required String? labelText,
    required FormFieldCustomTypeEnum? formFieldType,
    required String? hintText,
    this.textEditingController,
    this.onChanged,
    TextEditingController? checkEditingControllerPassword,
  }) : super(
          key: key,
          labelText: labelText,
          formFieldType: formFieldType,
          hintText: hintText,
          checkEditingControllerPassword: checkEditingControllerPassword,
        );

  @override
  FormFieldAbstractState<TextFormFieldCustom> getConcreteState() =>
      _TextFormFieldCustomState();
}

class _TextFormFieldCustomState
    extends FormFieldAbstractState<TextFormFieldCustom> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TextFormFieldCustomCubit(),
      child: BlocListener<TextFormFieldCustomCubit, TextFormFieldCustomState>(
        listener: (context, state) {},
        child: BlocBuilder<TextFormFieldCustomCubit, TextFormFieldCustomState>(
          builder: (context, state) {
            return TextFormField(
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(!isError);
                }
                validate(value);
              },
              controller: widget.textEditingController,
              decoration: getInputDecorationPassword(context, state).copyWith(
                errorText: isError
                    ? getValidator(widget.textEditingController?.text)
                    : null,
              ),
              keyboardType: getKeyboardType(),
              style: getTextStyle(),
              obscureText:
                  (widget.formFieldType == FormFieldCustomTypeEnum.password ||
                          widget.formFieldType ==
                              FormFieldCustomTypeEnum.confirmPassword) &&
                      !state.passwordVisibility,
            );
          },
        ),
      ),
    );
  }

  @override
  String? getValidator(String? value) {
    switch (widget.formFieldType) {
      case FormFieldCustomTypeEnum.text:
        return ValidatorUtils.validateText(value);
      case FormFieldCustomTypeEnum.password:
        return ValidatorUtils.validatePassword(value);
      case FormFieldCustomTypeEnum.confirmPassword:
        return ValidatorUtils.validateConfirmPassword(
            value, widget.checkEditingControllerPassword);
      case FormFieldCustomTypeEnum.email:
        return ValidatorUtils.validateEmail(value);
      default:
        return null;
    }
  }

  @override
  void validate(String? value) {
    super.validate(value);
    if (widget.onChanged != null) {
      widget.onChanged!(!isError);
    }
  }

}
