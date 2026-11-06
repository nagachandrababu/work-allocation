import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/work_allocation_provider.dart';
import '../../domain/entities/technician.dart';
import '../../../../core/constants/app_colors.dart';

class TechnicianSelectionCard extends StatefulWidget {
  const TechnicianSelectionCard({super.key});

  @override
  State<TechnicianSelectionCard> createState() => _TechnicianSelectionCardState();
}

class _TechnicianSelectionCardState extends State<TechnicianSelectionCard> {
  String _searchQuery = '';
  String _activeFilter = 'All'; // 'All', 'Present', 'Absent'
  int _currentPage = 1;
  final int _itemsPerPage = 4;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkAllocationProvider>();

    // 1. Filter technicians by search query and status tab
    var filteredTechs = provider.technicians.where((tech) {
      final matchesSearch = tech.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tech.id.toLowerCase().contains(_searchQuery.toLowerCase());

      if (_activeFilter == 'Present') {
        return matchesSearch && tech.status == TechnicianStatus.present;
      } else if (_activeFilter == 'Absent') {
        return matchesSearch && tech.status == TechnicianStatus.absent;
      }
      return matchesSearch;
    }).toList();

    // 2. Pagination logic
    final totalPages = (filteredTechs.length / _itemsPerPage).ceil();
    if (_currentPage > totalPages && totalPages > 0) {
      _currentPage = totalPages;
    }
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage < filteredTechs.length)
        ? startIndex + _itemsPerPage
        : filteredTechs.length;
    final paginatedTechs = filteredTechs.isEmpty
        ? <Technician>[]
        : filteredTechs.sublist(startIndex, endIndex);

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
                  'People Allocation',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  'Technicians',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Search Bar with HTML-matching Search Icon
            SizedBox(
              height: 36,
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                    _currentPage = 1;
                  });
                },
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'Search technicians...',
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

            // Controls Row: [Prev with Chevron] [Boxed All | Present | Absent Filters] [Next with Chevron]
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous Button with left chevron icon
                SizedBox(
                  height: 32,
                  child: OutlinedButton.icon(
                    onPressed: _currentPage > 1
                        ? () => setState(() => _currentPage--)
                        : null,
                    icon: const Icon(Icons.chevron_left_rounded, size: 16, color: AppColors.ink),
                    label: const Text('Prev', style: TextStyle(fontSize: 10, color: AppColors.ink, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      side: const BorderSide(color: AppColors.lineStrong),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),

                // Boxed Filter Tabs Container (All, Present, Absent) matching HTML UI layout
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: AppColors.lineStrong),
                  ),
                  child: Row(
                    children: [
                      _buildFilterBox('All'),
                      const SizedBox(width: 2),
                      _buildFilterBox('Present'),
                      const SizedBox(width: 2),
                      _buildFilterBox('Absent'),
                    ],
                  ),
                ),

                // Next Button with right chevron icon
                SizedBox(
                  height: 32,
                  child: OutlinedButton(
                    onPressed: _currentPage < totalPages
                        ? () => setState(() => _currentPage++)
                        : null,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      side: const BorderSide(color: AppColors.lineStrong),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Next', style: TextStyle(fontSize: 10, color: AppColors.ink, fontWeight: FontWeight.w600)),
                        SizedBox(width: 2),
                        Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.ink),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Horizontal Square Technician Cards List
            SizedBox(
              height: 90,
              child: paginatedTechs.isEmpty
                  ? const Center(
                child: Text(
                  'No technicians found',
                  style: TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              )
                  : ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: paginatedTechs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final tech = paginatedTechs[index];
                  final isSelected = provider.selectedTechnicians.contains(tech);
                  final isPresent = tech.status == TechnicianStatus.present;

                  return InkWell(
                    onTap: tech.isAllocated ? null : () => provider.toggleTechnician(tech),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 90,
                      height: 90,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                      decoration: BoxDecoration(
                        color: tech.isAllocated
                            ? Colors.grey.shade100
                            : isSelected
                            ? AppColors.primarySoft
                            : isPresent
                            ? const Color(0xFFF4FBF6)
                            : const Color(0xFFFFF5F5),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : isPresent
                              ? AppColors.success.withOpacity(0.3)
                              : AppColors.danger.withOpacity(0.3),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isPresent ? AppColors.success : AppColors.danger,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isPresent ? 'Present' : 'Absent',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: isPresent ? AppColors.success : AppColors.danger,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tech.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: tech.isAllocated ? AppColors.muted : AppColors.ink,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tech.isAllocated ? 'Allocated' : 'ID: ${tech.id}',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: AppColors.muted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Selected Technicians Section inside HTML-styled Box Container at the bottom
            if (provider.selectedTechnicians.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.lineStrong),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Selected Technicians (${provider.selectedTechnicians.length})',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        InkWell(
                          onTap: () => provider.clearSelectedTechnicians(),
                          child: const Text(
                            'Clear All',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.danger,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: provider.selectedTechnicians.map((tech) {
                        return Chip(
                          label: Text(tech.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          backgroundColor: Colors.white,
                          deleteIcon: const Icon(Icons.close_rounded, size: 14, color: AppColors.primary),
                          onDeleted: () => provider.toggleTechnician(tech),
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: AppColors.primary, width: 0.8),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBox(String label) {
    final isSelected = _activeFilter == label;
    return InkWell(
      onTap: () => setState(() {
        _activeFilter = label;
        _currentPage = 1;
      }),
      borderRadius: BorderRadius.circular(7),
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }
}