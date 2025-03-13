import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<bool> saveReview(String movieId, double rating, String review) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      print("No user logged in.");
      return false;
    }

    try {
      await _db.collection('reviews').doc("$userId-$movieId").set({
        'userId': userId,
        'movieId': movieId,
        'rating': rating,
        'review': review,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print("Review saved successfully!");
      return true;
    } catch (e) {
      print("Error saving review: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserReview(String movieId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return null;

    try {
      final doc = await _db.collection('reviews').doc("$userId-$movieId").get();
      if (doc.exists) {
        return doc.data();
      }
    } catch (e) {
      print("Error fetching review: $e");
    }
    return null;
  }
}