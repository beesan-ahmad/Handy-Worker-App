import 'package:cloud_firestore/cloud_firestore.dart';

import 'Review.dart';

class ReviewsService {
  final CollectionReference reviewsCollection =
      FirebaseFirestore.instance.collection('reviews');

  Future<List<Review>> getReviewsForWorker(String workerId) async {
    QuerySnapshot snapshot = await reviewsCollection
        .where('workerId', isEqualTo: workerId)
        .get();

    List<Review> reviews = snapshot.docs.map((doc) {
      return Review(
        id: doc.id,
        userId: doc['userId'],
        workerId: doc['workerId'],
        text: doc['text'],
        rating: (doc['rating'] ?? 0.0).toDouble(),
        timestamp: (doc['timestamp'] as Timestamp).toDate(),
      );
    }).toList();

    return reviews;
  }

  Future<void> addReview(
    String workerId,
    String userId,
    String text,
    double rating,
    DateTime timestamp,
  ) async {
    await reviewsCollection.add({
      'workerId': workerId,
      'userId': userId,
      'text': text,
      'rating': rating,
      'timestamp': timestamp,
    });
  }
}
