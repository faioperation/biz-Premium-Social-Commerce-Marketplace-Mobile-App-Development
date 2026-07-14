import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // ─────────────────────────────────────────────
  // Base — Inter (clean, modern, enterprise SaaS)
  // ─────────────────────────────────────────────
  static final TextStyle _base = GoogleFonts.inter();

  // ─────────────────────────────────────────────
  // Headings — tighter tracking, strong weights
  // ─────────────────────────────────────────────
  static TextStyle h1 = _base.copyWith(fontSize: 30, fontWeight: FontWeight.w700, letterSpacing: -0.75, height: 1.2);
  static TextStyle h2 = _base.copyWith(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.5,  height: 1.25);
  static TextStyle h3 = _base.copyWith(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.4,  height: 1.3);
  static TextStyle h4 = _base.copyWith(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.2,  height: 1.35);
  static TextStyle h5 = _base.copyWith(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: -0.1,  height: 1.4);
  static TextStyle h6 = _base.copyWith(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0,     height: 1.4);

  // ─────────────────────────────────────────────
  // Body Text — comfortable reading sizes
  // ─────────────────────────────────────────────
  static TextStyle bodyLg  = _base.copyWith(fontSize: 16, fontWeight: FontWeight.w400, height: 1.6);
  static TextStyle body    = _base.copyWith(fontSize: 14, fontWeight: FontWeight.w400, height: 1.57);
  static TextStyle bodySm  = _base.copyWith(fontSize: 13, fontWeight: FontWeight.w400, height: 1.5);
  static TextStyle caption = _base.copyWith(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5);

  // ─────────────────────────────────────────────
  // Labels & UI Text
  // ─────────────────────────────────────────────
  static TextStyle button   = _base.copyWith(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1);
  static TextStyle overline = _base.copyWith(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8, height: 1);

  // ─────────────────────────────────────────────
  // Table-specific
  // ─────────────────────────────────────────────
  static TextStyle tableHeader = _base.copyWith(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5, height: 1);
  static TextStyle tableCell   = _base.copyWith(fontSize: 13, fontWeight: FontWeight.w400, height: 1.4);
  static TextStyle tableCellMono = GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w500);
}
