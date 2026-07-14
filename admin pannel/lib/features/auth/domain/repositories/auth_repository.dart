import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String email, String code, String newPassword);
  Future<void> logout();
}
