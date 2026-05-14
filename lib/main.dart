/// main.dart
/// Entry point for the Ibrahim Portfolio web application.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app.dart';
import 'core/utils/perf_logger.dart';

void main() async {
  PerfLogger.markStartup();

  WidgetsFlutterBinding.ensureInitialized();
  PerfLogger.log('binding_initialized');

  // ── Google Fonts: eager cache priming ──
  // Calling these constructors loads the font metadata into the
  // GoogleFonts cache synchronously, so the first build() call that
  // uses these styles gets a cached TextStyle instead of triggering
  // an async font download mid-frame.
  // This eliminates FOUT (flash of un-styled text) on first render.
  GoogleFonts.spaceGrotesk();
  GoogleFonts.sora();
  GoogleFonts.jetBrainsMono();

  PerfLogger.log('fonts_primed');

  runApp(const PortfolioApp());
}
