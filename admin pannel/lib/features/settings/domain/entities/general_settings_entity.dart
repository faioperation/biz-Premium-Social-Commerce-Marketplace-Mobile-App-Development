class GeneralSettingsEntity {
  final String appName;
  final String appTagline;
  final String logoUrl;
  final String faviconUrl;
  final String primaryColor;
  final String supportEmail;
  final String supportPhone;
  final String timezone;
  final String currency;

  const GeneralSettingsEntity({
    required this.appName,
    required this.appTagline,
    required this.logoUrl,
    required this.faviconUrl,
    required this.primaryColor,
    required this.supportEmail,
    required this.supportPhone,
    required this.timezone,
    required this.currency,
  });

  GeneralSettingsEntity copyWith({
    String? appName,
    String? appTagline,
    String? logoUrl,
    String? faviconUrl,
    String? primaryColor,
    String? supportEmail,
    String? supportPhone,
    String? timezone,
    String? currency,
  }) {
    return GeneralSettingsEntity(
      appName: appName ?? this.appName,
      appTagline: appTagline ?? this.appTagline,
      logoUrl: logoUrl ?? this.logoUrl,
      faviconUrl: faviconUrl ?? this.faviconUrl,
      primaryColor: primaryColor ?? this.primaryColor,
      supportEmail: supportEmail ?? this.supportEmail,
      supportPhone: supportPhone ?? this.supportPhone,
      timezone: timezone ?? this.timezone,
      currency: currency ?? this.currency,
    );
  }
}
