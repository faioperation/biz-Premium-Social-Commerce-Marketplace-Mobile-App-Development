import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A mixin designed to be used with GetxController to handle page lifecycle
/// data fetching, including automatic loading states, error states,
/// duplicate call prevention, and automatic retries.
mixin PageLifecycleMixin on GetxController {
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  
  int _retryCount = 0;
  final int _maxRetries = 3;

  /// Abstract method that subclasses must implement to fetch data.
  Future<void> fetchData({bool isRefresh = false});

  /// Triggered when the page becomes active.
  /// Place this in the StatefulWidget's initState().
  Future<void> onPageActivated({bool forceRefresh = false}) async {
    // Prevent duplicate calls if already loading
    if (isLoading.value) return;

    isLoading.value = true;
    error.value = '';

    try {
      await fetchData(isRefresh: forceRefresh);
      _retryCount = 0; // Reset on success
    } catch (e) {
      error.value = e.toString();
      
      if (_retryCount < _maxRetries) {
        _retryCount++;
        // Exponential backoff for retries: 2s, 4s, 8s
        final delaySeconds = 1 << _retryCount; 
        
        // Log retry attempt (could use a logger service in a real app)
        debugPrint('Failed to load data. Retrying in $delaySeconds seconds... (Attempt $_retryCount/$_maxRetries)');
        
        Timer(Duration(seconds: delaySeconds), () {
          // Reset loading state to allow retry call to proceed
          isLoading.value = false;
          onPageActivated(forceRefresh: forceRefresh);
        });
        
        // We return early here so isLoading remains true while we wait for the retry
        return; 
      } else {
        Get.snackbar(
          'Data Load Error', 
          'Failed to load data after $_maxRetries attempts. Please try again later.',
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
