import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getUsers({int page = 1, int limit = 15, String? searchQuery});
  Future<UserEntity> getUserDetails(String id);
  Future<void> suspendUser(String id);
  Future<void> banUser(String id);
  Future<void> disableBidding(String id);
  Future<void> freezeWallet(String id);
}
