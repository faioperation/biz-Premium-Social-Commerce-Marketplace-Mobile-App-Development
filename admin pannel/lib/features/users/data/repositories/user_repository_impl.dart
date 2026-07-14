import '../../../../core/network/network_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  // ignore: unused_field
  final NetworkService _networkService;

  UserRepositoryImpl(this._networkService);

  // MOCK DATA for development
  static final List<UserModel> _mockUsers = List.generate(50, (index) {
    return UserModel(
      id: 'usr_${index + 1}',
      name: 'User ${index + 1}',
      email: 'user${index + 1}@example.com',
      phone: '+1 555-01${index.toString().padLeft(2, '0')}',
      status: index % 5 == 0 ? (index % 10 == 0 ? 'banned' : 'suspended') : 'active',
      walletBalance: (index * 15.5) + 100,
      isBiddingDisabled: index % 8 == 0,
      joinedAt: DateTime.now().subtract(Duration(days: index * 3)),
      avatarUrl: 'https://i.pravatar.cc/150?img=${(index % 70) + 1}',
    );
  });

  @override
  Future<List<UserEntity>> getUsers({int page = 1, int limit = 15, String? searchQuery}) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate latency
    
    List<UserModel> filtered = _mockUsers;
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = _mockUsers.where((u) => 
        u.name.toLowerCase().contains(query) || 
        u.email.toLowerCase().contains(query)
      ).toList();
    }

    final startIndex = (page - 1) * limit;
    if (startIndex >= filtered.length) return [];
    
    final endIndex = (startIndex + limit) > filtered.length ? filtered.length : (startIndex + limit);
    return filtered.sublist(startIndex, endIndex);
  }

  @override
  Future<UserEntity> getUserDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final user = _mockUsers.firstWhere((u) => u.id == id, orElse: () => throw Exception('User not found'));
    return user;
  }

  @override
  Future<void> suspendUser(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockUsers.indexWhere((u) => u.id == id);
    if (index != -1) {
      _mockUsers[index] = UserModel.fromJson({
        ..._mockUserToJson(_mockUsers[index]),
        'status': 'suspended',
      });
    }
  }

  @override
  Future<void> banUser(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockUsers.indexWhere((u) => u.id == id);
    if (index != -1) {
      _mockUsers[index] = UserModel.fromJson({
        ..._mockUserToJson(_mockUsers[index]),
        'status': 'banned',
      });
    }
  }

  @override
  Future<void> disableBidding(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockUsers.indexWhere((u) => u.id == id);
    if (index != -1) {
      _mockUsers[index] = UserModel.fromJson({
        ..._mockUserToJson(_mockUsers[index]),
        'isBiddingDisabled': true,
      });
    }
  }

  @override
  Future<void> freezeWallet(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Implementation for freezing wallet would go here
    // Currently, we don't have a specific field for frozen wallet in the mock model
  }

  // Helper for mock updates
  Map<String, dynamic> _mockUserToJson(UserModel user) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'status': user.status,
      'walletBalance': user.walletBalance,
      'isBiddingDisabled': user.isBiddingDisabled,
      'joinedAt': user.joinedAt.toIso8601String(),
      'avatarUrl': user.avatarUrl,
    };
  }
}
