import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // 1. Space Grotesk (Headings, Hero title, Project titles, Section titles, Stat values)
  static final TextStyle h1 = GoogleFonts.spaceGrotesk(
    fontSize: 64.0,
    fontWeight: FontWeight.w800,
    letterSpacing: -2.0,
    color: AppColors.text,
    height: 1.1,
  );

  static final TextStyle heroOutline = GoogleFonts.spaceGrotesk(
    fontSize: 64.0,
    fontWeight: FontWeight.w800,
    letterSpacing: -2.0,
    height: 1.1,
  );

  static final TextStyle h2 = GoogleFonts.spaceGrotesk(
    fontSize: 48.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    color: AppColors.text,
    height: 1.2,
  );

  static final TextStyle h3 = GoogleFonts.spaceGrotesk(
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    color: AppColors.text,
    height: 1.2,
  );
  
  static final TextStyle statValue = GoogleFonts.spaceGrotesk(
    fontSize: 40.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    color: AppColors.accent,
    height: 1.2,
  );

  // 2. Sora (Body, Paragraphs, Descriptions, Buttons, Subtitles)
  static final TextStyle bodyLarge = GoogleFonts.sora(
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
    height: 1.7,
  );

  static final TextStyle body = GoogleFonts.sora(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
    height: 1.7,
  );

  static final TextStyle bodySmall = GoogleFonts.sora(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.muted2,
    height: 1.6,
  );

  static final TextStyle button = GoogleFonts.sora(
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    color: AppColors.bg,
    letterSpacing: 0.5,
    height: 1.2,
  );

  // 3. JetBrains Mono (Navbar links, Tech chips, Status badges, Footer, Code card, Small labels, Eyebrow text)
  static final TextStyle mono = GoogleFonts.jetBrainsMono(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
    letterSpacing: 0.5,
  );

  static final TextStyle monoSmall = GoogleFonts.jetBrainsMono(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
    letterSpacing: 0.5,
  );

  static final TextStyle chip = GoogleFonts.jetBrainsMono(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
    letterSpacing: 0.5,
  );

  static final TextStyle nav = GoogleFonts.jetBrainsMono(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
    letterSpacing: 1.5,
  );

  static final TextStyle code = GoogleFonts.jetBrainsMono(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
    height: 1.8,
  );

  static final TextStyle eyebrow = GoogleFonts.jetBrainsMono(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.0,
    color: AppColors.accent,
  );

  static final TextStyle footer = GoogleFonts.jetBrainsMono(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.muted2,
    letterSpacing: 0.5,
  );
}
