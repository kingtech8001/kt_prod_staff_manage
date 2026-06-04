class PerformanceReviewModel {
  final String id;
  final String employeeId;
  final double rating;
  final String review;
  final DateTime reviewDate;
  final String? reviewerId;

  PerformanceReviewModel({
    required this.id,
    required this.employeeId,
    required this.rating,
    required this.review,
    required this.reviewDate,
    this.reviewerId,
  });

  factory PerformanceReviewModel.fromJson(Map<String, dynamic> json) {
    return PerformanceReviewModel(
      id: json['id'],
      employeeId: json['employee_id'],
      rating: (json['rating'] as num).toDouble(),
      review: json['review'],
      reviewDate: DateTime.parse(json['review_date']),
      reviewerId: json['reviewer_id'],
    );
  }
}
