import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  final RxBool isLoading = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  bool get isAuthenticated => currentUser.value != null;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final user = await _authRepository.login(email, password);
      currentUser.value = user;
      
      // Navigate to dashboard
      Get.context?.go(RouteNames.dashboard);
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      isLoading.value = true;
      await _authRepository.forgotPassword(email);
      Get.snackbar('Success', 'Password reset instructions sent to $email');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email, String code, String newPassword) async {
    try {
      isLoading.value = true;
      await _authRepository.resetPassword(email, code, newPassword);
      Get.snackbar('Success', 'Password reset successfully');
      Get.context?.go(RouteNames.login);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _authRepository.logout();
    } finally {
      currentUser.value = null;
      isLoading.value = false;
      Get.context?.go(RouteNames.login);
    }
  }
}
