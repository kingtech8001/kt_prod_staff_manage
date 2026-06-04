class AchievementModel {
  final String id;
  final String employeeId;
  final String title;
  final String? description;
  final DateTime awardedAt;

  AchievementModel({
    required this.id,
    required this.employeeId,
    required this.title,
    this.description,
    required this.awardedAt,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'],
      employeeId: json['employee_id'],
      title: json['title'],
      description: json['description'],
      awardedAt: DateTime.parse(json['awarded_at']),
    );
  }
}
