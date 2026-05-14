import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'models/skill_model.dart';
import 'models/project_model.dart';

class PortfolioData {
  PortfolioData._();

  static const List<SkillModel> skills = [
    SkillModel(
      title: 'Flutter & Dart',
      description:
          'Building high-performance, beautiful cross-platform applications with single codebase efficiency. Expertise in complex UI animations and responsive design.',
      tags: ['Flutter Web', 'Animations', 'Widgets', 'Responsive'],
      icon: Icons.flutter_dash_rounded,
      accentColor: AppColors.accent2,
      backgroundColor: Color(0xFF1E2A38),
    ),
    SkillModel(
      title: 'State Management',
      description:
          'Architecting scalable application state using modern reactive patterns. Ensuring maintainable, decoupled, and testable code structures.',
      tags: ['GetX', 'Provider', 'Reactive', 'MVVM'],
      icon: Icons.account_tree_rounded,
      accentColor: AppColors.accent,
      backgroundColor: Color(0xFF1B2E24),
    ),
    SkillModel(
      title: 'ASP.NET Backend',
      description:
          'Designing robust RESTful APIs and microservices. Strong focus on secure, scalable architecture and optimized database interactions.',
      tags: ['ASP.NET', 'REST API', 'SQL Server', 'Deployment'],
      icon: Icons.storage_rounded,
      accentColor: AppColors.syntaxKeyword,
      backgroundColor: Color(0xFF2B1F38),
    ),
    SkillModel(
      title: 'Tools & Architecture',
      description:
          'Applying solid software engineering principles to create decoupled systems. Proficient with modern development workflows and design tools.',
      tags: ['MVVM', 'Clean Code', 'Git', 'Figma', 'VS Code'],
      icon: Icons.architecture_rounded,
      accentColor: AppColors.syntaxNumber,
      backgroundColor: Color(0xFF38231B),
    ),
    SkillModel(
      title: 'AI-Assisted Development',
      description:
          'Leveraging AI workflows for rapid prototyping and system design. Integrating prompt engineering to accelerate UI development and technical problem-solving.',
      tags: [
        'Prompt Engineering',
        'Vibe Coding',
        'AI Workflows',
        'Prototyping',
      ],
      icon: Icons.auto_awesome_rounded,
      accentColor: Color(0xFF9D4EDD), // Premium purple accent
      backgroundColor: Color(0xFF2A1B38),
    ),
  ];

  static const List<ProjectModel> projects = [
    ProjectModel(
      title: 'OCL Task Management',
      description:
          'A full-stack web application for task management deployed on live hosting. Built the responsive front-end using Flutter for Web and a robust back-end API using ASP.NET. Architected with the MVVM pattern and GetX for predictable state management.',
      tags: ['Flutter Web', 'ASP.NET Core', 'GetX', 'SQL Server', 'MVVM'],
      badge: '✦ Live Deployment',
      badgeType: 'live',
      isFeatured: false,
      projectUrl: 'https://ocl.ibrahim.dev',
      githubUrl: 'https://github.com/ibrahim/ocl-tasks',
    ),
    ProjectModel(
      title: 'Cinematic Developer Portfolio',
      description:
          'The codebase for this very portfolio. A highly-optimized Flutter Web experience demonstrating advanced UI engineering, custom shader rendering, and performance-first architecture.',
      tags: ['Flutter', 'WebAssembly', 'UI Engineering', 'Animations'],
      badge: '⟳ Open Source',
      badgeType: 'wip',
      isFeatured: false,
      githubUrl: 'https://github.com/ibrahimelnahal20-lab/ibrahim-portfolio',
    ),
  ];
}
