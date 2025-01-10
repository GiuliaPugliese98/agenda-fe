import 'package:flutter_bloc/flutter_bloc.dart';
import '../costants/string_constants.dart';
import '../enums/alert_dialog_enum.dart';
import '../ui/app_routes/routes.dart';
import '../ui/widgets/alert_dialog/view/alert_dialog.dart';
import 'base_state.dart';

abstract class BaseCubit<S extends BaseState> extends Cubit<S> {

  BaseCubit(S initialState) : super(initialState);


  void showAlertError( String message, {
    Function()? callbackConfirmButton,
    Function()? callbackUndoButton,
    Function()? callbackBackButton,
    bool showImageAlert = true,
    bool confirmButton = false
  } ) {
    AppRoutes.showCustomDialog(AlertDialogPage(
        title: StringConstants.generic_error_title,
        message: message,
        callbackConfirm: callbackConfirmButton,
        callbackUndo: callbackUndoButton,
        callbackBackButton: callbackBackButton,
        showImage: showImageAlert,
        state: StateAlert.error)
    );
  }
}
