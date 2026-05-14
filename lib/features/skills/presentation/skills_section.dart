import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/portfolio_data.dart';
import '../../../shared/widgets/cards/skill_card.dart';
import '../../../shared/widgets/layout/section_container.dart';
import '../../../shared/widgets/layout/section_header.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Expertise',
            title: 'Technical Skills',
            subtitle: 'A comprehensive look at the technologies I work with.',
            description: '',
          ),
          const SizedBox(height: AppSpacing.xxl),
          Responsive(
            mobile: _buildMobileGrid(),
            tablet: _buildTabletGrid(),
            desktop: _buildDesktopGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        mainAxisExtent: 320,
      ),
      itemCount: PortfolioData.skills.length,
      itemBuilder: (context, index) {
        return SkillCard(skill: PortfolioData.skills[index]);
      },
    );
  }

  Widget _buildTabletGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        mainAxisExtent: 340,
      ),
      itemCount: PortfolioData.skills.length,
      itemBuilder: (context, index) {
        return SkillCard(skill: PortfolioData.skills[index]);
      },
    );
  }

  Widget _buildMobileGrid() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: PortfolioData.skills.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        return SkillCard(skill: PortfolioData.skills[index]);
      },
    );
  }
}
