class Review {
  final String id;
  final String userId;
  final String workerId;
  final String text;
  final double rating;
  final DateTime timestamp;

  Review({
    required this.id,
    required this.userId,
    required this.workerId,
    required this.text,
    required this.rating,
    required this.timestamp,
  });
}