

class ProjectModel {
  final String title;
  final String description;
  final List<String> tags;
  final String badge;
  final String badgeType;
  final bool isFeatured;
  final String projectUrl;
  final String githubUrl;

  const ProjectModel({
    required this.title,
    required this.description,
    required this.tags,
    required this.badge,
    required this.badgeType,
    required this.isFeatured,
    this.projectUrl = '',
    this.githubUrl = '',
  });
}
