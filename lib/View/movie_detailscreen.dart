import 'package:flutter/material.dart';
import 'package:movie_app/services/firestore_services.dart';

class MovieDetailscreen extends StatefulWidget {
  final Map<String, dynamic> movie;

  MovieDetailscreen({required this.movie});

  @override
  _MovieDetailscreenState createState() => _MovieDetailscreenState();
}

class _MovieDetailscreenState extends State<MovieDetailscreen> {
  final FirestoreService _firestoreService = FirestoreService();
  double? _userRating;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserReview();
  }

  void _loadUserReview() async {
    var reviewData = await _firestoreService.getUserReview(widget.movie['id'].toString());
    if (reviewData != null) {
      setState(() {
        _userRating = reviewData['rating']?.toDouble();
        _reviewController.text = reviewData['review'] ?? "";
      });
    }
  }

  void _saveReview() async {
    String reviewText = _reviewController.text.trim();
    double rating = _userRating ?? 0;

    if (reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please write a review before saving."), backgroundColor: Colors.red),
      );
      return;
    }

    bool success = await _firestoreService.saveReview(widget.movie['id'].toString(), rating, reviewText);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Your review has been saved!"), backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save review."), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.movie['title'] ?? "No Title";
    String description = widget.movie['overview'] ?? "No description available.";
    String posterUrl = "https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.red),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(posterUrl, height: 300, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),

            Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),

            Text(description, style: TextStyle(fontSize: 16, color: Colors.white70)),
            SizedBox(height: 20),

            Text("Your Rating:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(Icons.star, color: (index < (_userRating ?? 0)) ? Colors.yellow : Colors.white),
                  onPressed: () {
                    setState(() {
                      _userRating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20),

            TextField(
              controller: _reviewController,
              maxLines: 3,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Write your review...",
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.red)),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            SizedBox(height: 10),

            Center(
              child: ElevatedButton.icon(
                onPressed: _saveReview,
                icon: Icon(Icons.save, color: Colors.white),
                label: Text("Save Review", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}