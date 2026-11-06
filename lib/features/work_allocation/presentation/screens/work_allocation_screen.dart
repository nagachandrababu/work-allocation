import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/work_allocation_provider.dart';
import '../widgets/allocation_header.dart';
import '../widgets/project_details_card.dart';
import '../widgets/activity_selection_card.dart';
import '../widgets/location_selection_card.dart';
import '../widgets/technician_selection_card.dart';
import '../widgets/start_time_card.dart';
import '../widgets/allocation_bottom_actions.dart';
import '../../domain/entities/allocation.dart';
import '../../../../core/constants/app_colors.dart';

class WorkAllocationScreen extends StatefulWidget {
  const WorkAllocationScreen({super.key});
  @override
  State createState() => _WorkAllocationScreenState();
}

class _WorkAllocationScreenState extends State {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<WorkAllocationProvider>().loadInitialData());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkAllocationProvider>();
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: AppColors.canvas,
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.isSummaryView
                  ? _buildSummaryView(provider)
                  : _buildAllocationForm(provider),
        ),
      ),
    );
  }

  Widget _buildAllocationForm(WorkAllocationProvider provider) {
    return Column(
      children: [
        AllocationHeader(onHelpPressed: () {}),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const ProjectDetailsCard(),
                const SizedBox(height: 8),
                const StartTimeCard(),
                const SizedBox(height: 8),if (provider.selectedScope == AllocationScope.scl) ...[
                  const TechnicianSelectionCard(),
                  const SizedBox(height: 8),
                ],
                const ActivitySelectionCard(),
                const SizedBox(height: 8),
                const LocationSelectionCard(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        const AllocationBottomActions(),
      ],
    );
  }

  Widget _buildSummaryView(WorkAllocationProvider provider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Allocation Summary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('${provider.savedAllocations.length} Allocations',
                  style: const TextStyle(color: AppColors.muted)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.savedAllocations.length,
            itemBuilder: (context, index) {
              final alloc = provider.savedAllocations[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}. ${alloc.projectName} (${alloc.tower})',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                          'Activity: ${alloc.activityName} -${alloc.subActivityName ?? "N/A"}'),
                      Text('Units: ${alloc.selectedUnits.join(", ")}'),
                      Text('Start Time: ${alloc.startTime}'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => provider.toggleSummaryView(false),
                  child: const Text('Back to Edit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('All Allocations Submitted Successfully!')),
                    );
                  },
                  child: const Text('Submit All',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
