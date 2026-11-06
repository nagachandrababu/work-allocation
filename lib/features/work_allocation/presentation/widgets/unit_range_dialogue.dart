import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/work_allocation_provider.dart';
import '../../../../core/constants/app_colors.dart';

class UnitRangeDialog extends StatefulWidget {
  const UnitRangeDialog({super.key});

  @override
  State<UnitRangeDialog> createState() => _UnitRangeDialogState();
}

class _UnitRangeDialogState extends State<UnitRangeDialog> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkAllocationProvider>();
    final units = provider.units; // List of all available UnitItems

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 600),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Title & Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Units',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(
                  height: 32,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      side: const BorderSide(color: AppColors.lineStrong),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      backgroundColor: const Color(0xFFF7FAFC),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.ink),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Scrollable Grid of Individual Unit Buttons
            Expanded(
              child: units.isEmpty
                  ? const Center(child: Text('No units available', style: TextStyle(fontSize: 12, color: AppColors.muted)))
                  : GridView.builder(
                shrinkWrap: true,
                itemCount: 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns of unit buttons
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.8, // Rectangular button proportions
                ),
                itemBuilder: (context, index) {
                  final unit = units[index];
                  final isSelected = provider.selectedUnits.contains(unit);

                  return InkWell(
                    onTap: () {
                      // 1. Toggle unit selection in provider
                      provider.toggleUnit(unit);

                      // 2. Automatically close dialog and return to LocationSelectionCard
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primarySoft : Colors.white,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.lineStrong,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        unit.name, // e.g. "Unit 01", "Unit 02"
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected ? AppColors.primary : AppColors.ink,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}