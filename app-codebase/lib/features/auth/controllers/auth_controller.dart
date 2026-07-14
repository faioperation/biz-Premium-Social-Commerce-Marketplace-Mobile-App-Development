import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_routes.dart';

enum UserRole { buyer, seller, guest }

class AuthController extends GetxController {
  final RxBool isAuthenticated = false.obs;
  final Rx<UserRole> userRole = UserRole.guest.obs;

  void switchRole(UserRole newRole, BuildContext context) {
    userRole.value = newRole;

    if (newRole == UserRole.seller) {
      context.go(AppRoutes.sellerDashboard);
    } else {
      context.go(AppRoutes.buyerHome);
    }
  }

  void logout(BuildContext context) {
    isAuthenticated.value = false;
    userRole.value = UserRole.guest;
    context.go('/login');
  }

  void login(UserRole role, BuildContext context) {
    isAuthenticated.value = true;
    userRole.value = role;
    if (role == UserRole.seller) {
      context.go(AppRoutes.sellerDashboard);
    } else {
      context.go(AppRoutes.buyerHome);
    }
  }
}
