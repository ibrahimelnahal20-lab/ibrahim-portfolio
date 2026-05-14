import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/portfolio_data.dart';
import '../../../shared/widgets/cards/project_card.dart';
import '../../../shared/widgets/layout/section_container.dart';
import '../../../shared/widgets/layout/section_header.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Portfolio',
            title: 'Featured Projects',
            subtitle: 'Recent work demonstrating my capabilities.',
            description: '',
          ),
          const SizedBox(height: AppSpacing.xxl),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: PortfolioData.projects.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: isMobile ? AppSpacing.md : AppSpacing.xl),
            itemBuilder: (context, index) {
              return ProjectCard(project: PortfolioData.projects[index]);
            },
          ),
        ],
      ),
    );
  }
}
