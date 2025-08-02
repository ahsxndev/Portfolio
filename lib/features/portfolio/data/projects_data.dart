import 'package:myfolio/features/portfolio/models/project_model.dart';
import 'package:myfolio/core/config/projects_config.dart';

/// ============================================
/// 📊 PROJECTS DATA PROVIDER
/// ============================================
///
/// This file automatically uses your projects from projects_config.dart
/// No need to edit this file - update projects_config.dart instead!
///
/// ============================================

class ProjectsData {
  /// Get projects from configuration
  static List<ProjectModel> get projects => ProjectsConfig.projects;
}
