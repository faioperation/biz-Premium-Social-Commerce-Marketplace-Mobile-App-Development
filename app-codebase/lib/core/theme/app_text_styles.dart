import 'package:flutter/material.dart';
import 'package:google_fonts/Google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static final TextStyle _baseFont = GoogleFonts.inter();

  static TextTheme get lightTextTheme => TextTheme(
    displayLarge: _baseFont.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.lightTextPrimary,
    ),
    displayMedium: _baseFont.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.lightTextPrimary,
    ),
    displaySmall: _baseFont.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.lightTextPrimary,
    ),
    headlineLarge: _baseFont.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.lightTextPrimary,
    ),
    headlineMedium: _baseFont.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextPrimary,
    ),
    titleLarge: _baseFont.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextPrimary,
    ),
    bodyLarge: _baseFont.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.lightTextPrimary,
    ),
    bodyMedium: _baseFont.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.lightTextSecondary,
    ),
    bodySmall: _baseFont.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.lightTextSecondary,
    ),
    labelLarge: _baseFont.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextPrimary,
    ),
    labelSmall: _baseFont.copyWith(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.lightTextSecondary,
    ),
  );

  static TextTheme get darkTextTheme => TextTheme(
    displayLarge: _baseFont.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.darkHeading,
    ),
    displayMedium: _baseFont.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.darkHeading,
    ),
    displaySmall: _baseFont.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.darkHeading,
    ),
    headlineLarge: _baseFont.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.darkHeading,
    ),
    headlineMedium: _baseFont.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.darkHeading,
    ),
    titleLarge: _baseFont.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTitle,
    ),
    bodyLarge: _baseFont.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.darkTextPrimary,
    ),
    bodyMedium: _baseFont.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.darkTextSecondary,
    ),
    bodySmall: _baseFont.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.darkTextSecondary,
    ),
    labelLarge: _baseFont.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ),
    labelSmall: _baseFont.copyWith(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextSecondary,
    ),
  );
}
