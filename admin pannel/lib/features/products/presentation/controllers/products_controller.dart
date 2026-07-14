import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';

import '../../../../core/mixins/page_lifecycle_mixin.dart';

class ProductsController extends GetxController with PageLifecycleMixin {
  final ProductRepository _repository;

  ProductsController(this._repository);

  final RxList<ProductEntity> products = <ProductEntity>[].obs;

  // Pagination & Filters
  int _currentPage = 1;
  final int _limit = 15;
  String _searchQuery = '';
  String _categoryFilter = 'All';
  String _statusFilter = 'All';

  final RxInt totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Replaced by onPageActivated in the UI
  }

  Future<void> _loadTotalCount() async {
    totalCount.value = await _repository.getTotalCount();
  }

  @override
  Future<void> fetchData({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      products.clear();
      await _loadTotalCount();
    }

    final newProducts = await _repository.getProducts(
      page: _currentPage,
      limit: _limit,
      searchQuery: _searchQuery,
      categoryFilter: _categoryFilter,
      statusFilter: _statusFilter,
    );

    if (isRefresh) {
      products.value = newProducts;
    } else {
      products.addAll(newProducts);
    }

    _currentPage++;
  }

  void onSearch(String query) {
    _searchQuery = query;
    onPageActivated(forceRefresh: true);
  }

  void onCategoryChanged(String? category) {
    if (category == null) return;
    _categoryFilter = category;
    onPageActivated(forceRefresh: true);
  }

  void onStatusChanged(String? status) {
    if (status == null) return;
    _statusFilter = status;
    onPageActivated(forceRefresh: true);
  }

  // Bulk Actions
  Future<void> bulkApprove(List<ProductEntity> selectedProducts) async {
    try {
      final ids = selectedProducts.map((p) => p.id).toList();
      await _repository.bulkApprove(ids);
      onPageActivated(forceRefresh: true);
      Get.snackbar('Success', '\${ids.length} products approved',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve products',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> bulkDisable(List<ProductEntity> selectedProducts) async {
    try {
      final ids = selectedProducts.map((p) => p.id).toList();
      await _repository.bulkDisable(ids);
      onPageActivated(forceRefresh: true);
      Get.snackbar('Success', '\${ids.length} products disabled',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to disable products',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
