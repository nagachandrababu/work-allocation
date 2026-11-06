import '../../domain/entities/project.dart';
import '../../domain/entities/technician.dart';

class VoiceParseResult {
  final Project? project;
  final String? scope;
  final String? activity;
  final String? subactivity;
  final List<String> levels;
  final List<String> units;
  final List<Technician> technicians;
  final String? startTime;

  VoiceParseResult({
    this.project,
    this.scope,
    this.activity,
    this.subactivity,
    this.levels = const [],
    this.units = const [],
    this.technicians = const [],
    this.startTime,
  });
}

class VoiceAllocationParser {
  VoiceParseResult parse(String transcript, List<Project> projects, List<Technician> technicians) {
    final lower = transcript.toLowerCase();

    Project? matchedProject;
    for (final p in projects) {
      if (lower.contains(p.name.toLowerCase())) {
        matchedProject = p;
        break;
      }
    }

    String? scope;
    if (lower.contains('subcontractor') || lower.contains('sub contractor')) {
      scope = 'Sub Contractor';
    } else if (lower.contains('scl')) {
      scope = 'SCL';
    }

    return VoiceParseResult(
      project: matchedProject,
      scope: scope,
    );
  }
}
