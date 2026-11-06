import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/work_allocation/presentation/providers/work_allocation_provider.dart';
import 'features/work_allocation/presentation/screens/work_allocation_screen.dart';

class WorkAllocationApp extends StatelessWidget {
  const WorkAllocationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => sl<WorkAllocationProvider>()..loadInitialData(),
        ),
      ],
      child: MaterialApp(
        title: 'Work Allocation',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const WorkAllocationScreen(),
      ),
    );
  }
}
