import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';

class UserDetailsController extends GetxController {
  final UserRepository _repository;
  
  UserDetailsController(this._repository);

  final Rx<UserEntity?> user = Rx<UserEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> loadUser(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      user.value = await _repository.getUserDetails(id);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> suspendUser() async {
    if (user.value == null) return;
    try {
      await _repository.suspendUser(user.value!.id);
      user.value = user.value!.copyWith(status: 'suspended');
      _showSuccess('User suspended successfully');
    } catch (e) {
      _showError('Failed to suspend user');
    }
  }

  Future<void> banUser() async {
    if (user.value == null) return;
    try {
      await _repository.banUser(user.value!.id);
      user.value = user.value!.copyWith(status: 'banned');
      _showSuccess('User banned successfully');
    } catch (e) {
      _showError('Failed to ban user');
    }
  }

  Future<void> disableBidding() async {
    if (user.value == null) return;
    try {
      await _repository.disableBidding(user.value!.id);
      user.value = user.value!.copyWith(isBiddingDisabled: true);
      _showSuccess('Bidding disabled for user');
    } catch (e) {
      _showError('Failed to disable bidding');
    }
  }

  Future<void> freezeWallet() async {
    if (user.value == null) return;
    try {
      await _repository.freezeWallet(user.value!.id);
      _showSuccess('Wallet frozen successfully');
    } catch (e) {
      _showError('Failed to freeze wallet');
    }
  }

  void _showSuccess(String message) {
    Get.snackbar('Success', message, backgroundColor: Colors.green, colorText: Colors.white);
  }

  void _showError(String message) {
    Get.snackbar('Error', message, backgroundColor: Colors.red, colorText: Colors.white);
  }
}
