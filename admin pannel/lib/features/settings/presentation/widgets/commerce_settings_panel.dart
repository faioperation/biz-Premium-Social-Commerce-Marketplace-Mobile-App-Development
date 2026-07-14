import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/commerce_settings_entity.dart';
import '../controllers/settings_controller.dart';
import 'settings_section.dart';
import '../../../../core/controllers/currency_controller.dart';

class CommerceSettingsPanel extends StatefulWidget {
  final SettingsController controller;
  final CommerceSettingsEntity settings;

  const CommerceSettingsPanel({
    super.key,
    required this.controller,
    required this.settings,
  });

  @override
  State<CommerceSettingsPanel> createState() => _CommerceSettingsPanelState();
}

class _CommerceSettingsPanelState extends State<CommerceSettingsPanel> {
  final _formKey = GlobalKey<FormState>();

  late double _commission;
  late double _minBidIncrement;
  late int _auctionExtMins;
  late int _auctionTriggerMins;
  late bool _autoApprove;
  late double _minOrder;
  late double _freeShippingThreshold;
  late bool _allowInternational;
  late double _defaultShippingFee;
  late List<String> _shippingZones;

  final _commissionCtrl = TextEditingController();
  final _minBidCtrl = TextEditingController();
  final _auctionExtCtrl = TextEditingController();
  final _auctionTriggerCtrl = TextEditingController();
  final _minOrderCtrl = TextEditingController();
  final _freeShippingCtrl = TextEditingController();
  final _shippingFeeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final s = widget.settings;
    _commission = s.commissionPercentage;
    _minBidIncrement = s.minAuctionBidIncrement;
    _auctionExtMins = s.auctionExtensionMinutes;
    _auctionTriggerMins = s.auctionExtensionTriggerMinutes;
    _autoApprove = s.autoApproveProducts;
    _minOrder = s.minOrderAmount;
    _freeShippingThreshold = s.freeShippingThreshold;
    _allowInternational = s.allowInternationalShipping;
    _defaultShippingFee = s.defaultShippingFee;
    _shippingZones = List<String>.from(s.supportedShippingZones);

