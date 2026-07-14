import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts({
    int page = 1,
    int limit = 15,
    String? searchQuery,
    String? categoryFilter,
    String? statusFilter,
  });
  Future<int> getTotalCount();
  Future<ProductEntity> getProductDetails(String id);

  // Admin Actions
  Future<void> approveProduct(String id);
  Future<void> rejectProduct(String id);
  Future<void> disableProduct(String id);
  Future<void> featureProduct(String id);

  // Bulk Actions
  Future<void> bulkApprove(List<String> ids);
  Future<void> bulkDisable(List<String> ids);
}
