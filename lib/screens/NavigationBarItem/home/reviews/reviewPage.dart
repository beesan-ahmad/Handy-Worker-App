import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:handyworker/screens/NavigationBarItem/home/reviews/Review.dart';
import 'package:handyworker/screens/NavigationBarItem/home/reviews/ReviewsService.dart';

import '../../../../models/worker.dart';
import 'package:intl/intl.dart';

class ReviewPage extends StatefulWidget {
  final Worker worker;

  const ReviewPage({Key? key, required this.worker}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final ReviewsService _reviewsService = ReviewsService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _reviewTextController = TextEditingController();
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ABB3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "${widget.worker.firstName} ${widget.worker.lastName}",
          style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          SizedBox(
            width: 200,
            height: 200,
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.worker.photoUrl.isEmpty ||
                              widget.worker.photoUrl.trim().isEmpty
                          ? 'https://www.w3schools.com/w3images/avatar2.png'
                          : widget.worker.photoUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<List<Review>>(
                  future: _reviewsService.getReviewsForWorker(widget.worker.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error loading reviews'),
                      );
                    }

                    List<Review> reviews = snapshot.data!;
                    double totalRating = 0;

                    for (Review review in reviews) {
                      totalRating += review.rating;
                    }

                    double averageRating = reviews.isNotEmpty ? totalRating / reviews.length : 0;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rating: ${averageRating.toStringAsFixed(1)}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Number of reviews: ${reviews.length}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Review>>(
              future: _reviewsService.getReviewsForWorker(widget.worker.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error loading reviews'),
                  );
                }

                List<Review> reviews = snapshot.data!;

                return ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    Review review = reviews[index];

                    return ListTile(
                      title: Text(review.text),
                      subtitle: Row(
                        children: [
                          Text('${review.rating}'),
                          const SizedBox(width: 5),
                          const Icon(Icons.star, color: Colors.yellow),
                          const SizedBox(width: 5),
                          Text(
                              'stars by someone on ${DateFormat('yyyy-MM-dd / hh:mm').format(review.timestamp)}'),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add your review',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: _rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 24,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _reviewTextController,
                        cursorColor:
                            const Color(0xFF00ABB3), // Set the cursor color
                        decoration: const InputDecoration(
                          hintText: 'Enter your review',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF00ABB3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF00ABB3)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    User? user = _auth.currentUser;

                    if (user == null) {
                      Navigator.pushNamed(context, '/login');
                    } else {
                      // Add the review to the reviews collection
                      await _reviewsService.addReview(
                        widget.worker.id,
                        user.uid,
                        _reviewTextController.text,
                        _rating,
                        DateTime.now(),
                      );

                      _reviewTextController.clear();

                      // Calculate the new average rating and number of reviews
                      List<Review> reviews = await _reviewsService.getReviewsForWorker(widget.worker.id);
                      double totalRating = 0;

                      for (Review review in reviews) {
                        totalRating += review.rating;
                      }

                      double averageRating = reviews.isNotEmpty ? totalRating / reviews.length : 0;
                      int numReviews = reviews.length;

                      // Update the worker document in the workers collection
                      await _firestore.collection('workers').doc(widget.worker.id).update({
                        'rating': averageRating,
                        'numReviews': numReviews,
                      });

                      setState(() {
                        _rating = 0;
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.black26;
                      }
                      return const Color(0xFF00ABB3);
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: const Center(
                      child: Text(
                        'Submit review',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
