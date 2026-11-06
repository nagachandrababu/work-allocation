import 'package:equatable/equatable.dart';

enum TechnicianStatus { present, absent }

class Technician extends Equatable {
  final String id;
  final String name;
  final TechnicianStatus status;
  final bool isAllocated;

  const Technician({
    required this.id,
    required this.name,
    required this.status,
    this.isAllocated = false,
  });

  Technician copyWith({
    String? id,
    String? name,
    TechnicianStatus? status,
    bool? isAllocated,
  }) {
    return Technician(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      isAllocated: isAllocated ?? this.isAllocated,
    );
  }

  @override
  List<Object?> get props => [id, name, status, isAllocated];
}