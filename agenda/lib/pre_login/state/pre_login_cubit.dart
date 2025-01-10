import '../../core/bloc/base_cubit.dart';
import '../../core/bloc/base_state.dart';

part 'pre_login_state.dart';

class PreLoginCubit extends BaseCubit<PreLoginState> {
  PreLoginCubit() : super(PreLoginState());

  void callbackOk()async {
  }

  void callbackKo()async {
  }
}
