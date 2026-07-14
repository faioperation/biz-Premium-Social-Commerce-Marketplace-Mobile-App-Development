class SecuritySettingsEntity {
  final int minPasswordLength;
  final bool requireUppercase;
  final bool requireNumbers;
  final bool requireSpecialChars;
  final int passwordExpiryDays; // 0 = never
  final int maxLoginAttempts;
  final int lockoutDurationMinutes;
  final bool enableTwoFactor;
  final int otpExpirySeconds;
  final int otpLength;
  final bool allowSmsOtp;
  final bool allowEmailOtp;
  final List<String> blockedIpRanges;
  final bool enforceAdminIpWhitelist;

  const SecuritySettingsEntity({
    required this.minPasswordLength,
    required this.requireUppercase,
    required this.requireNumbers,
    required this.requireSpecialChars,
    required this.passwordExpiryDays,
    required this.maxLoginAttempts,
    required this.lockoutDurationMinutes,
    required this.enableTwoFactor,
    required this.otpExpirySeconds,
    required this.otpLength,
    required this.allowSmsOtp,
    required this.allowEmailOtp,
    required this.blockedIpRanges,
    required this.enforceAdminIpWhitelist,
  });

  SecuritySettingsEntity copyWith({
    int? minPasswordLength,
    bool? requireUppercase,
    bool? requireNumbers,
    bool? requireSpecialChars,
    int? passwordExpiryDays,
    int? maxLoginAttempts,
    int? lockoutDurationMinutes,
    bool? enableTwoFactor,
    int? otpExpirySeconds,
    int? otpLength,
    bool? allowSmsOtp,
    bool? allowEmailOtp,
    List<String>? blockedIpRanges,
    bool? enforceAdminIpWhitelist,
  }) {
    return SecuritySettingsEntity(
      minPasswordLength: minPasswordLength ?? this.minPasswordLength,
      requireUppercase: requireUppercase ?? this.requireUppercase,
      requireNumbers: requireNumbers ?? this.requireNumbers,
      requireSpecialChars: requireSpecialChars ?? this.requireSpecialChars,
      passwordExpiryDays: passwordExpiryDays ?? this.passwordExpiryDays,
      maxLoginAttempts: maxLoginAttempts ?? this.maxLoginAttempts,
      lockoutDurationMinutes: lockoutDurationMinutes ?? this.lockoutDurationMinutes,
      enableTwoFactor: enableTwoFactor ?? this.enableTwoFactor,
      otpExpirySeconds: otpExpirySeconds ?? this.otpExpirySeconds,
      otpLength: otpLength ?? this.otpLength,
      allowSmsOtp: allowSmsOtp ?? this.allowSmsOtp,
      allowEmailOtp: allowEmailOtp ?? this.allowEmailOtp,
      blockedIpRanges: blockedIpRanges ?? this.blockedIpRanges,
      enforceAdminIpWhitelist: enforceAdminIpWhitelist ?? this.enforceAdminIpWhitelist,
    );
  }
}
