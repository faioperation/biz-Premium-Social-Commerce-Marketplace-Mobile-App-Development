import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../controllers/forgot_password_controller.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/widgets/glowing_floating_logo.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  Timer? _timer;
  int _secondsRemaining = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void _restartTimer() {
    _timer?.cancel();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: isDark ? AppColors.darkTextPrimary : const Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppColors.primary.withValues(alpha: 0.05),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.edgeInsetsAllLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const Center(
                child: GlowingFloatingLogo(
                  imagePath: AppImages.logo,
                  size: 100.0,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Enter 6-Digit OTP',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Description
              Text(
                'We have sent a verification code to your email.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.darkDescription : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Pin Input Fields
              Center(
                child: Pinput(
                  length: 6,
                  controller: controller.otpController,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  autofocus: true,
                  showCursor: true,
                  onCompleted: (pin) => controller.verifyOtp(context),
                ),
              ),

              const SizedBox(height: 24),

              // Countdown Timer Expiry
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: _secondsRemaining > 0 ? AppColors.accentPink : AppColors.error,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _secondsRemaining > 0
                        ? 'Expires in 00:${_secondsRemaining.toString().padLeft(2, '0')}'
                        : 'Code expired',
                    style: TextStyle(
                      color: _secondsRemaining > 0 ? AppColors.accentPink : AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Verify Button
              Obx(
                () => ElevatedButton(
                  onPressed: (controller.isLoading.value || _secondsRemaining == 0)
                      ? null
                      : () => controller.verifyOtp(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Verify OTP',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Resend Code (active only after expiration)
              Center(
                child: TextButton(
                  onPressed: _secondsRemaining == 0
                      ? () {
                          _restartTimer();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'A new verification code has been sent to your email!',
                              ),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      : null,
                  child: Text(
                    'Resend Code',
                    style: TextStyle(
                      color: _secondsRemaining == 0
                          ? AppColors.primary
                          : (isDark ? Colors.white30 : Colors.black26),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
