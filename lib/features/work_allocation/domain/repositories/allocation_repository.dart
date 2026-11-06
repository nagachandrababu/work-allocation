import '../entities/project.dart';
import '../entities/technician.dart';
import '../entities/activity.dart';
import '../entities/allocation.dart';

abstract class AllocationRepository {
  Future<List> getProjects();
  Future<List> getActivities();
  Future<List> getTechnicians();
  Future<List> getSubcontractorCompanies();
  Future submitAllocations(List allocations);
}