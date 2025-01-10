import '../../../../bloc/base_cubit.dart';
import '../../../../bloc/base_state.dart';

part 'thank_you_page_state.dart';

class ThankYouPageCubit extends BaseCubit<ThankYouPageState> {
  ThankYouPageCubit() : super(ThankYouPageInitial());
}
