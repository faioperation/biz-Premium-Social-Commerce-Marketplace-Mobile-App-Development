import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/livestream_settings_entity.dart';
import '../controllers/settings_controller.dart';
import 'settings_section.dart';

class LivestreamSettingsPanel extends StatefulWidget {
  final SettingsController controller;
  final LivestreamSettingsEntity settings;

  const LivestreamSettingsPanel({
    super.key,
    required this.controller,
    required this.settings,
  });

  @override
  State<LivestreamSettingsPanel> createState() => _LivestreamSettingsPanelState();
}

class _LivestreamSettingsPanelState extends State<LivestreamSettingsPanel> {
  final _formKey = GlobalKey<FormState>();

  late int _maxConcurrentStreams;
  late int _maxStreamDurationMinutes;
  late int _maxViewersPerStream;
  late bool _enableChatModeration;
  late bool _autoFilterProfanity;
  late bool _requireVerificationToStream;
  late int _minFollowerCountToStream;
  late bool _enableGifts;
  late bool _enableAuctionDuringStream;
  late int _streamCooldownMinutes;
  late List<String> _bannedKeywords;
  final _newKeywordCtrl = TextEditingController();

  final _maxConcurrentCtrl = TextEditingController();
  final _maxDurationCtrl = TextEditingController();
  final _maxViewersCtrl = TextEditingController();
  final _minFollowersCtrl = TextEditingController();
  final _cooldownCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final s = widget.settings;
    _maxConcurrentStreams = s.maxConcurrentStreams;
    _maxStreamDurationMinutes = s.maxStreamDurationMinutes;
    _maxViewersPerStream = s.maxViewersPerStream;
    _enableChatModeration = s.enableChatModeration;
    _autoFilterProfanity = s.autoFilterProfanity;
    _requireVerificationToStream = s.requireSellerVerificationToStream;
    _minFollowerCountToStream = s.minFollowerCountToStream;
    _enableGifts = s.enableGifts;
    _enableAuctionDuringStream = s.enableAuctionDuringStream;
    _streamCooldownMinutes = s.streamCooldownMinutes;
    _bannedKeywords = List<String>.from(s.bannedKeywords);