    _commissionCtrl.text = _commission.toString();
    _minBidCtrl.text = _minBidIncrement.toString();
    _auctionExtCtrl.text = _auctionExtMins.toString();
    _auctionTriggerCtrl.text = _auctionTriggerMins.toString();
    _minOrderCtrl.text = _minOrder.toString();
    _freeShippingCtrl.text = _freeShippingThreshold.toString();
    _shippingFeeCtrl.text = _defaultShippingFee.toString();
  }

  @override
  void dispose() {
    _commissionCtrl.dispose();
    _minBidCtrl.dispose();
    _auctionExtCtrl.dispose();
    _auctionTriggerCtrl.dispose();
    _minOrderCtrl.dispose();
    _freeShippingCtrl.dispose();
    _shippingFeeCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final updated = widget.settings.copyWith(
      commissionPercentage: double.tryParse(_commissionCtrl.text) ?? _commission,
      minAuctionBidIncrement: double.tryParse(_minBidCtrl.text) ?? _minBidIncrement,
      auctionExtensionMinutes: int.tryParse(_auctionExtCtrl.text) ?? _auctionExtMins,
      auctionExtensionTriggerMinutes: int.tryParse(_auctionTriggerCtrl.text) ?? _auctionTriggerMins,
      autoApproveProducts: _autoApprove,
      minOrderAmount: double.tryParse(_minOrderCtrl.text) ?? _minOrder,
      freeShippingThreshold: double.tryParse(_freeShippingCtrl.text) ?? _freeShippingThreshold,
      allowInternationalShipping: _allowInternational,
      defaultShippingFee: double.tryParse(_shippingFeeCtrl.text) ?? _defaultShippingFee,
      supportedShippingZones: _shippingZones,
    );
    final ok = await widget.controller.saveCommerceSettings(updated);
    if (ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Commerce settings saved.'), backgroundColor: AppColors.success),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = CurrencyController.to.symbol;
    
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // ── Commission ──
          SettingsSection(
            title: 'Commission Settings',
            subtitle: 'Revenue sharing between platform and sellers',
            icon: Icons.percent,
            iconColor: AppColors.success,
            children: [
              SettingsFormRow(
                label: 'Platform Commission (%)',
                hint: 'Deducted from each completed sale',
                field: TextFormField(
                  controller: _commissionCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  decoration: _inputDeco('e.g. 12.5'),
                  validator: (v) {
                    final n = double.tryParse(v ?? '');
                    if (n == null) return 'Enter a valid number';
                    if (n < 0 || n > 100) return 'Must be between 0 and 100';
                    return null;
                  },
                ),
              ),
              SettingsToggleRow(
                label: 'Auto-approve Products',
                hint: 'Skip manual review for verified sellers',
                value: _autoApprove,
                onChanged: (v) => setState(() => _autoApprove = v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Auction Rules ──
          SettingsSection(
            title: 'Auction Rules',
            subtitle: 'Configure bidding mechanics for live auctions',
            icon: Icons.gavel,
            iconColor: AppColors.warning,
            children: [
              SettingsFormRow(
                label: 'Min Bid Increment ($currencySymbol)',
                hint: 'Minimum amount each new bid must exceed the previous',
                field: TextFormField(
                  controller: _minBidCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  decoration: _inputDeco('e.g. 1.00'),
                  validator: (v) => (double.tryParse(v ?? '') == null) ? 'Enter a valid number' : null,
                ),
              ),
              SettingsFormRow(
                label: 'Auto-extension (mins)',
                hint: 'Extend auction by this many minutes when a bid is placed near the end',
                field: TextFormField(
                  controller: _auctionExtCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDeco('e.g. 5'),
                  validator: (v) => (int.tryParse(v ?? '') == null) ? 'Enter a valid integer' : null,
                ),
              ),
              SettingsFormRow(
                label: 'Extension Trigger (mins)',
                hint: 'Extension activates when a bid arrives in the last N minutes',
                field: TextFormField(
                  controller: _auctionTriggerCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDeco('e.g. 2'),
                  validator: (v) => (int.tryParse(v ?? '') == null) ? 'Enter a valid integer' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Shipping Rules ──
          SettingsSection(
            title: 'Shipping Rules',
            subtitle: 'Configure order fulfilment and shipping policies',
            icon: Icons.local_shipping_outlined,
            iconColor: AppColors.info,
            children: [
              SettingsFormRow(
                label: 'Minimum Order Amount ($currencySymbol)',
                hint: 'Orders below this value are not accepted',
                field: TextFormField(
                  controller: _minOrderCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  decoration: _inputDeco('e.g. 5.00'),
                  validator: (v) => (double.tryParse(v ?? '') == null) ? 'Enter a valid number' : null,
                ),
              ),
              SettingsFormRow(
                label: 'Free Shipping Threshold ($currencySymbol)',
                hint: 'Orders above this amount qualify for free shipping',
                field: TextFormField(
                  controller: _freeShippingCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  decoration: _inputDeco('e.g. 50.00'),
                  validator: (v) => (double.tryParse(v ?? '') == null) ? 'Enter a valid number' : null,
                ),
              ),
              SettingsFormRow(
                label: 'Default Shipping Fee ($currencySymbol)',
                hint: 'Applied when seller has not set a custom rate',
                field: TextFormField(
                  controller: _shippingFeeCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  decoration: _inputDeco('e.g. 4.99'),
                  validator: (v) => (double.tryParse(v ?? '') == null) ? 'Enter a valid number' : null,
                ),
              ),
              SettingsToggleRow(
                label: 'Allow International Shipping',
                hint: 'Enables cross-border order fulfilment',
                value: _allowInternational,
                onChanged: (v) => setState(() => _allowInternational = v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: 'Save Commerce Settings',
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
