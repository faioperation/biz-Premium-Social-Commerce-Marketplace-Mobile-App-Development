import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/security_settings_entity.dart';
import '../controllers/settings_controller.dart';
import 'settings_section.dart';

class SecuritySettingsPanel extends StatefulWidget {
  final SettingsController controller;
  final SecuritySettingsEntity settings;

  const SecuritySettingsPanel({
    super.key,
    required this.controller,
    required this.settings,
  });

  @override
  State<SecuritySettingsPanel> createState() => _SecuritySettingsPanelState();
}

class _SecuritySettingsPanelState extends State<SecuritySettingsPanel> {
  final _formKey = GlobalKey<FormState>();

  late int _minPasswordLength;
  late bool _requireUppercase;
  late bool _requireNumbers;
  late bool _requireSpecialChars;
  late int _passwordExpiryDays;
  late int _maxLoginAttempts;
  late int _lockoutDurationMinutes;
  late bool _enableTwoFactor;
  late int _otpExpirySeconds;
  late int _otpLength;
  late bool _allowSmsOtp;
  late bool _allowEmailOtp;
  late bool _enforceAdminIpWhitelist;

  final _minPwdCtrl = TextEditingController();
  final _pwdExpiryCtrl = TextEditingController();
  final _maxAttemptsCtrl = TextEditingController();
  final _lockoutCtrl = TextEditingController();
  final _otpExpiryCtrl = TextEditingController();
  final _otpLengthCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final s = widget.settings;
    _minPasswordLength = s.minPasswordLength;
    _requireUppercase = s.requireUppercase;
    _requireNumbers = s.requireNumbers;
    _requireSpecialChars = s.requireSpecialChars;
    _passwordExpiryDays = s.passwordExpiryDays;
    _maxLoginAttempts = s.maxLoginAttempts;
    _lockoutDurationMinutes = s.lockoutDurationMinutes;
    _enableTwoFactor = s.enableTwoFactor;
    _otpExpirySeconds = s.otpExpirySeconds;
    _otpLength = s.otpLength;
    _allowSmsOtp = s.allowSmsOtp;
    _allowEmailOtp = s.allowEmailOtp;
    _enforceAdminIpWhitelist = s.enforceAdminIpWhitelist;

