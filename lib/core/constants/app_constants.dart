class AppConstants {
  AppConstants._();

  static const double cardRadius = 15.0;
  static const int minLevel = 1;
  static const int maxLevel = 91;
  static const int levelRangeStep = 5;

  static const int lateStartHourMin = 6;
  static const int lateStartHourMax = 7;

  static const List lateReasons = [
    'No Reason',
    'Work started before entry',
    'Supervisor approval delay',
    'Technician reassignment',
    'Material or access delay',
    'Emergency work',
  ];

  static const List cradleCodes = [
    'TA-CR-01',
    'TA-CR-02',
    'TA-CR-03',
    'TA-CR-04',
    'TA-CR-05',
  ];
}