import 'package:get/get.dart';
import 'core/data/repository/event_repository.dart';
import 'core/data/repository/user_repository.dart';
import 'core/data/services/auth_service.dart';
import 'core/network/api_client.dart';

void initDependencies() {
  _initServices();
  _initRepositories();
}

void _initServices() {
  final AuthService authService = AuthService();
  Get.put<AuthService>(authService);

  final ApiClient apiClient = ApiClient(
    baseUrl: 'http://192.168.1.102:8080/',
    authService: authService,
  );
  Get.put<ApiClient>(apiClient);
}

void _initRepositories() {
  final AuthService authService = Get.find<AuthService>();
  final ApiClient apiClient = Get.find<ApiClient>();

  final UserRepository userRepository = UserRepository(apiClient, authService);
  final EventRepository eventRepository = EventRepository(apiClient);
  Get.put<UserRepository>(userRepository);
  Get.put<EventRepository>(eventRepository);
}