import '../../../../core/network/network_service.dart';
import '../../domain/entities/seller_entity.dart';
import '../../domain/repositories/seller_repository.dart';
import '../models/seller_model.dart';

class SellerRepositoryImpl implements SellerRepository {
  // ignore: unused_field
  final NetworkService _networkService;

  SellerRepositoryImpl(this._networkService);

  // MOCK DATA
  static final List<SellerModel> _mockSellers = List.generate(50, (index) {
    return SellerModel(
      id: 'sel_${index + 1}',
      shopName: 'Shop ${index + 1} Official',
      ownerName: 'Owner ${index + 1}',
      email: 'shop${index + 1}@example.com',
      phone: '+1 800-00${index.toString().padLeft(2, '0')}',
      logoUrl: 'https://i.pravatar.cc/150?img=${(index % 70) + 1}',
      joinedAt: DateTime.now().subtract(Duration(days: index * 5)),
      status: index % 7 == 0 ? 'suspended' : (index % 12 == 0 ? 'pending' : 'active'),
      kycStatus: index % 6 == 0 ? 'pending' : (index % 10 == 0 ? 'rejected' : 'approved'),
      rating: 3.5 + (index % 15) / 10, // 3.5 to 4.9
      followers: index * 125 + 50,
      totalRevenue: (index * 1500.5) + 1000,
      totalSales: index * 45 + 10,
      conversionRate: 1.5 + (index % 10) / 2, // 1.5% to 6.0%
      payoutsFrozen: index % 15 == 0,
      livestreamsDisabled: index % 20 == 0,
      auctionsDisabled: index % 18 == 0,
    );
  });

  @override
  Future<List<SellerEntity>> getSellers({int page = 1, int limit = 15, String? searchQuery}) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate latency
    
    List<SellerModel> filtered = _mockSellers;
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = _mockSellers.where((s) => 
        s.shopName.toLowerCase().contains(query) || 
        s.email.toLowerCase().contains(query)
      ).toList();
    }

    final startIndex = (page - 1) * limit;
    if (startIndex >= filtered.length) return [];
    
    final endIndex = (startIndex + limit) > filtered.length ? filtered.length : (startIndex + limit);
    return filtered.sublist(startIndex, endIndex);
  }

  @override
  Future<SellerEntity> getSellerDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockSellers.firstWhere((s) => s.id == id, orElse: () => throw Exception('Seller not found'));
  }

  @override
  Future<void> reviewKyc(String id, bool isApproved) async {
    await _updateSeller(id, {'kycStatus': isApproved ? 'approved' : 'rejected'});
  }

  @override
  Future<void> approveSeller(String id) async {
    await _updateSeller(id, {'status': 'active'});
  }

  @override
  Future<void> rejectSeller(String id) async {
    await _updateSeller(id, {'status': 'rejected'});
  }

  @override
  Future<void> suspendSeller(String id) async {
    await _updateSeller(id, {'status': 'suspended'});
  }

  @override
  Future<void> freezePayouts(String id) async {
    await _updateSeller(id, {'payoutsFrozen': true});
  }

  @override
  Future<void> disableLivestreams(String id) async {
    await _updateSeller(id, {'livestreamsDisabled': true});
  }

  @override
  Future<void> disableAuctions(String id) async {
    await _updateSeller(id, {'auctionsDisabled': true});
  }

  Future<void> _updateSeller(String id, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockSellers.indexWhere((s) => s.id == id);
    if (index != -1) {
      final current = _mockSellers[index];
      _mockSellers[index] = SellerModel.fromJson({
        'id': current.id,
        'shopName': current.shopName,
        'ownerName': current.ownerName,
        'email': current.email,
        'phone': current.phone,
        'logoUrl': current.logoUrl,
        'joinedAt': current.joinedAt.toIso8601String(),
        'status': updates['status'] ?? current.status,
        'kycStatus': updates['kycStatus'] ?? current.kycStatus,
        'rating': current.rating,
        'followers': current.followers,
        'totalRevenue': current.totalRevenue,
        'totalSales': current.totalSales,
        'conversionRate': current.conversionRate,
        'payoutsFrozen': updates['payoutsFrozen'] ?? current.payoutsFrozen,
        'livestreamsDisabled': updates['livestreamsDisabled'] ?? current.livestreamsDisabled,
        'auctionsDisabled': updates['auctionsDisabled'] ?? current.auctionsDisabled,
      });
    }
  }
}
