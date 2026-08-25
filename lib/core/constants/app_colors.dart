import 'package:flutter/material.dart';

/// Bảng màu chuẩn Minimalist Apple-like cho HomeSync
class AppColors {
  AppColors._();

  // Primary & Brand Colors (Tin cậy & Hiện đại)
  static const Color primary = Color(0xFF2563EB); // Royal Blue
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFFEFF6FF);

  // Status & Warranty Indicators
  static const Color statusGood = Color(0xFF10B981); // Emerald - Còn hạn tốt (> 30 ngày)
  static const Color statusGoodBg = Color(0xFFECFDF5);
  
  static const Color statusWarning = Color(0xFFF59E0B); // Amber - Sắp hết hạn (<= 30 ngày)
  static const Color statusWarningBg = Color(0xFFFFFBEB);
  
  static const Color statusDanger = Color(0xFFEF4444); // Coral Red - Đã hết hạn / Quá hạn bảo dưỡng
  static const Color statusDangerBg = Color(0xFFFEF2F2);

  // Light Theme Neutral Backgrounds & Surfaces
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color dividerLight = Color(0xFFF1F5F9);

  // Dark Theme Neutral Backgrounds & Surfaces
  static const Color bgDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color borderDark = Color(0xFF334155);
  static const Color dividerDark = Color(0xFF1E293B);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textMutedLight = Color(0xFF94A3B8);

  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF64748B);
}
