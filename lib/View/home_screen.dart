import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/View/about_screen.dart';
import 'package:movie_app/View/movie_detailscreen.dart';
import 'package:movie_app/View/profile_screen.dart';
import 'package:movie_app/View/search_screen.dart';
import 'package:movie_app/controller/movie_controller.dart';
import 'package:movie_app/view/login_screen.dart';

class HomeScreen extends StatelessWidget {
  final MovieController movieController = Get.put(MovieController());

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Movie App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Get.to(()=>SearchScreen());
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(onLogout: _logout),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: "Trending Now"),
            MovieList(controller: movieController, movieType: "trending"),

            SectionTitle(title: "Popular Movies"),
            MovieList(controller: movieController, movieType: "popular"),

            SectionTitle(title: "Now Playing"), 
            MovieList(controller: movieController, movieType: "now_playing"),
          ],
        ),
      ),
    );
  }
}

class MovieList extends StatelessWidget {
  final MovieController controller;
  final String movieType;

  MovieList({required this.controller, required this.movieType});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var movies;
      if (movieType == "trending") {
        movies = controller.trendingMovies;
      } else if (movieType == "popular") {
        movies = controller.popularMovies;
      } else if (movieType == "now_playing") {
        movies = controller.nowPlayingMovies; 
      } else {
        movies = [];
      }

      if (movies.isEmpty) {
        return SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator(color: Colors.red)),
        );
      }

      return SizedBox(
        height: 220,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            var movie = movies[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => MovieDetailscreen(movie: movie)); 
                //Navigates to details
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.4),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(2, 3),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage("https://image.tmdb.org/t/p/w500${movie['poster_path']}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
class AppDrawer extends StatelessWidget {
  final VoidCallback onLogout;

  AppDrawer({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Container(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.redAccent),
              accountName: Text(
                user?.displayName ?? "Guest User", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: null, 
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.black),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.redAccent),
              title: Text("Home", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: () {
                Get.offAll(() => HomeScreen()); 
                // Navigate to HomeScreen
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.redAccent),
              title: Text("Profile", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: () {
                Get.to(() => ProfileScreen()); 
                // Navigate to ProfileScreen
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.redAccent),
              title: Text("About", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: () {
                Get.to(() => AboutScreen());
                 // Navigate to AboutScreen
              },
            ),
            Divider(color: Colors.white54),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text("Logout", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}