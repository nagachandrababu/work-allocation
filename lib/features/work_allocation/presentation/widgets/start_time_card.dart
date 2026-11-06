import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/work_allocation_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class StartTimeCard extends StatelessWidget {
  const StartTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkAllocationProvider>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: AppColors.ink),
                    SizedBox(width: 6),
                    Text('Start Time',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: provider.startTime,
                    );
                    if (picked != null) provider.setStartTime(picked);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 122,
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.lineStrong),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          provider.startTime.format(context),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const Icon(
                          Icons.access_time_rounded,
                          size: 15,
                          color: AppColors.muted,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (provider.isLateReasonRequired) ...[
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 8),
                child: Divider(
                  color: Color(0xFFEDF2F7), // Matches HTML border-top: #edf2f7
                  thickness: 1,
                  height: 1,
                ),
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Late Allocation Reason (Required)',
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.ink,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  DropdownButton<String>(
                    value: provider.selectedLateReason,
                    icon: const Icon(Icons.expand_more, size: 18, color: AppColors.ink), // HTML matching chevron icon
                    hint: const Text('Select reason',
                        style: TextStyle(fontSize: 11)),
                    items: AppConstants.lateReasons.map((r) {
                      return DropdownMenuItem<String>(
                          value: r,
                          child: Text(r, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.ink)));
                    }).toList(),
                    onChanged: (val) => provider.setLateReason(val),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
