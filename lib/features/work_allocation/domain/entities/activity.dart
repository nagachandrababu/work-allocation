import 'package:equatable/equatable.dart';

class Activity extends Equatable {
  final String id;
  final String name;
  final List subActivities;

  const Activity({
    required this.id,
    required this.name,
    required this.subActivities,
  });

  @override
  List<Object?> get props => [id, name, subActivities];
}

class SubActivity extends Equatable {
  final String id;
  final String name;
  final String parentActivityName;

  const SubActivity({
    required this.id,
    required this.name,
    required this.parentActivityName,
  });

  @override
  List<Object?> get props => [id, name, parentActivityName];
}