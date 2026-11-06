import 'package:get_it/get_it.dart';
import '../../features/work_allocation/data/datasources/allocation_local_datasource.dart';
import '../../features/work_allocation/data/repositories/allocation_repository_impl.dart';
import '../../features/work_allocation/domain/repositories/allocation_repository.dart';
import '../../features/work_allocation/presentation/providers/work_allocation_provider.dart';

final sl = GetIt.instance;

Future initDependencies() async {

  sl.registerLazySingleton<AllocationLocalDataSource>(
        () => AllocationLocalDataSourceImpl(),
  );

  // Repositories (Bind implementation to abstract interface)
  sl.registerLazySingleton<AllocationRepository>(
        () => AllocationRepositoryImpl(localDataSource: sl()),
  );


// Providers
  sl.registerFactory(
        () => WorkAllocationProvider(repository: sl()),
  );
}