    _minPwdCtrl.text = _minPasswordLength.toString();
    _pwdExpiryCtrl.text = _passwordExpiryDays.toString();
    _maxAttemptsCtrl.text = _maxLoginAttempts.toString();
    _lockoutCtrl.text = _lockoutDurationMinutes.toString();
    _otpExpiryCtrl.text = _otpExpirySeconds.toString();
    _otpLengthCtrl.text = _otpLength.toString();
  }

  @override
  void dispose() {
    _minPwdCtrl.dispose();
    _pwdExpiryCtrl.dispose();
    _maxAttemptsCtrl.dispose();
    _lockoutCtrl.dispose();
    _otpExpiryCtrl.dispose();
    _otpLengthCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final updated = widget.settings.copyWith(
      minPasswordLength: int.tryParse(_minPwdCtrl.text) ?? _minPasswordLength,
      requireUppercase: _requireUppercase,
      requireNumbers: _requireNumbers,
      requireSpecialChars: _requireSpecialChars,
      passwordExpiryDays: int.tryParse(_pwdExpiryCtrl.text) ?? _passwordExpiryDays,
      maxLoginAttempts: int.tryParse(_maxAttemptsCtrl.text) ?? _maxLoginAttempts,
      lockoutDurationMinutes: int.tryParse(_lockoutCtrl.text) ?? _lockoutDurationMinutes,
      enableTwoFactor: _enableTwoFactor,
      otpExpirySeconds: int.tryParse(_otpExpiryCtrl.text) ?? _otpExpirySeconds,
      otpLength: int.tryParse(_otpLengthCtrl.text) ?? _otpLength,
      allowSmsOtp: _allowSmsOtp,
      allowEmailOtp: _allowEmailOtp,
      enforceAdminIpWhitelist: _enforceAdminIpWhitelist,
    );
    final ok = await widget.controller.saveSecuritySettings(updated);
    if (ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Security settings saved.'), backgroundColor: AppColors.success),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // ── Password Policy ──
          SettingsSection(
            title: 'Password Policy',
            subtitle: 'Enforce strong passwords for all users',
            icon: Icons.lock_outline,
            iconColor: AppColors.error,
            children: [
              SettingsFormRow(
                label: 'Minimum Password Length',
                hint: 'Characters required (min: 6, max: 32)',
                field: TextFormField(
                  controller: _minPwdCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDeco('e.g. 8'),
                  validator: (v) {
                    final n = int.tryParse(v ?? '');
                    if (n == null) return 'Enter a valid number';
                    if (n < 6 || n > 32) return 'Must be between 6 and 32';
                    return null;
                  },
                ),
              ),
              SettingsFormRow(
                label: 'Password Expiry (days)',
                hint: 'Set to 0 to disable expiry',
                field: TextFormField(
                  controller: _pwdExpiryCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDeco('e.g. 90'),
                  validator: (v) => (int.tryParse(v ?? '') == null) ? 'Enter a valid number' : null,
                ),
              ),
              SettingsToggleRow(
                label: 'Require Uppercase Letter',
                value: _requireUppercase,
                onChanged: (v) => setState(() => _requireUppercase = v),
              ),
              SettingsToggleRow(
                label: 'Require Numbers',
                value: _requireNumbers,
                onChanged: (v) => setState(() => _requireNumbers = v),
              ),
              SettingsToggleRow(
                label: 'Require Special Characters',
                hint: 'e.g. !@#\$%^&*',
                value: _requireSpecialChars,
                onChanged: (v) => setState(() => _requireSpecialChars = v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── OTP Configuration ──
          SettingsSection(
            title: 'OTP Configuration',
            subtitle: 'One-time password settings for 2FA and verification',
            icon: Icons.pin_outlined,
            iconColor: AppColors.primary,
            children: [
              SettingsToggleRow(
                label: 'Enable Two-Factor Authentication',
                hint: 'Required for all admin accounts',
                value: _enableTwoFactor,
                onChanged: (v) => setState(() => _enableTwoFactor = v),
              ),
              SettingsFormRow(
                label: 'OTP Length',
                hint: 'Number of digits (4 or 6)',
                field: DropdownButtonFormField<int>(
                  initialValue: _otpLength,
                  decoration: _inputDeco(null),
                  items: [4, 6].map((n) => DropdownMenuItem(value: n, child: Text('$n digits'))).toList(),
                  onChanged: (v) => setState(() => _otpLength = v ?? _otpLength),
                ),
              ),
              SettingsFormRow(
                label: 'OTP Expiry (seconds)',
                hint: 'OTP becomes invalid after this duration',
                field: TextFormField(
                  controller: _otpExpiryCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDeco('e.g. 300'),
                  validator: (v) => (int.tryParse(v ?? '') == null) ? 'Enter a valid number' : null,
                ),
              ),
              SettingsToggleRow(
                label: 'Allow SMS OTP',
                value: _allowSmsOtp,
                onChanged: (v) => setState(() => _allowSmsOtp = v),
              ),
              SettingsToggleRow(
                label: 'Allow Email OTP',
                value: _allowEmailOtp,
                onChanged: (v) => setState(() => _allowEmailOtp = v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Login Restrictions ──
          SettingsSection(
            title: 'Login Restrictions',
            subtitle: 'Prevent brute force and unauthorised access',
            icon: Icons.no_encryption_gmailerrorred_outlined,
            iconColor: AppColors.warning,
            children: [
              SettingsFormRow(
                label: 'Max Login Attempts',
                hint: 'Account locks after this many consecutive failures',
                field: TextFormField(
                  controller: _maxAttemptsCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDeco('e.g. 5'),
                  validator: (v) => (int.tryParse(v ?? '') == null) ? 'Enter a valid number' : null,
                ),
              ),
              SettingsFormRow(
                label: 'Lockout Duration (mins)',
                hint: 'How long the account remains locked',
                field: TextFormField(
                  controller: _lockoutCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDeco('e.g. 30'),
                  validator: (v) => (int.tryParse(v ?? '') == null) ? 'Enter a valid number' : null,
                ),
              ),
              SettingsToggleRow(
                label: 'Enforce Admin IP Whitelist',
                hint: 'Only whitelisted IPs can access the admin panel',
                value: _enforceAdminIpWhitelist,
                onChanged: (v) => setState(() => _enforceAdminIpWhitelist = v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: 'Save Security Settings',
                icon: Icons.security,
                isLoading: widget.controller.isSaving.value,
                onPressed: () => _save(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDeco(String? hint) => InputDecoration(
    hintText: hint,
    border: const OutlineInputBorder(),
    isDense: true,
    filled: true,
  );
}
