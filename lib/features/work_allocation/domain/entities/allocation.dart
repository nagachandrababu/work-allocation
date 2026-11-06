import 'package:equatable/equatable.dart';
import 'technician.dart';enum AllocationScope { scl, subContractor }
enum AllocationType { individual, team }class Allocation extends Equatable {
  final String id;
  final String projectName;
  final String tower;
  final String subDivision;
  final AllocationScope scope;
  final String activityName;
  final String? subActivityName;
  final List selectedLevels;
  final List selectedUnits;
  final String? cradleCode;
  final String startTime;
  final String? lateReason;// SCL workflow
  final AllocationType? allocationType;
  final List selectedTechnicians;
  final Technician? teamCaptain;// Subcontractor workflow
  final String? subcontractorCompany;
  final int subcontractorCount;
  final bool sclTechUsed;
  final int sclTechCount;
  final List subcontractorSclTechnicians;final DateTime createdAt;const Allocation({
    required this.id,
    required this.projectName,
    required this.tower,
    required this.subDivision,
    required this.scope,
    required this.activityName,
    this.subActivityName,
    required this.selectedLevels,
    required this.selectedUnits,
    this.cradleCode,
    required this.startTime,
    this.lateReason,
    this.allocationType,
    this.selectedTechnicians = const [],
    this.teamCaptain,
    this.subcontractorCompany,
    this.subcontractorCount = 0,
    this.sclTechUsed = false,
    this.sclTechCount = 0,
    this.subcontractorSclTechnicians = const [],
    required this.createdAt,
  });String get signature {
    final sortedUnits = List.from(selectedUnits)..sort();
    if (scope == AllocationScope.scl) {
      final techIds = selectedTechnicians.map((t) => t.id).toList()..sort();
      return '$projectName|$tower\vert{}$scope|$activityName\vert{}$subActivityName|${sortedUnits.join(",")}\vert{}$startTime|$lateReason\vert{}${techIds.join(",")}';
    } else {
      final sclTechIds = subcontractorSclTechnicians.map((t) => t.id).toList()..sort();
      return '$projectName|$tower\vert{}$scope|$activityName\vert{}$subActivityName|${sortedUnits.join(",")}\vert{}$startTime|$lateReason\vert{}$subcontractorCompany|$subcontractorCount\vert{}$sclTechUsed|$sclTechCount\vert{}${sclTechIds.join(",")}';
    }
  }@override
  List<Object?> get props => [
    id,
    projectName,
    tower,
    subDivision,
    scope,
    activityName,
    subActivityName,
    selectedLevels,
    selectedUnits,
    cradleCode,
    startTime,
    lateReason,
    allocationType,
    selectedTechnicians,
    teamCaptain,
    subcontractorCompany,
    subcontractorCount,
    sclTechUsed,
    sclTechCount,
    subcontractorSclTechnicians,
    createdAt,
  ];
}