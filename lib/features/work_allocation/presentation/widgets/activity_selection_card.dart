import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/work_allocation_provider.dart';
import '../../../../core/constants/app_colors.dart';

class ActivitySelectionCard extends StatefulWidget {
  const ActivitySelectionCard({super.key});

  @override
  State<ActivitySelectionCard> createState() => _ActivitySelectionCardState();
}

class _ActivitySelectionCardState extends State<ActivitySelectionCard> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkAllocationProvider>();

    // Filter activities based on search query
    final filteredActivities = provider.activities.where((act) {
      return act.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: AppColors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Title & Subtitle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Activity',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  'Select one',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Activity Search Bar with HTML-matching Search Icon
            SizedBox(
              height: 36,
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'Search activities...',
                  hintStyle: const TextStyle(fontSize: 11, color: AppColors.muted),
                  prefixIcon: const Icon(Icons.search_rounded, size: 16, color: AppColors.muted),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: AppColors.lineStrong),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Activity',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 8),
            // Horizontal Activity Chips / Boxes List
            SizedBox(
              height: 42,
              child: filteredActivities.isEmpty
                  ? const Center(
                child: Text(
                  'No activities found',
                  style: TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              )
                  : ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filteredActivities.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final act = filteredActivities[index];
                  final isSelected = provider.selectedActivity == act;
                  return ChoiceChip(
                    label: Text(act.name),
                    selected: isSelected,
                    selectedColor: AppColors.primarySoft,
                    backgroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.lineStrong,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      color: isSelected ? AppColors.primary : AppColors.ink,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    ),
                    onSelected: (_) => provider.selectActivity(act),
                  );
                },
              ),
            ),

            // Subactivity Section (Conditional)
            if (provider.selectedActivity != null) ...[
              const SizedBox(height: 12),
              const Divider(color: Color(0xFFEDF2F7), height: 1, thickness: 1),
              const SizedBox(height: 10),
              const Text(
                'Subactivity',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 54,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.selectedActivity!.subActivities.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final sub = provider.selectedActivity!.subActivities[index];
                    final isSelected = provider.selectedSubActivity == sub;
                    return InkWell(
                      onTap: () => provider.selectSubActivity(sub),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primarySoft : Colors.white,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.lineStrong,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            sub.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                              color: isSelected ? AppColors.primary : AppColors.ink,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}