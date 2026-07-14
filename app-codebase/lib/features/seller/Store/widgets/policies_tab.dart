import 'package:flutter/material.dart';
import 'settings_text_field.dart';

/// The Refund, Return policies and Terms of Service editing view tab for Store Settings.
class PoliciesTab extends StatelessWidget {
  final TextEditingController returnController;
  final TextEditingController termsController;

  const PoliciesTab({
    super.key,
    required this.returnController,
    required this.termsController,
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
            label: 'Return & Refund Policy',
            controller: returnController,
            placeholder: 'Detail your policy on product returns, refunds, timelines, and shipping charges...',
            maxLines: 8,
          ),
          const SizedBox(height: 24),
          SettingsTextField(
            label: 'Terms of Service',
            controller: termsController,
            placeholder: 'State the rules, guidelines, and conditions that govern purchases on your store...',
            maxLines: 8,
          ),
        ],
      ),
    );
  }
}
