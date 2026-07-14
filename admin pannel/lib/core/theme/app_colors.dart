import 'package:flutter/material.dart';

class AppColors {
  // ─────────────────────────────────────────────
  // BRAND — Indigo (Stripe / Linear inspired)
  // ─────────────────────────────────────────────
  static const Color primary        = Color(0xFF5B5BD6); // Vibrant Indigo
  static const Color primaryDark    = Color(0xFF4747B5); // Deeper hover state
  static const Color primaryLight   = Color(0xFF7B7DEA); // Lighter accent
  static const Color primarySubtle  = Color(0xFFEEEEFF); // Light mode tint bg
  static const Color primarySubtleDark = Color(0xFF1F1F3A); // Dark mode tint bg

  // ─────────────────────────────────────────────
  // BACKGROUNDS — Light Mode
  // ─────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF5F5F5); // Soft off-white canvas
  static const Color surfaceLight    = Color(0xFFFFFFFF); // Pure white surfaces
  static const Color cardLight       = Color(0xFFFFFFFF); // Elevated white cards
  static const Color sidebarLight    = Color(0xFFFFFFFF); // White sidebar
  static const Color hoverLight      = Color(0xFFF4F4F5); // Hover bg
  static const Color selectedLight   = Color(0xFFEEEEFF); // Selected item bg

  // ─────────────────────────────────────────────
  // BACKGROUNDS — Dark Mode
  // ─────────────────────────────────────────────
  static const Color backgroundDark  = Color(0xFF0D0D10); // Near-black canvas
  static const Color surfaceDark     = Color(0xFF141417); // Elevated surface
  static const Color cardDark        = Color(0xFF1C1C21); // Card surfaces
  static const Color sidebarDark     = Color(0xFF111114); // Dark sidebar
  static const Color hoverDark       = Color(0xFF1E1E24); // Hover bg
  static const Color selectedDark    = Color(0xFF1F1F3A); // Selected item bg

  // ─────────────────────────────────────────────
  // TEXT — Light Mode
  // ─────────────────────────────────────────────
  static const Color textPrimaryLight   = Color(0xFF09090B); // Near-black
  static const Color textSecondaryLight = Color(0xFF52525B); // Zinc-600
  static const Color textTertiaryLight  = Color(0xFFA1A1AA); // Zinc-400
  static const Color textDisabledLight  = Color(0xFFD4D4D8); // Zinc-300

  // ─────────────────────────────────────────────
  // TEXT — Dark Mode
  // ─────────────────────────────────────────────
  static const Color textPrimaryDark   = Color(0xFFFAFAFA); // Near-white
  static const Color textSecondaryDark = Color(0xFFA1A1AA); // Zinc-400
  static const Color textTertiaryDark  = Color(0xFF71717A); // Zinc-500
  static const Color textDisabledDark  = Color(0xFF3F3F46); // Zinc-700

  // ─────────────────────────────────────────────
  // BORDERS
  // ─────────────────────────────────────────────
  static const Color borderLight  = Color(0xFFE4E4E7); // Zinc-200
  static const Color borderDark   = Color(0xFF27272A); // Zinc-800
  static const Color borderFocus  = Color(0xFF5B5BD6); // Primary when focused

  // ─────────────────────────────────────────────
  // STATUS — Semantic Colors
  // ─────────────────────────────────────────────

  // Success — Emerald
  static const Color success        = Color(0xFF10B981);
  static const Color successLight   = Color(0xFFD1FAE5); // Light bg
  static const Color successDark    = Color(0xFF052E16); // Dark bg

  // Warning — Amber
  static const Color warning        = Color(0xFFF59E0B);
  static const Color warningLight   = Color(0xFFFEF3C7);
  static const Color warningDark    = Color(0xFF2D1C00);

  // Error — Rose
  static const Color error          = Color(0xFFEF4444);
  static const Color errorLight     = Color(0xFFFFE4E4);
  static const Color errorDark      = Color(0xFF3B0000);

  // Info — Blue
  static const Color info           = Color(0xFF3B82F6);
  static const Color infoLight      = Color(0xFFDBEAFE);
  static const Color infoDark       = Color(0xFF0F1A3D);

  // ─────────────────────────────────────────────
  // LEGACY ALIASES — Keep existing pages compiling
  // ─────────────────────────────────────────────
  static const Color successSubtle  = successLight;
  static const Color warningSubtle  = warningLight;
  static const Color errorSubtle    = errorLight;
  static const Color infoSubtle     = infoLight;

  // ─────────────────────────────────────────────
  // TABLE — Specialized tokens
  // ─────────────────────────────────────────────
  static const Color tableHeaderLight     = Color(0xFFF4F4F5); // Zinc-100
  static const Color tableHeaderDark      = Color(0xFF18181B); // Zinc-900
  static const Color tableRowAltLight     = Color(0xFFFAFAFA); // Zebra row light
  static const Color tableRowAltDark      = Color(0xFF18181B); // Zebra row dark
  static const Color tableRowHoverLight   = Color(0xFFF4F4F5);
  static const Color tableRowHoverDark    = Color(0xFF1E1E24);
  static const Color tableSelectedLight   = Color(0xFFEEEEFF);
  static const Color tableSelectedDark    = Color(0xFF1F1F3A);

  // ─────────────────────────────────────────────
  // CHART PALETTE
  // ─────────────────────────────────────────────
  static const List<Color> chartPalette = [
    Color(0xFF5B5BD6), // Indigo — primary
    Color(0xFF10B981), // Emerald — success
    Color(0xFFF59E0B), // Amber — warning
    Color(0xFFEF4444), // Rose — error
    Color(0xFF8B5CF6), // Violet
    Color(0xFF06B6D4), // Cyan
    Color(0xFFEC4899), // Pink
    Color(0xFF6366F1), // Periwinkle
  ];

  // ─────────────────────────────────────────────
  // SHADOWS — Elevation tokens
  // ─────────────────────────────────────────────
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.04),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.04),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.10),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.06),
      blurRadius: 8,
      offset: const Offset(0, 3),
    ),
  ];
}
