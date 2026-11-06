import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AllocationHeader extends StatelessWidget {
  final VoidCallback onHelpPressed;

  const AllocationHeader({
    super.key,
    required this.onHelpPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, size: 28, color: AppColors.ink),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              const Text(
                'Work Allocation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: onHelpPressed,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic, color: Colors.white, size: 20),
            ),
          )
        ],
      ),
    );
  }
}
