import 'package:flutter/material.dart';
import 'settings_text_field.dart';

/// The Shipping Policy editing view tab for Store Settings.
class ShippingTab extends StatelessWidget {
  final TextEditingController shippingController;

  const ShippingTab({
    super.key,
    required this.shippingController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsTextField(
            label: 'Shipping Policy & Guidelines',
            controller: shippingController,
            placeholder: 'Enter your shipping timelines, carrier details, and fees...',
            maxLines: 12,
          ),
        ],
      ),
    );
  }
}
