class ActivityModel {
  final int id;
  final String description;
  final DateTime createdAt;

  ActivityModel({
    required this.id,
    required this.description,
    required this.createdAt,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as int,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
