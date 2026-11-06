import 'package:flutter/material.dart';
import '../../domain/entities/level_item.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/technician.dart';
import '../../domain/entities/activity.dart';
import '../../domain/entities/allocation.dart';
import '../../domain/entities/unit_item.dart';
import '../../domain/repositories/allocation_repository.dart';
import '../../../../core/constants/app_constants.dart';

class WorkAllocationProvider extends ChangeNotifier {
  final AllocationRepository repository;
  WorkAllocationProvider({required this.repository}); // Master Data
  List _projects = [];
  List _activities = [];
  List _technicians = [];
  List _subcontractorCompanies = [];
  bool _isLoading = true;
  bool get isLoading => _isLoading; // Selection States
  Project? _selectedProject;
  String _selectedTower = 'Tower A';
  AllocationScope _selectedScope = AllocationScope.scl;
  Activity? _selectedActivity;
  SubActivity? _selectedSubActivity; // Location
  int _levelRangeIndex = 8; // Default L41-L45 range
  String _activeUnitLevel = 'L47';
  String _peopleSearchQuery = '';
  String _peopleFilter = 'All'; // All, Present, Absent
  final List _selectedTechnicians = [];
  AllocationType _allocationMode =
      AllocationType.individual; // Subcontractor State
  String? _selectedSubcontractorCompany;
  int _subcontractorCount = 0;
  bool _sclTechUsed = false;
  int _sclTechCount = 0;
  final List _subcontractorSclTechs = []; // Timing
  TimeOfDay _startTime = TimeOfDay.now();
  String? _selectedLateReason; // Summary / History
  final List _savedAllocations = [];
  bool _isSummaryView = false; // Getters
  List get projects => _projects;
  List get activities => _activities;
  List get technicians => _technicians;
  List get subcontractorCompanies => _subcontractorCompanies;
  Project? get selectedProject => _selectedProject;
  String get selectedTower => _selectedTower;
  AllocationScope get selectedScope => _selectedScope;
  Activity? get selectedActivity => _selectedActivity;
  SubActivity? get selectedSubActivity => _selectedSubActivity;
  int get levelRangeIndex => _levelRangeIndex;
  String get activeUnitLevel => _activeUnitLevel;
  //Set get selectedLevels => _selectedLevels;
  //Set get selectedUnits => _selectedUnits;
 // String? get selectedCradleCode => _selectedCradleCode;
  String get peopleFilter => _peopleFilter;
  List get selectedTechnicians => _selectedTechnicians;
  AllocationType get allocationMode => _allocationMode;
  String? get selectedSubcontractorCompany => _selectedSubcontractorCompany;
  int get subcontractorCount => _subcontractorCount;
  bool get sclTechUsed => _sclTechUsed;
  int get sclTechCount => _sclTechCount;
  List get subcontractorSclTechs => _subcontractorSclTechs;
  TimeOfDay get startTime => _startTime;
  String? get selectedLateReason => _selectedLateReason;
  List get savedAllocations => _savedAllocations;
  bool get isSummaryView => _isSummaryView;
  bool get isLateReasonRequired {
    final hour = _startTime.hour;
    return hour < AppConstants.lateStartHourMin ||
        hour >= AppConstants.lateStartHourMax;
  }

  // Clear all selected technicians
  void clearSelectedTechnicians() {
    _selectedTechnicians.clear();
    notifyListeners();
  }

