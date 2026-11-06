import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String name;
  final String subDivision;
  final String defaultScope;
  final List towers;

  const Project({
    required this.id,
    required this.name,
    required this.subDivision,
    required this.defaultScope,
    required this.towers,
  });

  @override
  List<Object?> get props => [id, name, subDivision, defaultScope, towers];
}