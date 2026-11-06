import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/work_allocation_provider.dart';
import '../../../../core/constants/app_colors.dart';

class AllocationBottomActions extends StatelessWidget {
  const AllocationBottomActions({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkAllocationProvider>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                try {
                  provider.saveAndAddNew();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Allocation saved. Add new item.')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                  );
                }
              },
              child: const Text('Save & Add New', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                try {
                  provider.confirmAllocation();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                  );
                }
              },
              child: const Text('Confirm Allocation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );


  }
}