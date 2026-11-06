import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/work_allocation_provider.dart';
import '../../../../core/constants/app_colors.dart';

class LevelRangeDialog extends StatefulWidget {
  const LevelRangeDialog({super.key});

  @override
  State<LevelRangeDialog> createState() => _LevelRangeDialogState();
}

class _LevelRangeDialogState extends State<LevelRangeDialog> {
  // Store local dialog selection state without altering the provider immediately
  int? _selectedRangeStart;
  int? _selectedRangeEnd;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WorkAllocationProvider>();

    // Generate preset ranges (1-5, 6-10, 11-15, ..., up to 91)
    final ranges = [
      for (int i = 1; i <= 91; i += 5)
        {'start': i, 'end': (i + 4 > 91 ? 91 : i + 4)}
    ];

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
                  'Select Level Range',
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

            // Range Preset Grid
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: ranges.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.8,
                ),
                itemBuilder: (context, index) {
                  final range = ranges[index];
                  final start = range['start']!;
                  final end = range['end']!;
                  final isSelected = (_selectedRangeStart == start && _selectedRangeEnd == end);

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedRangeStart = start;
                        _selectedRangeEnd = end;
                      });

                      // ONLY select levels in provider on explicit tap
                      final startingIndex = provider.selectLevelRangeByNumbers(start, end);

                      // Dismiss and return index to update UI page
                      Navigator.pop(context, startingIndex);
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
                        'Level $start - Level $end',
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