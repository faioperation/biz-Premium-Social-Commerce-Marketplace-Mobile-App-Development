import '../entities/seller_entity.dart';

abstract class SellerRepository {
  Future<List<SellerEntity>> getSellers({int page = 1, int limit = 15, String? searchQuery});
  Future<SellerEntity> getSellerDetails(String id);
  
  // KYC & Verification
  Future<void> reviewKyc(String id, bool isApproved);
  
  // Admin Actions
  Future<void> approveSeller(String id);
  Future<void> rejectSeller(String id);
  Future<void> suspendSeller(String id);
  Future<void> freezePayouts(String id);
  Future<void> disableLivestreams(String id);
  Future<void> disableAuctions(String id);
}