    _maxConcurrentCtrl.text = _maxConcurrentStreams.toString();
    _maxDurationCtrl.text = _maxStreamDurationMinutes.toString();
    _maxViewersCtrl.text = _maxViewersPerStream.toString();
    _minFollowersCtrl.text = _minFollowerCountToStream.toString();
    _cooldownCtrl.text = _streamCooldownMinutes.toString();
  }

  @override
  void dispose() {
    _maxConcurrentCtrl.dispose();
    _maxDurationCtrl.dispose();
    _maxViewersCtrl.dispose();
    _minFollowersCtrl.dispose();
    _cooldownCtrl.dispose();
    _newKeywordCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final updated = widget.settings.copyWith(
      maxConcurrentStreams: int.tryParse(_maxConcurrentCtrl.text) ?? _maxConcurrentStreams,
      maxStreamDurationMinutes: int.tryParse(_maxDurationCtrl.text) ?? _maxStreamDurationMinutes,
      maxViewersPerStream: int.tryParse(_maxViewersCtrl.text) ?? _maxViewersPerStream,
      enableChatModeration: _enableChatModeration,
      autoFilterProfanity: _autoFilterProfanity,
      requireSellerVerificationToStream: _requireVerificationToStream,
      minFollowerCountToStream: int.tryParse(_minFollowersCtrl.text) ?? _minFollowerCountToStream,
      enableGifts: _enableGifts,
      enableAuctionDuringStream: _enableAuctionDuringStream,
      streamCooldownMinutes: int.tryParse(_cooldownCtrl.text) ?? _streamCooldownMinutes,
      bannedKeywords: _bannedKeywords,
    );
    final ok = await widget.controller.saveLivestreamSettings(updated);
    if (ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Livestream settings saved.'), backgroundColor: AppColors.success),
      );
    }
  }

  void _addKeyword() {
    final word = _newKeywordCtrl.text.trim().toLowerCase();
    if (word.isNotEmpty && !_bannedKeywords.contains(word)) {
      setState(() => _bannedKeywords.add(word));
      _newKeywordCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // ── Stream Limits ──
          SettingsSection(
            title: 'Stream Limits',
            subtitle: 'Control platform-wide livestream capacity',
            icon: Icons.live_tv_outlined,
            iconColor: AppColors.error,
            children: [
              SettingsFormRow(
                label: 'Max Concurrent Streams',
                hint: 'Platform-wide active stream cap',
                field: TextFormField(
                  controller: _maxConcurrentCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDeco('e.g. 100'),
                  validator: (v) => (int.tryParse(v ?? '') == null) ? 'Enter a valid number' : null,
                ),
              ),
              SettingsFormRow(
                label: 'Max Stream Duration (mins)',
                hint: 'A stream auto-ends after this many minutes',
                field: TextFormField(
                  controller: _maxDurationCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDeco('e.g. 180'),
                  validator: (v) => (int.tryParse(v ?? '') == null) ? 'Enter a valid number' : null,
                ),
              ),
              SettingsFormRow(
                label: 'Stream Cooldown (mins)',
                hint: 'Time a seller must wait before starting a new stream',
                field: TextFormField(
                  controller: _cooldownCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDeco('e.g. 30'),
                  validator: (v) => (int.tryParse(v ?? '') == null) ? 'Enter a valid number' : null,
                ),
              ),
              SettingsToggleRow(
                label: 'Require Seller Verification',
                hint: 'Only verified sellers can go live',
                value: _requireVerificationToStream,
                onChanged: (v) => setState(() => _requireVerificationToStream = v),
              ),
              SettingsFormRow(
                label: 'Min Followers to Stream',
                hint: 'Seller must have at least this many followers',
                field: TextFormField(
                  controller: _minFollowersCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDeco('e.g. 10'),
                  validator: (v) => (int.tryParse(v ?? '') == null) ? 'Enter a valid number' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Viewer Limits ──
          SettingsSection(
            title: 'Viewer Limits & Features',
            subtitle: 'Control who can watch and what they can do',
            icon: Icons.visibility_outlined,
            iconColor: AppColors.info,
            children: [
              SettingsFormRow(
                label: 'Max Viewers per Stream',
                hint: 'Viewers above this limit are queued',
                field: TextFormField(
                  controller: _maxViewersCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDeco('e.g. 10000'),
                  validator: (v) => (int.tryParse(v ?? '') == null) ? 'Enter a valid number' : null,
                ),
              ),
              SettingsToggleRow(
                label: 'Enable Gifts',
                hint: 'Allow viewers to send virtual gifts during streams',
                value: _enableGifts,
                onChanged: (v) => setState(() => _enableGifts = v),
              ),
              SettingsToggleRow(
                label: 'Enable Auctions During Stream',
                hint: 'Sellers can run live auctions while streaming',
                value: _enableAuctionDuringStream,
                onChanged: (v) => setState(() => _enableAuctionDuringStream = v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Chat Moderation ──
          SettingsSection(
            title: 'Chat Moderation',
            subtitle: 'Keep live chat safe and on-topic',
            icon: Icons.chat_outlined,
            iconColor: AppColors.warning,
            children: [
              SettingsToggleRow(
                label: 'Enable Chat Moderation',
                hint: 'Activates AI and human moderation for chat messages',
                value: _enableChatModeration,
                onChanged: (v) => setState(() => _enableChatModeration = v),
              ),
              SettingsToggleRow(
                label: 'Auto-filter Profanity',
                hint: 'Automatically replace or block profane words',
                value: _autoFilterProfanity,
                onChanged: (v) => setState(() => _autoFilterProfanity = v),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Banned Keywords', style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Text('Messages containing these words are auto-blocked', style: TextStyle(fontSize: 12, color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xl),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _newKeywordCtrl,
                                decoration: _inputDeco('Add keyword and press +'),
                                onSubmitted: (_) => _addKeyword(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.add_circle, color: AppColors.primary),
                              onPressed: _addKeyword,
                              tooltip: 'Add keyword',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_bannedKeywords.isEmpty)
                          Text('No banned keywords added.', style: TextStyle(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: _bannedKeywords.map((word) => Chip(
                            label: Text(word),
                            deleteIcon: const Icon(Icons.close, size: 14),
                            onDeleted: () => setState(() => _bannedKeywords.remove(word)),
                            backgroundColor: AppColors.errorSubtle,
                            labelStyle: const TextStyle(color: AppColors.error, fontSize: 12),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: 'Save Livestream Settings',
                icon: Icons.live_tv,
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
