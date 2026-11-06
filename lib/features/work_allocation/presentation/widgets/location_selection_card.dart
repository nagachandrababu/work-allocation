import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_allocation_app/features/work_allocation/presentation/widgets/unit_range_dialogue.dart';
import '../providers/work_allocation_provider.dart';
import '../../../../core/constants/app_colors.dart';

import 'level_range_dialogue.dart';


class LocationSelectionCard extends StatefulWidget {
  const LocationSelectionCard({super.key});

  @override
  State<LocationSelectionCard> createState() => _LocationSelectionCardState();
}

class _LocationSelectionCardState extends State<LocationSelectionCard> {
  String _locationSearchQuery = '';
  int _levelPage = 1;
  int _unitPage = 1;
  final int _itemsPerPage = 5; // 5 items per page

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkAllocationProvider>();

    // 1. Filter levels and units based on search input
    final filteredLevels = provider.levels.where((lvl) {
      return lvl.name.toLowerCase().contains(_locationSearchQuery.toLowerCase());
    }).toList();

    final filteredUnits = provider.units.where((unit) {
      return unit.name.toLowerCase().contains(_locationSearchQuery.toLowerCase());
    }).toList();

    // 2. Compute Level Pagination
    final totalLevelPages = (filteredLevels.length / _itemsPerPage).ceil();
    if (_levelPage > totalLevelPages && totalLevelPages > 0) {
      _levelPage = totalLevelPages;
    }
    final levelStartIndex = (_levelPage - 1) * _itemsPerPage;
    final levelEndIndex = (levelStartIndex + _itemsPerPage < filteredLevels.length)
        ? levelStartIndex + _itemsPerPage
        : filteredLevels.length;
    final paginatedLevels = filteredLevels.isEmpty
        ? []
        : filteredLevels.sublist(levelStartIndex, levelEndIndex);

    // 3. Compute Unit Pagination
    final totalUnitPages = (filteredUnits.length / _itemsPerPage).ceil();
    if (_unitPage > totalUnitPages && totalUnitPages > 0) {
      _unitPage = totalUnitPages;
    }
    final unitStartIndex = (_unitPage - 1) * _itemsPerPage;
    final unitEndIndex = (unitStartIndex + _itemsPerPage < filteredUnits.length)
        ? unitStartIndex + _itemsPerPage
        : filteredUnits.length;
    final paginatedUnits = filteredUnits.isEmpty
        ? []
        : filteredUnits.sublist(unitStartIndex, unitEndIndex);

    // 4. Dynamic Level Range Display Label (defaults to Level 1 - Level 2 if nothing selected)
    String levelRangeLabel = 'Level 1 - Level 5';
    if (provider.selectedLevels.isNotEmpty) {
      final firstLevel = provider.selectedLevels.first.name;
      final lastLevel = provider.selectedLevels.last.name;
      levelRangeLabel = provider.selectedLevels.length == 1
          ? firstLevel
          : '$firstLevel - $lastLevel';
    }

    return Card(
      key: const Key('locationCard'),
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
            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  'Select levels & units',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),



