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
    List<dynamic> rawActivities = json['activities_done'] ?? [];
    List<int> activities = rawActivities.map<int>((e) => int.parse(e)).toList();

    return VisitModel(
      id: json['id'] as int,
      customerId: json['customer_id'] as int,
      visitDate: DateTime.parse(json['visit_date'] as String),
      status: json['status'] as String,
      location: json['location'] as String,
      notes: json['notes'] as String,
      activitiesDone: activities,
      createdAt: DateTime.parse(json['created_at'] as String),
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
}
