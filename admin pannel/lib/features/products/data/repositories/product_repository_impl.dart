import '../../../../core/network/network_service.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  // ignore: unused_field
  final NetworkService _networkService;

  ProductRepositoryImpl(this._networkService);

  static const _categories = [
    'Electronics', 'Fashion', 'Home & Garden', 'Sports',
    'Beauty', 'Books', 'Toys', 'Automotive',
  ];

  static const _statuses = ['pending', 'approved', 'rejected', 'disabled', 'featured'];

  static final List<ProductModel> _mockProducts = List.generate(80, (index) {
    final catIndex = index % _categories.length;
    final statusIndex = index % 6 == 0 ? 1 : (index % 8 == 0 ? 2 : (index % 12 == 0 ? 3 : 0));
    return ProductModel(
      id: 'prod_${index + 1}',
      name: '${_categories[catIndex]} Product ${index + 1}',
      description: 'This is a high-quality product from the ${_categories[catIndex]} category. '
          'It is designed to meet the highest standards of performance and durability.',
      category: _categories[catIndex],
      price: 9.99 + (index * 12.5),
      stock: index % 3 == 0 ? 0 : (index * 7 + 10),
      status: _statuses[statusIndex < _statuses.length ? statusIndex : 0],
      sellerId: 'sel_${(index % 20) + 1}',
      sellerName: 'Owner ${(index % 20) + 1}',
      sellerShopName: 'Shop ${(index % 20) + 1} Official',
      imageUrls: [
        'https://picsum.photos/seed/${index + 1}/400/400',
        'https://picsum.photos/seed/${index + 100}/400/400',
        'https://picsum.photos/seed/${index + 200}/400/400',
      ],
      rating: 3.0 + (index % 20) / 10,
      reviewCount: index * 5 + 3,
      isFeatured: index % 10 == 0,
      createdAt: DateTime.now().subtract(Duration(days: index * 2)),
    );
  });

  @override
  Future<List<ProductEntity>> getProducts({
    int page = 1,
    int limit = 15,
    String? searchQuery,
    String? categoryFilter,
    String? statusFilter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    List<ProductModel> filtered = List.from(_mockProducts);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      filtered = filtered.where((p) => p.name.toLowerCase().contains(q)).toList();
    }
    if (categoryFilter != null && categoryFilter.isNotEmpty && categoryFilter != 'All') {
      filtered = filtered.where((p) => p.category == categoryFilter).toList();
    }
    if (statusFilter != null && statusFilter.isNotEmpty && statusFilter != 'All') {
      filtered = filtered.where((p) => p.status == statusFilter).toList();
    }

    final start = (page - 1) * limit;
    if (start >= filtered.length) return [];
    final end = (start + limit).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  @override
  Future<int> getTotalCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockProducts.length;
  }

  @override
  Future<ProductEntity> getProductDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockProducts.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Product not found'),
    );
  }

  @override
  Future<void> approveProduct(String id) => _updateProduct(id, {'status': 'approved'});

  @override
  Future<void> rejectProduct(String id) => _updateProduct(id, {'status': 'rejected'});

  @override
  Future<void> disableProduct(String id) => _updateProduct(id, {'status': 'disabled'});

  @override
  Future<void> featureProduct(String id) =>
      _updateProduct(id, {'status': 'featured', 'isFeatured': true});

  @override
  Future<void> bulkApprove(List<String> ids) async {
    for (final id in ids) {
      await _updateProduct(id, {'status': 'approved'});
    }
  }

  @override
  Future<void> bulkDisable(List<String> ids) async {
    for (final id in ids) {
      await _updateProduct(id, {'status': 'disabled'});
    }
  }

  Future<void> _updateProduct(String id, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockProducts.indexWhere((p) => p.id == id);
    if (index != -1) {
      final cur = _mockProducts[index];
      _mockProducts[index] = ProductModel.fromJson({
        'id': cur.id,
        'name': cur.name,
        'description': cur.description,
        'category': cur.category,
        'price': cur.price,
        'stock': cur.stock,
        'status': updates['status'] ?? cur.status,
        'sellerId': cur.sellerId,
        'sellerName': cur.sellerName,
        'sellerShopName': cur.sellerShopName,
        'imageUrls': cur.imageUrls,
        'rating': cur.rating,
        'reviewCount': cur.reviewCount,
        'isFeatured': updates['isFeatured'] ?? cur.isFeatured,
        'createdAt': cur.createdAt.toIso8601String(),
      });
    }
  }
}
