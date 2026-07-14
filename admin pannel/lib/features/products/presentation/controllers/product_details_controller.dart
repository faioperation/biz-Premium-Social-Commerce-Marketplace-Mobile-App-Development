import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';

class ProductDetailsController extends GetxController {
  final ProductRepository _repository;

  ProductDetailsController(this._repository);

  final Rx<ProductEntity?> product = Rx<ProductEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> loadProduct(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      product.value = await _repository.getProductDetails(id);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approveProduct() async {
    if (product.value == null) return;
    try {
      await _repository.approveProduct(product.value!.id);
      product.value = product.value!.copyWith(status: 'approved');
      _showSuccess('Product approved successfully');
    } catch (e) {
      _showError('Failed to approve product');
    }
  }

  Future<void> rejectProduct() async {
    if (product.value == null) return;
    try {
      await _repository.rejectProduct(product.value!.id);
      product.value = product.value!.copyWith(status: 'rejected');
      _showSuccess('Product rejected');
    } catch (e) {
      _showError('Failed to reject product');
    }
  }

  Future<void> disableProduct() async {
    if (product.value == null) return;
    try {
      await _repository.disableProduct(product.value!.id);
      product.value = product.value!.copyWith(status: 'disabled');
      _showSuccess('Product disabled');
    } catch (e) {
      _showError('Failed to disable product');
    }
  }

  Future<void> featureProduct() async {
    if (product.value == null) return;
    try {
      await _repository.featureProduct(product.value!.id);
      product.value = product.value!.copyWith(status: 'featured', isFeatured: true);
      _showSuccess('Product featured successfully');
    } catch (e) {
      _showError('Failed to feature product');
    }
  }

  void _showSuccess(String message) {
    Get.snackbar('Success', message,
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  void _showError(String message) {
    Get.snackbar('Error', message,
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}
