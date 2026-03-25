class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String iconUrl;
  final List<String> technologies;
  final String? githubUrl;
  final String? liveUrl; // <-- ADD THIS LINE

  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.iconUrl,
    required this.technologies,
    this.githubUrl,
    this.liveUrl, // <-- ADD THIS LINE
  });
}