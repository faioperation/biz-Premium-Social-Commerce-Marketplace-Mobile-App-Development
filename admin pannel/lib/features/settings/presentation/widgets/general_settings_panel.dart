import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/general_settings_entity.dart';
import '../controllers/settings_controller.dart';
import 'settings_section.dart';
import '../../../../core/controllers/currency_controller.dart';
import '../../../../core/constants/currency_config.dart';

class GeneralSettingsPanel extends StatefulWidget {
  final SettingsController controller;
  final GeneralSettingsEntity settings;

  const GeneralSettingsPanel({
    super.key,
    required this.controller,
    required this.settings,
  });

  @override
  State<GeneralSettingsPanel> createState() => _GeneralSettingsPanelState();
}

class _GeneralSettingsPanelState extends State<GeneralSettingsPanel> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _appNameCtrl;
  late final TextEditingController _taglineCtrl;
  late final TextEditingController _logoUrlCtrl;
  late final TextEditingController _faviconUrlCtrl;
  late final TextEditingController _supportEmailCtrl;
  late final TextEditingController _supportPhoneCtrl;
  late String _timezone;

  late String _currencyCode;
  late String _currencySymbol;
  late String _currencyName;
  late CurrencyPosition _currencyPosition;

  final List<String> _timezones = [
    'UTC', 'Asia/Dhaka', 'Asia/Kolkata', 'Asia/Dubai', 'Asia/Singapore',
    'Europe/London', 'Europe/Paris', 'America/New_York', 'America/Los_Angeles', 'Australia/Sydney',
  ];

  @override
  void initState() {
    super.initState();
    final s = widget.settings;
    _appNameCtrl = TextEditingController(text: s.appName);
    _taglineCtrl = TextEditingController(text: s.appTagline);
    _logoUrlCtrl = TextEditingController(text: s.logoUrl);
    _faviconUrlCtrl = TextEditingController(text: s.faviconUrl);
    _supportEmailCtrl = TextEditingController(text: s.supportEmail);
    _supportPhoneCtrl = TextEditingController(text: s.supportPhone);
    _timezone = s.timezone;
    
    final currentCurrency = CurrencyController.to.currency.value;
    _currencyCode = currentCurrency.code;
    _currencySymbol = currentCurrency.symbol;
    _currencyName = currentCurrency.name;
    _currencyPosition = currentCurrency.position;
  }

  @override
  void dispose() {
    _appNameCtrl.dispose();
    _taglineCtrl.dispose();
    _logoUrlCtrl.dispose();
    _faviconUrlCtrl.dispose();
    _supportEmailCtrl.dispose();
    _supportPhoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final updated = widget.settings.copyWith(
      appName: _appNameCtrl.text,
      appTagline: _taglineCtrl.text,
      logoUrl: _logoUrlCtrl.text,
      faviconUrl: _faviconUrlCtrl.text,
      supportEmail: _supportEmailCtrl.text,
      supportPhone: _supportPhoneCtrl.text,
      timezone: _timezone,
      currency: _currencyCode, // keep the entity updated with the code
    );
    
    // Save Currency settings globally
    await CurrencyController.to.updateCurrency(
      CurrencyConfig(
        code: _currencyCode,
        symbol: _currencySymbol,
        name: _currencyName,
        position: _currencyPosition,
      ),
    );

    final ok = await widget.controller.saveGeneralSettings(updated);
    if (ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('General settings saved.'), backgroundColor: AppColors.success),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // ── App Info ──
          SettingsSection(
            title: 'App Information',
            subtitle: 'Basic information about your platform',
            icon: Icons.info_outline,
            children: [
              SettingsFormRow(
                label: 'App Name',
                hint: 'Displayed in the browser tab and emails',
                field: TextFormField(
                  controller: _appNameCtrl,
                  decoration: _inputDeco('e.g. Vango Live'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
              ),
              SettingsFormRow(
                label: 'Tagline',
                hint: 'Short slogan shown on marketing pages',
                field: TextFormField(
                  controller: _taglineCtrl,
                  decoration: _inputDeco('e.g. Shop. Stream. Sell.'),
                ),
              ),
              SettingsFormRow(
                label: 'Timezone',
                field: DropdownButtonFormField<String>(
                  initialValue: _timezone,
                  decoration: _inputDeco(null),
                  items: _timezones
                      .map((tz) => DropdownMenuItem(value: tz, child: Text(tz)))
                      .toList(),
                  onChanged: (v) => setState(() => _timezone = v ?? _timezone),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Currency Settings ──
          SettingsSection(
            title: 'Currency Settings',
            subtitle: 'Global currency formatting for the entire platform',
            icon: Icons.payments_outlined,
            iconColor: AppColors.success,
            children: [
              SettingsFormRow(
                label: 'Currency Code',
                hint: 'e.g. GBP, USD, EUR',
                field: TextFormField(
                  initialValue: _currencyCode,
                  onChanged: (v) => _currencyCode = v,
                  decoration: _inputDeco('e.g. GBP'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
              ),
              SettingsFormRow(
                label: 'Currency Symbol',
                hint: 'e.g. £, \$, €',
                field: TextFormField(
                  initialValue: _currencySymbol,
                  onChanged: (v) => _currencySymbol = v,
                  decoration: _inputDeco('e.g. £'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
              ),
              SettingsFormRow(
                label: 'Currency Name',
                hint: 'e.g. British Pound',
                field: TextFormField(
                  initialValue: _currencyName,
                  onChanged: (v) => _currencyName = v,
                  decoration: _inputDeco('e.g. British Pound'),
                ),
              ),
              SettingsFormRow(
                label: 'Symbol Position',
                field: DropdownButtonFormField<CurrencyPosition>(
                  initialValue: _currencyPosition,
                  decoration: _inputDeco(null),
                  items: const [
                    DropdownMenuItem(value: CurrencyPosition.left, child: Text('Left (e.g. £100)')),
                    DropdownMenuItem(value: CurrencyPosition.right, child: Text('Right (e.g. 100€)')),
                  ],
                  onChanged: (v) => setState(() => _currencyPosition = v ?? _currencyPosition),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Branding ──
          SettingsSection(
            title: 'Branding',
            subtitle: 'Logo and favicon shown across the platform',
            icon: Icons.palette_outlined,
            iconColor: AppColors.warning,
            children: [
              SettingsFormRow(
                label: 'Logo URL',
                hint: 'Recommended: 200×60 px PNG/SVG',
                field: TextFormField(
                  controller: _logoUrlCtrl,
                  decoration: _inputDeco('https://...'),
                ),
              ),
              if (_logoUrlCtrl.text.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 220 + AppSpacing.xl, bottom: AppSpacing.md),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      _logoUrlCtrl.text,
                      height: 48,
                      errorBuilder: (context, error, stackTrace) => const Text('Preview unavailable'),
                    ),
                  ),
                ),
              ],
              SettingsFormRow(
                label: 'Favicon URL',
                hint: 'Recommended: 32×32 px ICO/PNG',
                field: TextFormField(
                  controller: _faviconUrlCtrl,
                  decoration: _inputDeco('https://...'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Contact ──
          SettingsSection(
            title: 'Support Contact',
            subtitle: 'Shown in user-facing emails and help pages',
            icon: Icons.contact_support_outlined,
            iconColor: AppColors.info,
            children: [
              SettingsFormRow(
                label: 'Support Email',
                field: TextFormField(
                  controller: _supportEmailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDeco('support@example.com'),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
              ),
              SettingsFormRow(
                label: 'Support Phone',
                field: TextFormField(
                  controller: _supportPhoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDeco('+1-800-000-0000'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: 'Save General Settings',
                icon: Icons.save_outlined,
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