  Future loadInitialData() async {
    _isLoading = true;
    notifyListeners();
    _projects = await repository.getProjects();
    _activities = await repository.getActivities();
    _technicians = await repository.getTechnicians();
    _subcontractorCompanies = await repository.getSubcontractorCompanies();

    if (_projects.isNotEmpty) {
      _selectedProject = _projects.first;
    }
    if (_activities.isNotEmpty) {
      _selectedActivity = _activities.first;
    }
    if (_subcontractorCompanies.isNotEmpty) {
      _selectedSubcontractorCompany = _subcontractorCompanies.first;
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectProject(Project project) {
    _selectedProject = project;
    _selectedScope = project.defaultScope == 'Sub Contractor'
        ? AllocationScope.subContractor
        : AllocationScope.scl;
    notifyListeners();
  }

  void selectTower(String tower) {
    _selectedTower = tower;
    notifyListeners();
  }

  void selectScope(AllocationScope scope) {
    _selectedScope = scope;
    notifyListeners();
  }

  void selectActivity(Activity activity) {
    _selectedActivity = activity;
    notifyListeners();
  }

  void selectSubActivity(SubActivity subActivity) {
    _selectedSubActivity = subActivity;
// Auto-select parent activity
    _selectedActivity = _activities.firstWhere(
      (a) => a.name == subActivity.parentActivityName,
      orElse: () => _selectedActivity!,
    );
    notifyListeners();
  }



  // ==========================================
  // 3. LOCATION STATE & LOGIC (Levels, Units, Cradle)
  // ==========================================

  // --- Levels Mock Dataset ---
  final List<LevelItem> _levels = List.generate(
    99,
        (index) {
      final num = (index + 1).toString().padLeft(2, '0');
      return LevelItem(id: 'lvl_$num', name: 'Level $num');
    },
  );

  // --- Units Mock Dataset ---
  final List<UnitItem> _units = const [
    UnitItem(id: 'u_101', name: 'Unit 101'),
    UnitItem(id: 'u_102', name: 'Unit 102'),
    UnitItem(id: 'u_103', name: 'Unit 103'),
    UnitItem(id: 'u_104', name: 'Unit 104'),
    UnitItem(id: 'u_201', name: 'Unit 201'),
    UnitItem(id: 'u_202', name: 'Unit 202'),
    UnitItem(id: 'u_203', name: 'Unit 203'),
    UnitItem(id: 'u_204', name: 'Unit 204'),
  ];

  // --- Cradle / Mast Climber Codes ---
  final List<String> _cradleCodes = const [
    'CR-01 (North Tower)',
    'CR-02 (South Tower)',
    'MC-01 (East Elevation)',
    'MC-02 (West Elevation)',
  ];

  // final List<LevelItem> _levels = [];
  // final List<UnitItem> _units = [];
  // final List<String> _cradleCodes = ['Cradle-01', 'MastClimber-02', 'Cradle-03'];

  final List<LevelItem> _selectedLevels = [];
  final List<UnitItem> _selectedUnits = [];
  String? _selectedCradleCode;

  List<LevelItem> get levels => _levels;
  List<UnitItem> get units => _units;
  List<String> get cradleCodes => _cradleCodes;

  List<LevelItem> get selectedLevels => _selectedLevels;
  List<UnitItem> get selectedUnits => _selectedUnits;
  String? get selectedCradleCode => _selectedCradleCode;

  void setCradleCode(String? code) {
    _selectedCradleCode = code;
    notifyListeners();
  }

  void toggleLevel(LevelItem level) {
    if (_selectedLevels.contains(level)) {
      _selectedLevels.remove(level);
    } else {
      _selectedLevels.add(level);
    }
    notifyListeners();
  }

  void toggleUnit(UnitItem unit) {
    if (_selectedUnits.contains(unit)) {
      _selectedUnits.remove(unit);
    } else {
      _selectedUnits.add(unit);
    }
    notifyListeners();
  }

  void clearSelectedLocations() {
    _selectedLevels.clear();
    _selectedUnits.clear();
    _selectedCradleCode = null;
    notifyListeners();
  }

  void removeUnit(String unit) {
    _selectedUnits.remove(unit);
    notifyListeners();
  }

  // Inside WorkAllocationProvider:

  // Inside WorkAllocationProvider:
  // domain/providers/work_allocation_provider.dart

  // Inside WorkAllocationProvider:

  int selectLevelRangeByNumbers(int startNum, int endNum) {
    _selectedLevels.clear(); // Clear all current selections first
    int firstSelectedIndex = -1;

    for (int i = 0; i < _levels.length; i++) {
      final level = _levels[i];
      final numMatch = RegExp(r'\d+').firstMatch(level.name);

      if (numMatch != null) {
        final levelNum = int.parse(numMatch.group(0)!);

        // Strict range check
        if (levelNum >= startNum && levelNum <= endNum) {
          _selectedLevels.add(level);
          if (firstSelectedIndex == -1) {
            firstSelectedIndex = i;
          }
        }
      }
    }

    notifyListeners();
    return firstSelectedIndex;
  }

  // Inside WorkAllocationProvider:

  void selectLevelRange(LevelItem start, LevelItem end) {
    final startIndex = _levels.indexOf(start);
    final endIndex = _levels.indexOf(end);

    if (startIndex != -1 && endIndex != -1) {
      final min = startIndex < endIndex ? startIndex : endIndex;
      final max = startIndex < endIndex ? endIndex : startIndex;

      for (int i = min; i <= max; i++) {
        if (!_selectedLevels.contains(_levels[i])) {
          _selectedLevels.add(_levels[i]);
        }
      }
      notifyListeners();
    }
  }

  void selectUnitRange(UnitItem start, UnitItem end) {
    final startIndex = _units.indexOf(start);
    final endIndex = _units.indexOf(end);

    if (startIndex != -1 && endIndex != -1) {
      final min = startIndex < endIndex ? startIndex : endIndex;
      final max = startIndex < endIndex ? endIndex : startIndex;

      for (int i = min; i <= max; i++) {
        if (!_selectedUnits.contains(_units[i])) {
          _selectedUnits.add(_units[i]);
        }
      }
      notifyListeners();
    }
  }

  void toggleTechnician(Technician tech) {
    if (tech.isAllocated) return;
    if (_selectedTechnicians.contains(tech)) {
      _selectedTechnicians.remove(tech);
    } else {
      _selectedTechnicians.add(tech);
    }
    if (_selectedTechnicians.length > 1) {
      _allocationMode = AllocationType.team;
    } else {
      _allocationMode = AllocationType.individual;
    }
    notifyListeners();
  }

  void setAllocationMode(AllocationType mode) {
    _allocationMode = mode;
    notifyListeners();
  }

  void setStartTime(TimeOfDay time) {
    _startTime = time;
    if (!isLateReasonRequired) {
      _selectedLateReason = null;
    }
    notifyListeners();
  }

  void setLateReason(String? reason) {
    _selectedLateReason = reason;
    notifyListeners();
  }

  void setSubcontractorCompany(String company) {
    _selectedSubcontractorCompany = company;
    notifyListeners();
  }

  void setSubcontractorCount(int count) {
    _subcontractorCount = count;
    notifyListeners();
  }

  void setSclTechUsed(bool value) {
    _sclTechUsed = value;
    if (!value) _subcontractorSclTechs.clear();
    notifyListeners();
  }

  void toggleSubcontractorSclTech(Technician tech) {
    if (_subcontractorSclTechs.contains(tech)) {
      _subcontractorSclTechs.remove(tech);
    } else {
      _subcontractorSclTechs.add(tech);
    }
    notifyListeners();
  }

  String? validateForm() {
    if (_selectedProject == null) return 'Please select a project';
    if (_selectedUnits.isEmpty) return 'Please select at least one unit';
    if (isLateReasonRequired &&
        (_selectedLateReason == null || _selectedLateReason!.isEmpty)) {
      return 'Please select a late allocation reason';
    }
    if (_selectedScope == AllocationScope.scl) {
      if (_selectedTechnicians.isEmpty)
        return 'Please select at least one technician';
    } else {
      if (_selectedSubcontractorCompany == null)
        return 'Please select a subcontractor company';
      if (_subcontractorCount <= 0)
        return 'Subcontractor technician count must be greater than 0';
      if (_sclTechUsed && _subcontractorSclTechs.isEmpty) {
        return 'Please select SCL technicians used';
      }
    }
    return null;
  }

  void saveAndAddNew() {
    final validationError = validateForm();
    if (validationError != null) throw Exception(validationError);
    final allocation = _createAllocationObject();
    _savedAllocations.add(allocation);

// Mark technicians as allocated
    for (int i = 0; i < _technicians.length; i++) {
      if (_selectedTechnicians.contains(_technicians[i])) {
        _technicians[i] = _technicians[i].copyWith(isAllocated: true);
      }
    }

    _resetFormKeepContext();
    notifyListeners();
  }

  void confirmAllocation() {
    saveAndAddNew();
    _isSummaryView = true;
    notifyListeners();
  }

  void toggleSummaryView(bool show) {
    _isSummaryView = show;
    notifyListeners();
  }

  Allocation _createAllocationObject() {
    final timeFormatted =
        '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
    return Allocation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      projectName: _selectedProject!.name,
      tower: _selectedTower,
      subDivision: _selectedProject!.subDivision,
      scope: _selectedScope,
      activityName: _selectedActivity?.name ?? 'General',
      subActivityName: _selectedSubActivity?.name,
      selectedLevels: _selectedLevels.toList(),
      selectedUnits: _selectedUnits.toList(),
      cradleCode: _selectedCradleCode,
      startTime: timeFormatted,
      lateReason: _selectedLateReason,
      allocationType: _allocationMode,
      selectedTechnicians: List.from(_selectedTechnicians),
      teamCaptain: _allocationMode == AllocationType.team &&
              _selectedTechnicians.isNotEmpty
          ? _selectedTechnicians.first
          : null,
      subcontractorCompany: _selectedSubcontractorCompany,
      subcontractorCount: _subcontractorCount,
      sclTechUsed: _sclTechUsed,
      sclTechCount: _sclTechCount,
      subcontractorSclTechnicians: List.from(_subcontractorSclTechs),
      createdAt: DateTime.now(),
    );
  }

  void _resetFormKeepContext() {
    _selectedUnits.clear();
    _selectedTechnicians.clear();
    _subcontractorSclTechs.clear();
    _subcontractorCount = 0;
    _sclTechUsed = false;
    _selectedSubActivity = null;
    _selectedLateReason = null;
  }
}