            // Search Input
            const Text(
              'Search Location',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 36,
              child: TextField(
                key: const Key('locationSearch'),
                onChanged: (val) {
                  setState(() {
                    _locationSearchQuery = val;
                    _levelPage = 1;
                    _unitPage = 1;
                  });
                },
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'Search levels or units...',
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
            const SizedBox(height: 14),

            // --- LEVELS SECTION CONTROL ROW (Levels label removed) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularNavButton(
                  icon: Icons.chevron_left_rounded,
                  onPressed: _levelPage > 1 ? () => setState(() => _levelPage--) : null,
                ),
                // Centered Range Selector Pill (Levels text label removed)
                InkWell(
                  onTap: () async {
                    final int? startingIndex = await showDialog<int>(
                      context: context,
                      builder: (_) => const LevelRangeDialog(),
                    );
                    if (startingIndex != null && startingIndex != -1) {
                      setState(() {
                        _levelPage = (startingIndex ~/ _itemsPerPage) + 1;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          levelRangeLabel,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down_rounded, size: 18, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
                _buildCircularNavButton(
                  icon: Icons.chevron_right_rounded,
                  onPressed: _levelPage < totalLevelPages ? () => setState(() => _levelPage++) : null,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Levels Multi-Select Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = (constraints.maxWidth - 16) / 3;
                final rows = (paginatedLevels.length / 3).ceil();
                final gridHeight = (rows * itemWidth) + ((rows - 1) * 8);

                return SizedBox(
                  height: gridHeight > 0 ? gridHeight : itemWidth,
                  child: paginatedLevels.isEmpty
                      ? const Center(child: Text('No levels found', style: TextStyle(fontSize: 11, color: AppColors.muted)))
                      : GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: paginatedLevels.length,
                    itemBuilder: (context, index) {
                      final level = paginatedLevels[index];
                      final isSelected = provider.selectedLevels.contains(level);

                      return InkWell(
                        onTap: () => provider.toggleLevel(level),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primarySoft : AppColors.surface,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.lineStrong,
                              width: isSelected ? 1.5 : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              level.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                color: isSelected ? AppColors.primary : AppColors.ink,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 14),

            // --- UNITS SECTION CONTROL ROW ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularNavButton(
                  icon: Icons.chevron_left_rounded,
                  onPressed: _unitPage > 1 ? () => setState(() => _unitPage--) : null,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 0.8),
                    ),
                    child: InkWell(
                     onTap: () => showDialog(
                       context: context,
                       builder: (_) => const UnitRangeDialog(),
                     ),
                     child: const Text(
                       'Unit 1',
                       textAlign: TextAlign.center,
                       style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.primary),
                     ),
                                          ),
                  ),
                ),
                _buildCircularNavButton(
                  icon: Icons.chevron_right_rounded,
                  onPressed: _unitPage < totalUnitPages ? () => setState(() => _unitPage++) : null,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Units Multi-Select Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = (constraints.maxWidth - 16) / 3;
                return SizedBox(
                  height: itemWidth,
                  child: paginatedUnits.isEmpty
                      ? const Center(child: Text('No units found', style: TextStyle(fontSize: 11, color: AppColors.muted)))
                      : GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: paginatedUnits.length,
                    itemBuilder: (context, index) {
                      final unit = paginatedUnits[index];
                      final isSelected = provider.selectedUnits.contains(unit);

                      return InkWell(
                        onTap: () => provider.toggleUnit(unit),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primarySoft : AppColors.surface,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.lineStrong,
                              width: isSelected ? 1.5 : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              unit.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                color: isSelected ? AppColors.primary : AppColors.ink,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 14),

            // --- SELECTED LOCATION SUMMARY CHIPS ---
            if (provider.selectedLevels.isNotEmpty || provider.selectedUnits.isNotEmpty || provider.selectedCradleCode != null) ...[
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
                          'Selected Location Summary (${provider.selectedLevels.length + provider.selectedUnits.length})',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        InkWell(
                          onTap: () => provider.clearSelectedLocations(),
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
                      children: [
                        if (provider.selectedCradleCode != null)
                          Chip(
                            label: Text('Code: ${provider.selectedCradleCode}', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                            backgroundColor: Colors.white,
                            deleteIcon: const Icon(Icons.close_rounded, size: 14, color: AppColors.primary),
                            onDeleted: () => provider.setCradleCode(null),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: AppColors.primary, width: 0.8),
                            ),
                          ),
                        ...provider.selectedLevels.map((lvl) {
                          return Chip(
                            label: Text('Level: ${lvl.name}', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                            backgroundColor: Colors.white,
                            deleteIcon: const Icon(Icons.close_rounded, size: 14, color: AppColors.primary),
                            onDeleted: () => provider.toggleLevel(lvl),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: AppColors.primary, width: 0.8),
                            ),
                          );
                        }),
                        ...provider.selectedUnits.map((unit) {
                          return Chip(
                            label: Text('Unit: ${unit.name}', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                            backgroundColor: Colors.white,
                            deleteIcon: const Icon(Icons.close_rounded, size: 14, color: AppColors.primary),
                            onDeleted: () => provider.toggleUnit(unit),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: AppColors.primary, width: 0.8),
                            ),
                          );
                        }),
                      ],
                    ),

                  ],
                ),
              ),

            ],
            // Cradle / Mast Climber Dropdown
            const Text(
              'Cradle / Mast Climber Code',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted),
            ),
            const SizedBox(height: 6),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppColors.lineStrong),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: provider.selectedCradleCode,
                  hint: const Text('Select cradle code...', style: TextStyle(fontSize: 11, color: AppColors.muted)),
                  isExpanded: true,
                  items: provider.cradleCodes.map((code) {
                    return DropdownMenuItem(
                      value: code,
                      child: Text(code, style: const TextStyle(fontSize: 12, color: AppColors.ink, fontWeight: FontWeight.w600)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) provider.setCradleCode(val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularNavButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 28,
      height: 28,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.lineStrong),
            color: onPressed != null ? AppColors.surface : Colors.grey.shade100,
          ),
          child: Icon(
            icon,
            size: 16,
            color: onPressed != null ? AppColors.ink : AppColors.muted,
          ),
        ),
      ),
    );
  }
}