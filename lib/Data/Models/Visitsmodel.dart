import '../../Domain/Entities/VisitingEntity.dart';

class VisitModel {
  final int id;
  final int customerId;
  final DateTime visitDate;
  final String status;
  final String location;
  final String notes;
  final List<int> activitiesDone;
  final DateTime createdAt;

  VisitModel({
    required this.id,
    required this.customerId,
    required this.visitDate,
    required this.status,
    required this.location,
    required this.notes,
    required this.activitiesDone,
    required this.createdAt,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    final rawActivities = json['activities_done'] as List<dynamic>? ?? [];
    final activities = rawActivities.map<int>((e) {
      if (e is int) return e;
      if (e is String) return int.tryParse(e) ?? 0;
      return 0;
    }).toList();

    return VisitModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      customerId: json['customer_id'] is int
          ? json['customer_id']
          : int.tryParse(json['customer_id']?.toString() ?? '') ?? 0,
      visitDate: json['visit_date'] != null
          ? DateTime.tryParse(json['visit_date'] as String) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] as String? ?? '',
      location: json['location'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      activitiesDone: activities,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'visit_date': visitDate.toIso8601String(),
      'status': status,
      'location': location,
      'notes': notes,
      'activities_done': activitiesDone.map((e) => e.toString()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }


  VisitEntity toEntity() {
    return VisitEntity(
      id: id,
      customerId: customerId,
      visitDate: visitDate,
      status: status,
      location: location,
      notes: notes,
      activitiesDone: activitiesDone,
      createdAt: createdAt,
    );
  }


}
