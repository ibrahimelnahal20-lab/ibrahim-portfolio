import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'core/animations/reveal_animation.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/utils/platform_utils.dart';
import 'core/utils/deferred_section.dart';
import 'core/utils/perf_logger.dart';
import 'shared/effects/grid_background.dart';
import 'shared/effects/glow_blob.dart';
import 'shared/widgets/layout/section_container.dart';
import 'shared/widgets/layout/section_divider.dart';
import 'features/navbar/presentation/navbar_section.dart';
import 'features/hero/presentation/hero_section.dart';
import 'features/skills/presentation/skills_section.dart';
import 'features/projects/presentation/projects_section.dart';
import 'features/contact/presentation/contact_section.dart';
import 'features/footer/presentation/footer_section.dart';
import 'features/about/presentation/about_section.dart';
import 'core/utils/section_keys.dart';
import 'core/cursor/custom_cursor.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    PerfLogger.log('app_build');
    return MaterialApp(
      title: 'Ibrahim Elnahal — Developer',
      theme: AppTheme.darkTheme,
      home: const CustomCursor(
        child: PortfolioShell(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PortfolioShell extends StatefulWidget {
  const PortfolioShell({super.key});

  @override
  State<PortfolioShell> createState() => _PortfolioShellState();
}

class _PortfolioShellState extends State<PortfolioShell> {
  final _scrollController = ScrollController();

  // ── Section hydration controllers ──
  final _projectsController = DeferredSectionController();
  final _aboutController = DeferredSectionController();
  final _contactController = DeferredSectionController();

  // ── Startup orchestration ──
  // Frame 1: bg color + grid only (cheapest possible first paint)
  // ~120ms: atmosphere fades in (GlowBlobs)
  // ~200ms: projects hydrated
  // ~600ms: about hydrated
  // ~900ms: contact hydrated
  bool _atmosphereReady = false;

  @override
  void initState() {
    super.initState();
    PerfLogger.log('shell_initState');
    _scheduleStartupSequence();
  }

  void _scheduleStartupSequence() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      PerfLogger.log('first_frame_complete');

      // Phase 0: Atmosphere — fade in blobs after first frame clears
      Future.delayed(const Duration(milliseconds: 120), () {
        if (!mounted) return;
        PerfLogger.log('atmosphere_activate');
        setState(() => _atmosphereReady = true);
      });

      // Phase 1: Projects
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!mounted) return;
        PerfLogger.log('prewarm_projects');
        _projectsController.hydrate();
      });

      // Phase 2: About
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        PerfLogger.log('prewarm_about');
        _aboutController.hydrate();
      });

      // Phase 3: Contact
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        PerfLogger.log('prewarm_contact');
        _contactController.hydrate();
        PerfLogger.printDiagnostics();
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _projectsController.dispose();
    _aboutController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  /// Hydration-aware navigation.
  void _scrollTo(GlobalKey key) {
    PerfLogger.log('nav_request: ${key.toString()}');
    _projectsController.hydrate();
    _aboutController.hydrate();
    _contactController.hydrate();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutQuart,
          alignment: 0.1,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = PlatformUtils.isMobile;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // ── Grid — always immediate (CustomPainter, no GPU layer) ──
          const Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: GridBackground(),
              ),
            ),
          ),

          // ── GlowBlobs — deferred behind _atmosphereReady ──
          // Frame 1 skips these entirely, keeping first paint cheap.
          // They fade in at ~120ms via AnimatedOpacity.
          AnimatedOpacity(
            opacity: _atmosphereReady ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            child: IgnorePointer(
              child: Stack(
                children: [
                  const Positioned(
                    top: -300,
                    left: -100,
                    child: RepaintBoundary(
                      child: GlowBlob(
                        color: AppColors.accent2,
                        size: 800,
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 200,
                    right: -200,
                    child: RepaintBoundary(
                      child: GlowBlob(
                        color: AppColors.accent,
                        size: 500,
                      ),
                    ),
                  ),
                  if (!isMobile)
                    const Positioned(
                      bottom: -150,
                      left: -100,
                      child: RepaintBoundary(
                        child: GlowBlob(
                          color: AppColors.accent3,
                          size: 600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Scrollable content ──
          CustomScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 72),

                    // Hero — immediate
                    RevealAnimation(
                      key: SectionKeys.hero,
                      // Slightly longer delay on mobile lets the engine
                      // finish painting the flat bg before starting animations
                      delay: Duration(milliseconds: isMobile ? 80 : 80),
                      type: RevealType.up,
                      child: SectionContainer(
                        child: HeroSection(onNavigate: _scrollTo),
                      ),
                    ),

                    const SectionDivider(),

                    // Skills — immediate
                    RepaintBoundary(
                      child: RevealAnimation(
                        key: SectionKeys.skills,
                        delay: Duration(milliseconds: isMobile ? 120 : 50),
                        type: RevealType.up,
                        child: const SkillsSection(),
                      ),
                    ),

                    const SectionDivider(),

                    // Projects — deferred ~200ms
                    DeferredSection(
                      name: 'projects',
                      controller: _projectsController,
                      estimatedHeight: isMobile ? 1200 : 600,
                      child: RepaintBoundary(
                        child: RevealAnimation(
                          key: SectionKeys.projects,
                          delay: Duration(milliseconds: isMobile ? 80 : 50),
                          type: RevealType.left,
                          child: const ProjectsSection(),
                        ),
                      ),
                    ),

                    const SectionDivider(),

                    // About — deferred ~600ms
                    DeferredSection(
                      name: 'about',
                      controller: _aboutController,
                      estimatedHeight: isMobile ? 2000 : 1000,
                      child: RepaintBoundary(
                        child: RevealAnimation(
                          key: SectionKeys.about,
                          delay: Duration(milliseconds: isMobile ? 80 : 50),
                          type: RevealType.fade,
                          child: const AboutSection(),
                        ),
                      ),
                    ),

                    const SectionDivider(),

                    // Contact — deferred ~900ms
                    DeferredSection(
                      name: 'contact',
                      controller: _contactController,
                      estimatedHeight: isMobile ? 900 : 700,
                      child: RepaintBoundary(
                        child: RevealAnimation(
                          key: SectionKeys.contact,
                          delay: Duration(milliseconds: isMobile ? 80 : 50),
                          type: RevealType.slowUp,
                          child: const ContactSection(),
                        ),
                      ),
                    ),

                    const FooterSection(),
                  ],
                ),
              ),
            ],
          ),

          // ── Navbar — always on top ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavbarSection(
              scrollController: _scrollController,
              onNavigate: _scrollTo,
            ),
          ),
        ],
      ),
    );
  }
}
