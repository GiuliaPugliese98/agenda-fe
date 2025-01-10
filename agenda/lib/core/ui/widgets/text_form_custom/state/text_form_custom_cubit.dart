import 'package:agenda/core/ui/widgets/text_form_custom/state/text_form_custom_state.dart';
import '../../../../bloc/base_cubit.dart';

class TextFormFieldCustomCubit extends BaseCubit<TextFormFieldCustomState> {
  TextFormFieldCustomCubit() : super(PasswordVisibilityInitial());

  void togglePasswordVisibility() {
    emit(ChangePasswordVisibility(!state.passwordVisibility));
  }
}
