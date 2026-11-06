import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/injection.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/work_allocation/presentation/providers/work_allocation_provider.dart';
import 'features/work_allocation/presentation/screens/work_allocation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WorkAllocationProvider>(
      create: (_) => di.sl<WorkAllocationProvider>(),
      child: MaterialApp(
        title: 'Work Allocation',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const WorkAllocationScreen(),
      ),
    );
  }
}