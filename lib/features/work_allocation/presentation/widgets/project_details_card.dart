import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/work_allocation_provider.dart';
import '../../domain/entities/allocation.dart';
import '../../../../core/constants/app_colors.dart';

class ProjectDetailsCard extends StatelessWidget {
  const ProjectDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkAllocationProvider>();

    if (provider.isLoading || provider.selectedProject == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Project', style: TextStyle(fontSize: 10, color: AppColors.muted)),
                  const SizedBox(height: 4),
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: AppColors.lineStrong),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: provider.selectedProject!.name,
                        icon: const Icon(Icons.expand_more, size: 18, color: AppColors.ink), // HTML matching chevron icon
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.ink),
                        items: provider.projects.map((p) {
                          return DropdownMenuItem<String>(value: p.name, child: Text(p.name,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.ink),
                          ));
                        }).toList(),
                        selectedItemBuilder: (BuildContext context) {
                          return provider.projects.map<Widget>((p) {
                            return Text(
                              p.name,
                              //overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.ink),
                            );
                          }).toList();
                        },
                        onChanged: (val) {
                          if (val != null) {
                            final p = provider.projects.firstWhere((element) => element.name == val);
                            provider.selectProject(p);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tower', style: TextStyle(fontSize: 10, color: AppColors.muted)),
                  const SizedBox(height: 4),
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: AppColors.lineStrong),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: provider.selectedTower,
                        icon: const Icon(Icons.expand_more, size: 18, color: AppColors.ink),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.ink),
                        items: provider.selectedProject!.towers.map((t) {
                          return DropdownMenuItem<String>(value: t, child: Text(t));
                        }).toList(),
                        selectedItemBuilder: (BuildContext context) {
                          return provider.selectedProject!.towers.map<Widget>((t) {
                            return Text(
                              t,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.ink),
                            );
                          }).toList();
                        },
                        onChanged: (val) {
                          if (val != null) provider.selectTower(val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sub Division', style: TextStyle(fontSize: 10, color: AppColors.muted)),
                  const SizedBox(height: 8),
                  Text(
                    provider.selectedProject!.subDivision,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.ink),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Scope', style: TextStyle(fontSize: 10, color: AppColors.muted)),
                  const SizedBox(height: 4),
                  Container(
                    height: 36,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: AppColors.lineStrong),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<AllocationScope>(
                        isExpanded: true,
                        value: provider.selectedScope,
                        icon: const Icon(Icons.expand_more, size: 18, color: AppColors.ink),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.ink),
                        items: const [
                          DropdownMenuItem(value: AllocationScope.scl, child: Text('SCL')),
                          DropdownMenuItem(value: AllocationScope.subContractor, child: Text('Sub Contractor')),
                        ],

                        onChanged: (val) {
                          if (val != null) provider.selectScope(val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );


  }
}