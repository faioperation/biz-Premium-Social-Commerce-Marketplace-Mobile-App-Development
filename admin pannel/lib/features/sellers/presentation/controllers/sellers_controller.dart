import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/seller_entity.dart';
import '../../domain/repositories/seller_repository.dart';

import '../../../../core/mixins/page_lifecycle_mixin.dart';

class SellersController extends GetxController with PageLifecycleMixin {
  final SellerRepository _repository;

  SellersController(this._repository);

  final RxList<SellerEntity> sellers = <SellerEntity>[].obs;

  // Pagination & Search
  int _currentPage = 1;
  final int _limit = 15;
  String _searchQuery = '';
  
  int totalCount = 50; // Mock total count

  @override
  void onInit() {
    super.onInit();
    // Replaced by onPageActivated in the UI
  }

  @override
  Future<void> fetchData({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      sellers.clear();
    }

    final newSellers = await _repository.getSellers(
      page: _currentPage,
      limit: _limit,
      searchQuery: _searchQuery,
    );

    if (isRefresh) {
      sellers.value = newSellers;
    } else {
      sellers.addAll(newSellers);
    }
    
    _currentPage++;
  }

  void onSearch(String query) {
    _searchQuery = query;
    onPageActivated(forceRefresh: true);
  }
}
