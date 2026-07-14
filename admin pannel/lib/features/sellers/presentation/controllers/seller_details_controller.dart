import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/seller_entity.dart';
import '../../domain/repositories/seller_repository.dart';

class SellerDetailsController extends GetxController {
  final SellerRepository _repository;
  
  SellerDetailsController(this._repository);

  final Rx<SellerEntity?> seller = Rx<SellerEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> loadSeller(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      seller.value = await _repository.getSellerDetails(id);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // KYC
  Future<void> reviewKyc(bool isApproved) async {
    if (seller.value == null) return;
    try {
      await _repository.reviewKyc(seller.value!.id, isApproved);
      seller.value = seller.value!.copyWith(kycStatus: isApproved ? 'approved' : 'rejected');
      _showSuccess("KYC ${isApproved ? 'Approved' : 'Rejected'}");
    } catch (e) {
      _showError('Failed to review KYC');
    }
  }

  // Admin Actions
  Future<void> approveSeller() async {
    if (seller.value == null) return;
    try {
      await _repository.approveSeller(seller.value!.id);
      seller.value = seller.value!.copyWith(status: 'active');
      _showSuccess('Seller approved successfully');
    } catch (e) {
      _showError('Failed to approve seller');
    }
  }

  Future<void> rejectSeller() async {
    if (seller.value == null) return;
    try {
      await _repository.rejectSeller(seller.value!.id);
      seller.value = seller.value!.copyWith(status: 'rejected');
      _showSuccess('Seller rejected');
    } catch (e) {
      _showError('Failed to reject seller');
    }
  }

  Future<void> suspendSeller() async {
    if (seller.value == null) return;
    try {
      await _repository.suspendSeller(seller.value!.id);
      seller.value = seller.value!.copyWith(status: 'suspended');
      _showSuccess('Seller suspended');
    } catch (e) {
      _showError('Failed to suspend seller');
    }
  }

  Future<void> freezePayouts() async {
    if (seller.value == null) return;
    try {
      await _repository.freezePayouts(seller.value!.id);
      seller.value = seller.value!.copyWith(payoutsFrozen: true);
      _showSuccess('Payouts frozen');
    } catch (e) {
      _showError('Failed to freeze payouts');
    }
  }

  Future<void> disableLivestreams() async {
    if (seller.value == null) return;
    try {
      await _repository.disableLivestreams(seller.value!.id);
      seller.value = seller.value!.copyWith(livestreamsDisabled: true);
      _showSuccess('Livestreams disabled');
    } catch (e) {
      _showError('Failed to disable livestreams');
    }
  }

  Future<void> disableAuctions() async {
    if (seller.value == null) return;
    try {
      await _repository.disableAuctions(seller.value!.id);
      seller.value = seller.value!.copyWith(auctionsDisabled: true);
      _showSuccess('Auctions disabled');
    } catch (e) {
      _showError('Failed to disable auctions');
    }
  }

  void _showSuccess(String message) {
    Get.snackbar('Success', message, backgroundColor: Colors.green, colorText: Colors.white);
  }

  void _showError(String message) {
    Get.snackbar('Error', message, backgroundColor: Colors.red, colorText: Colors.white);
  }
}
