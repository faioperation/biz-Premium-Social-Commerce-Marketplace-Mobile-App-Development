import '../../../../core/network/network_service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkService _networkService;

  AuthRepositoryImpl(this._networkService);

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _networkService.post(
        ApiEndpoints.login,
        body: {
          'email': email,
          'password': password,
        },
      );
      
      if (response is Map<String, dynamic> && response.containsKey('data')) {
         final data = response['data'];
         // Usually you would save token here or return it
         return UserModel.fromJson(data['user'] ?? {});
      }
      
      // Temporary mock success for development until backend is connected
      return const UserModel(id: '1', email: 'admin@vango.live', name: 'Admin', role: 'ADMIN');
    } catch (e) {
      // For development, if API fails (since we have no real API yet), mock success:
      return UserModel(id: '1', email: email, name: 'Mock Admin', role: 'ADMIN');
      // throw e; // Uncomment this in production!
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _networkService.post(
        '/auth/forgot-password',
        body: {'email': email},
      );
    } catch (e) {
      // Mock success for development
    }
  }

  @override
  Future<void> resetPassword(String email, String code, String newPassword) async {
    try {
      await _networkService.post(
        '/auth/reset-password',
        body: {
          'email': email,
          'code': code,
          'password': newPassword,
        },
      );
    } catch (e) {
      // Mock success for development
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _networkService.post(ApiEndpoints.logout);
    } catch (_) {
      // Ignore network errors on logout, proceed to local clean up
    }
  }
}
