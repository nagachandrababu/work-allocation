import '../../domain/entities/project.dart';
import '../../domain/entities/technician.dart';
import '../../domain/entities/activity.dart';
import '../../domain/entities/allocation.dart';
import '../../domain/repositories/allocation_repository.dart';
import '../datasources/allocation_local_datasource.dart';

class AllocationRepositoryImpl implements AllocationRepository {
  final AllocationLocalDataSource localDataSource;

  AllocationRepositoryImpl({required this.localDataSource});

  @override
  Future<List> getProjects() => localDataSource.getProjects();

  @override
  Future<List> getActivities() => localDataSource.getActivities();

  @override
  Future<List> getTechnicians() => localDataSource.getTechnicians();

  @override
  Future<List> getSubcontractorCompanies() => localDataSource.getSubcontractorCompanies();

  @override
  Future submitAllocations(List allocations) async {
// Mock successful submission delay
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }
}