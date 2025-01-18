import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../costants/string_constants.dart';
import '../enums/alert_dialog_enum.dart';
import '../ui/app_routes/routes.dart';
import '../ui/widgets/alert_dialog/view/alert_dialog.dart';
import 'base_state.dart';

abstract class BaseCubit<S extends BaseState> extends Cubit<S> {
  BaseCubit(S initialState) : super(initialState);

  void showAlertError(BuildContext context, String message,
      {Function()? callbackConfirmButton,
      Function()? callbackUndoButton,
      Function()? callbackBackButton,
      bool showImageAlert = true,
      bool confirmButton = false}) {
    AppRoutes.showCustomDialog(
        context,
        AlertDialogPage(
            title: StringConstants.generic_error_title,
            message: message,
            callbackConfirm: callbackConfirmButton,
            callbackUndo: callbackUndoButton,
            callbackBackButton: callbackBackButton,
            showImage: showImageAlert,
            state: StateAlert.error));
  }

  void showAlertSuccess(BuildContext context, String title, String message,
      String buttonTextConfirm,
      {Function()? callbackConfirmButton,
      Function()? callbackUndoButton,
      bool showImageAlert = true,
      bool confirmButton = false}) {
    AppRoutes.showCustomDialog(
        context,
        AlertDialogPage(
            title: title,
            message: message,
            buttonTextConfirm: buttonTextConfirm,
            state: StateAlert.success,
            callbackConfirm: callbackConfirmButton,
            callbackUndo: callbackUndoButton,
            callbackBackButton: callbackConfirmButton,
            showImage: showImageAlert));
  }
}
